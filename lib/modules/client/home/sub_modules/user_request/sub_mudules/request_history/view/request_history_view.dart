import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/request_history/view_model/request_history_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestHistoryView extends StatefulWidget {
  const RequestHistoryView({super.key});

  @override
  State<RequestHistoryView> createState() => _RequestHistoryViewState();
}

class _RequestHistoryViewState extends State<RequestHistoryView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RequestHistoryViewModel(),
      child: Consumer<RequestHistoryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            floatingActionButton: NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: viewModel.isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.red))
                : viewModel
                      .historyRequests
                      .isEmpty // Check for empty list
                ? _buildEmptyState(context)
                : _buildHistoryList(context, viewModel),
          );
        },
      ),
    );
  }
}

Widget _buildEmptyState(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have no completed/canceled requests yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            width: MediaQuery.of(context).size.width / 1.5,
            action: () =>
                Navigator.of(context).pushNamed(PageRoutesName.createRequest),
            text: "Create a New Request",
            color: AppColors.red,
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
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
    itemCount: viewModel.historyRequests.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return const SizedBox(height: 120);
      }

      final request = viewModel.historyRequests[index - 1];

      final Color cardColor = request.status.toLowerCase() == "completed"
          ? Colors.green
          : AppColors.red;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor, // Dynamic color applied here
            borderRadius: BorderRadius.circular(25),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type: ${request.type}", style: _cardTextStyle()),
                      const SizedBox(height: 10),
                      Text(
                        "Status: ${request.status}",
                        style: _cardTextStyle(),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(color: Colors.white24, thickness: 1),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Mechanic",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        request.mechanicName ?? "N/A",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: cardColor,
                          minimumSize: const Size(80, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: () =>
                            _showRatingSheet(context, viewModel, request),
                        child: Text(
                          viewModel.userRatings.containsKey(request.requestId)
                              ? "Edit Rating"
                              : "Rate",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
      );
    },
  );
}

TextStyle _cardTextStyle() => const TextStyle(
  fontSize: 14,
  fontFamily: "Poppins",
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

void _showRatingSheet(
  BuildContext context,
  RequestHistoryViewModel viewModel,
  UserRequestModel request,
) {
  final existingRating = viewModel.userRatings[request.requestId];
  int selectedRate = existingRating?.rate ?? 0;
  TextEditingController feedbackController = TextEditingController(
    text: existingRating?.feedback ?? "",
  );
  bool isSubmitting = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existingRating == null ? "Rate Mechanic" : "Edit Rating",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int starValue = index + 1;
                      return IconButton(
                        icon: Icon(
                          starValue <= selectedRate
                              ? Icons.star
                              : Icons.star_border,
                          size: 40,
                          color: starValue <= selectedRate
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRate = starValue;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Feedback...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  isSubmitting
                      ? CircularProgressIndicator(color: AppColors.red)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (existingRating != null)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  setState(() => isSubmitting = true);
                                  bool ok = await viewModel.deleteRating(
                                    existingRating.ratingId,
                                    request.requestId!,
                                  );
                                  if (ok && context.mounted)
                                    Navigator.pop(context);
                                  setState(() => isSubmitting = false);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                              ),
                              onPressed: () async {
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
                                  // Snackbar handles it in repo mostly or we can show here
                                } finally {
                                  setState(() => isSubmitting = false);
                                }
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
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
