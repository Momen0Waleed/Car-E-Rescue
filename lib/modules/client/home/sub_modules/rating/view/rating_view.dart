import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_navigate_back_button.dart';
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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<RatingViewModel>(
              builder: (context, vm, _) => ClientNavigateBackButton(isCompleted: vm.isCompleted),
            ),
          ),
          title: const Text(
            "Rate Service",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Status Banner with Entry Fade
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, val, childWidget) {
                        return Opacity(
                          opacity: val,
                          child: childWidget,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: (vm.isCompleted ? AppColors.green : AppColors.red).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (vm.isCompleted ? AppColors.green : AppColors.red).withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          vm.isCompleted
                              ? "Service Completed!"
                              : "Mechanic has arrived.\nWaiting for service to complete...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: vm.isCompleted ? AppColors.green : AppColors.red,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "How was the service?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Star Rating selector with pop-scale interactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        int starValue = index + 1;
                        final isStarred = starValue <= vm.selectedRating;
                        
                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 1.0, end: isStarred ? 1.25 : 1.0),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          builder: (context, scaleVal, childWidget) {
                            return Transform.scale(
                              scale: scaleVal,
                              child: childWidget,
                            );
                          },
                          child: IconButton(
                            icon: Icon(
                              isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 44,
                              color: isStarred ? Colors.amber : AppColors.grey.withOpacity(0.6),
                            ),
                            onPressed: () {
                              vm.setRating(starValue);
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 35),
                    
                    // Modernized Feedback box
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: vm.setFeedback,
                        maxLines: 4,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Write your feedback here (Optional)...",
                          hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.7), fontWeight: FontWeight.w500),
                          fillColor: AppColors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.grey.withOpacity(0.25),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    ClientCustomButton(
                      color: vm.isCompleted ? AppColors.green : AppColors.grey.withOpacity(0.3),
                      textColor: vm.isCompleted ? AppColors.white : AppColors.grey,
                      action: vm.isCompleted
                          ? () async {
                              if (!vm.isSubmitting) {
                                bool success = await vm.submitRating();
                                if (success && context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    PageRoutesName.clientHome,
                                    (route) => false,
                                  );
                                }
                              }
                            }
                          : null,
                      text: vm.isSubmitting ? "Submitting..." : "Submit Rating",
                      useGradient: vm.isCompleted,
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

