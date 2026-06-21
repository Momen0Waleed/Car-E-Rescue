// ignore_for_file: deprecated_member_use

import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/mechainc_history_view_model.dart';

class MechaincHistoryView extends StatefulWidget {
  const MechaincHistoryView({super.key});

  @override
  State<MechaincHistoryView> createState() => _MechaincHistoryViewState();
}

class _MechaincHistoryViewState extends State<MechaincHistoryView> {
  late MechaincHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MechaincHistoryViewModel();
    // This triggers ONLY once when the screen opens
    _viewModel.getHistory();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<MechaincHistoryViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: defaultAppBar(title: "History", context: context),
            body: vm.isLoading
                ?  Center(child: CircularProgressIndicator(color: AppColors.red,))
                : vm.errorMessage != null
                ? Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)))
                : vm.historyRequests.isEmpty
                ? const Center(child: Text("No history records found."))
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 20),
              itemCount: vm.historyRequests.length,
              itemBuilder: (context, index) {
                final request = vm.historyRequests[index];
                final bool isCompleted = request.status == "Completed";
                final Color statusColor = isCompleted ? AppColors.green : AppColors.red;

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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(width: 6, color: statusColor),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              request.userName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Service: ${request.type}",
                                              style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Date: ${request.createdAt.toString().split(' ')[0]}",
                                              style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Completed: ${request.completedAt == "----" ? "No" : "Yes"}",
                                              style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.black12,
                                        thickness: 1.2,
                                        indent: 4,
                                        endIndent: 4,
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          request.status,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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