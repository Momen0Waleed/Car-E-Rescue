import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../view_model/mechanic_current_request_view_model.dart';

class MechanicCurrentRequestView extends StatelessWidget {
  const MechanicCurrentRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MechanicCurrentRequestViewModel(),
      child: Consumer<MechanicCurrentRequestViewModel>(
        builder: (context, vm, child) {
          if (!vm.isLoading &&
              vm.currentRequest == null &&
              vm.errorMessage == null) {
            Future.microtask(() => vm.getCurrentRequest());
          }

          return Scaffold(
            floatingActionButton: const NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: _buildBody(context, vm),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MechanicCurrentRequestViewModel vm) {
    if (vm.isLoading) return Center(child: CircularProgressIndicator(color: AppColors.red,));

    if (vm.errorMessage != null) {
      return _buildErrorState(context, vm);
    }

    if (vm.errorMessage != null && vm.errorMessage!.contains("Tracking suspended")) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(vm.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => vm.getCurrentRequest(),
              child: const Text("Retry Connection"),
            )
          ],
        ),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Text(
          vm.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (vm.currentRequest == null) {
      return const Center(child: Text("You have no active requests."));
    }

    final request = vm.currentRequest!;
    final location = LatLng(request.lat, request.lng);

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: location, initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.car_e_rescue',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: location,
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.person_pin_circle,
                    color: AppColors.red,
                    size: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 15,
          right: 15,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Active Request",
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(request.userName),
                    subtitle: Text("Service: ${request.type}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () {
                        /* Implement call logic */
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.red,
                  //       minimumSize: const Size(double.infinity, 50)
                  //   ),
                  //   onPressed: () { /* Implement complete logic */ },
                  //   child: const Text("Complete Request", style: TextStyle(color: Colors.white)),
                  // )
                  CustomButton(
                    color: AppColors.red,
                    action: vm.isActionLoading
                        ? () {}
                        : () async {
                      final confirm = await showCancelConfirmationDialog(context);
                      if (confirm == true) {
                        bool success = await vm.cancelCurrentRequest();
                        if (success && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    text: vm.isActionLoading ? "Canceling..." : "Cancel Request",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> showCancelConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        var theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Confirm Cancellation", style: theme.textTheme.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to cancel this request?",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                "Note: Canceling the current request will affect your total rating.",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Stay", style: theme.textTheme.bodyMedium),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "Cancel Request",
                style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildErrorState(BuildContext context, MechanicCurrentRequestViewModel vm) {
  var theme = Theme.of(context);

  // Check if the error is actually just "No request"
  bool isNoRequest = vm.errorMessage != null && vm.errorMessage!.contains("no request");

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
             Icons.hourglass_empty_rounded,
              size: 80,
              color: AppColors.grey
          ),
          const SizedBox(height: 20),

          Text(
            "No Active Requests" ,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Text(
            "You don't have any active rescue requests at the moment. New requests will appear here once you accept them.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),

          if (!isNoRequest)
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                color: AppColors.red,
                action: () => Navigator.of(context).pushNamed(PageRoutesName.mechanicAvailableRequests),
                text:"View Available Requests",
              ),
            ),
        ],
      ),
    ),
  );
}