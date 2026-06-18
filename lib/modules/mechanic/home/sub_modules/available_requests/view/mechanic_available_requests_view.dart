import 'dart:async';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/view/request_details_view.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
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
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MechanicAvailableRequestsViewModel>().getRequests();
      _startPeriodicRefresh();
    });
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        context.read<MechanicAvailableRequestsViewModel>().getRequests(showLoading: false);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: defaultAppBar(title: "Available Requests", context: context),
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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
              itemCount: vm.requests.length,
              itemBuilder: (context, index) {
                final request = vm.requests[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, childWidget) {
                    return Opacity(
                      opacity: val,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - val)),
                        child: childWidget,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.grey.withOpacity(0.12),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.userName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Type: ${request.type}",
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Distance: ${request.distance.toStringAsFixed(2)} km",
                                    style: TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Bounceable(
                              scaleFactor: 0.9,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RequestDetailsView(request: request),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.red.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "View",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
