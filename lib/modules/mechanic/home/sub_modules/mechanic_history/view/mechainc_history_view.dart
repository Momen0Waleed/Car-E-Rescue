// ignore_for_file: deprecated_member_use

import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
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
            floatingActionButton: const NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: vm.isLoading
                ?  Center(child: CircularProgressIndicator(color: AppColors.red,))
                : vm.errorMessage != null
                ? Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)))
                : vm.historyRequests.isEmpty
                ? const Center(child: Text("No history records found."))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
              itemCount: vm.historyRequests.length,
              itemBuilder: (context, index) {
                final request = vm.historyRequests[index];
                final bool isCompleted = request.status == "Completed";

                return Card(
                  color: AppColors.pink,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(request.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Service: ${request.type}"),
                        Text("Date: ${request.createdAt.toString().split(' ')[0]}"),
                        Text("Completed: ${request.completedAt == "----" ? "No" : "Yes"}"),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.green.withOpacity(0.1) : AppColors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          color: isCompleted ? AppColors.green : AppColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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