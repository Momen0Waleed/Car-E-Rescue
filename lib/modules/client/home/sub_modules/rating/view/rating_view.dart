import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/rating_view_model.dart';

class RatingView extends StatelessWidget {
  final int requestId;

  const RatingView({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RatingViewModel(requestId: requestId),
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: NavigateBackButton(),
          ),
          title: const Text("Rate Service"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<RatingViewModel>(
          builder: (context, vm, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await vm.checkStatus();
              },
              color: AppColors.red,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      vm.isCompleted
                          ? "Service Completed!"
                          : "Mechanic has arrived.\nWaiting for service to complete...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: vm.isCompleted ? AppColors.green : AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "How was the service?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        int starValue = index + 1;
                        return IconButton(
                          icon: Icon(
                            starValue <= vm.selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 40,
                            color: starValue <= vm.selectedRating
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () {
                            vm.setRating(starValue);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      onChanged: vm.setFeedback,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write your feedback here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: (vm.isCompleted && !vm.isSubmitting)
                          ? () async {
                              bool success = await vm.submitRating();
                              if (success && context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  PageRoutesName.clientHome,
                                  (route) => false,
                                );
                              }
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: vm.isCompleted ? AppColors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: vm.isCompleted ? AppColors.green : Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            vm.isSubmitting ? "Submitting..." : "Submit Rating",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
