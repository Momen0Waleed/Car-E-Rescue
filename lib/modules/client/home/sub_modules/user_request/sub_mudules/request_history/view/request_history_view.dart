// ignore_for_file: deprecated_member_use

import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/request_history/view_model/request_history_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class RequestHistoryView extends StatefulWidget {
  const RequestHistoryView({super.key});

  @override
  State<RequestHistoryView> createState() => _RequestHistoryViewState();
}

class _RequestHistoryViewState extends State<RequestHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestHistoryViewModel>().loadRequestHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestHistoryViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: defaultAppBar(title: "Request History", context: context),
          body: viewModel.isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.red))
              : viewModel.historyRequests.isEmpty
              ? _buildEmptyState(context)
              : _buildHistoryList(context, viewModel),
        );
      },
    );
  }
}

Widget _buildEmptyState(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, size: 72, color: AppColors.red),
          ),
          const SizedBox(height: 24),
          Text(
            "No rescue history",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your completed and canceled rescue requests will show up here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ClientCustomButton(
            width: MediaQuery.of(context).size.width / 1.5,
            action: () =>
                Navigator.of(context).pushNamed(PageRoutesName.createRequest),
            text: "Create New Request",
            color: AppColors.red,
            useGradient: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildHistoryList(
  BuildContext context,
  RequestHistoryViewModel viewModel,
) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
    itemCount: viewModel.historyRequests.length,
    itemBuilder: (context, index) {
      final request = viewModel.historyRequests[index];
      final isCompleted = request.status.toLowerCase() == "completed";
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
                    // Status vertical line indicator
                    Container(width: 6, color: statusColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 11,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    request.type ?? "Emergency Rescue",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: statusColor,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          request.status.replaceFirst(
                                            RegExp(
                                              r'Cancel(l)?ed by',
                                              caseSensitive: false,
                                            ),
                                            'Canceled\nby',
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
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
                            Expanded(
                              flex: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mechanic",
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    request.mechanicName ?? "N/A",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Bounceable(
                                    scaleFactor: 0.9,
                                    onTap: () => _showRatingSheet(
                                      context,
                                      viewModel,
                                      request,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.green.withOpacity(0.1)
                                            : AppColors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        viewModel.userRatings.containsKey(
                                              request.requestId,
                                            )
                                            ? "Edit Rating"
                                            : "Rate",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
  );
}

void _showRatingSheet(
  BuildContext context,
  RequestHistoryViewModel viewModel,
  UserRequestModel request,
) {
  final existingRating = viewModel.userRatings[request.requestId];
  int selectedRate = existingRating?.rate ?? 0;
  final feedbackController = TextEditingController(
    text: existingRating?.feedback ?? "",
  );
  bool isSubmitting = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bottom sheet handle indicator
                  Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    existingRating == null ? "Rate Mechanic" : "Edit Rating",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interactive Star Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int starValue = index + 1;
                      final isStarred = starValue <= selectedRate;

                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 1.0,
                          end: isStarred ? 1.2 : 1.0,
                        ),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, val, child) {
                          return Transform.scale(scale: val, child: child);
                        },
                        child: IconButton(
                          icon: Icon(
                            isStarred
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 40,
                            color: isStarred
                                ? Colors.amber
                                : AppColors.grey.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRate = starValue;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "Write your feedback here...",
                      hintStyle: TextStyle(
                        color: AppColors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.grey.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (isSubmitting)
                    Center(
                      child: CircularProgressIndicator(color: AppColors.red),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (existingRating != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClientCustomButton(
                                color: AppColors.red,
                                action: () async {
                                  setState(() => isSubmitting = true);
                                  bool ok = await viewModel.deleteRating(
                                    existingRating.ratingId,
                                    request.requestId!,
                                  );
                                  if (ok && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  setState(() => isSubmitting = false);
                                },
                                text: "Delete",
                                textColor: AppColors.white,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ClientCustomButton(
                              color: AppColors.green,
                              action: () async {
                                if (selectedRate == 0) return;
                                setState(() => isSubmitting = true);
                                try {
                                  final ratingRepo = RatingRepo();
                                  if (existingRating == null) {
                                    await ratingRepo.submitRating(
                                      requestId: request.requestId!,
                                      rateNum: selectedRate,
                                      feedback: feedbackController.text,
                                    );
                                  } else {
                                    await ratingRepo.updateRating(
                                      ratingId: existingRating.ratingId,
                                      rateNum: selectedRate,
                                      feedback: feedbackController.text,
                                    );
                                  }
                                  await viewModel.fetchRatings();
                                  viewModel.notifyListeners();
                                  if (context.mounted) Navigator.pop(context);
                                } catch (e) {
                                  // Logged or handled inside rating library
                                } finally {
                                  setState(() => isSubmitting = false);
                                }
                              },
                              text: "Submit",
                              textColor: AppColors.white,
                              useGradient: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
