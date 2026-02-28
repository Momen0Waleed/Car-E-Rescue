import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/view/request_details_view.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/mechanic_available_requests_view_model.dart';

class MechanicAvailableRequestsView extends StatefulWidget {
  const MechanicAvailableRequestsView({super.key});

  @override
  State<MechanicAvailableRequestsView> createState() =>
      _MechanicAvailableRequestsViewState();
}

class _MechanicAvailableRequestsViewState
    extends State<MechanicAvailableRequestsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MechanicAvailableRequestsViewModel>().getRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Available Requests"),
      //   centerTitle: true,
      //   backgroundColor: AppColors.red,
      //   foregroundColor: Colors.white,
      // ),
      floatingActionButton: const NavigateBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Consumer<MechanicAvailableRequestsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.red,));
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (vm.requests.isEmpty) {
            return const Center(child: Text("No requests found nearby."));
          }

          return RefreshIndicator(
            onRefresh: () => vm.getRequests(),
            color: AppColors.red,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 100),
              itemCount: vm.requests.length,
              itemBuilder: (context, index) {
                final request = vm.requests[index];
                return Card(
                  color: AppColors.pink,
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      request.userName,
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text("Type: ${request.type}"),
                        Text(
                          "Distance: ${request.distance.toStringAsFixed(2)} km",
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestDetailsView(request: request),
                          ),
                        );
                      },
                      child: const Text(
                        "View",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
