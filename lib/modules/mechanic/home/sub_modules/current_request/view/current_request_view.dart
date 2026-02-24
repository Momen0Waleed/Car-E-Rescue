import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../view_model/current_request_view_model.dart';

class CurrentRequestView extends StatelessWidget {
  const CurrentRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentRequestViewModel(),
      // We use a Builder or Consumer here to get a context
      // that is a child of the ChangeNotifierProvider
      child: Consumer<CurrentRequestViewModel>(
        builder: (context, vm, child) {
          // Trigger the fetch if data is not yet loaded and no error occurred
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

  Widget _buildBody(BuildContext context, CurrentRequestViewModel vm) {
    if (vm.isLoading) return const Center(child: CircularProgressIndicator());

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
                    action: () {
                      ///TODO: Cancel Request

                    },
                    text: "Cancel Request",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
