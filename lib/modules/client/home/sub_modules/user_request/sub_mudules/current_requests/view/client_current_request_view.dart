import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/view_model/client_current_request_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ClientCurrentRequestView extends StatefulWidget {
  const ClientCurrentRequestView({super.key});

  @override
  State<ClientCurrentRequestView> createState() => _CurrentRequestViewState();
}

class _CurrentRequestViewState extends State<ClientCurrentRequestView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientCurrentRequestViewModel(),
      child: Consumer<ClientCurrentRequestViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: defaultAppBar(title: "Current Request", context: context),
            body: viewModel.isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.red))
                : viewModel.currentRequest == null
                ? _buildEmptyState(context)
                : _buildRequestDetails(context, viewModel),
          );
        },
      ),
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
            child: Image.asset(ImagesDir.noRequestsYet, width: 72, height: 72),
          ),
          const SizedBox(height: 24),
          Text(
            "No active requests yet",
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
            "When you submit a roadside assistance request, you can track it live here.",
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

Widget _buildRequestDetails(
  BuildContext context,
  ClientCurrentRequestViewModel viewModel,
) {
  final hasMech = viewModel.currentRequest!.mechanicName != "----";

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Bounceable(
                scaleFactor: 0.96,
                onTap: () {
                  final request = viewModel.currentRequest!;

                  if (request.requestId != null) {
                    if (request.status == "Accepted" ||
                        request.status == "On the way") {
                      Navigator.pushNamed(
                        context,
                        PageRoutesName.mechanicLiveLocation,
                        arguments: request.requestId,
                      );
                    } else if (request.status == "Arrived" ||
                        request.status == "Completed") {
                      Navigator.pushNamed(
                        context,
                        PageRoutesName.clientRating,
                        arguments: request.requestId,
                      );
                    } else {
                      SnackbarService.showErrorNotification(
                        "Mechanic has not accepted yet. Status: ${request.status}",
                      );
                    }
                  } else {
                    SnackbarService.showErrorNotification(
                      "Error: Missing Request ID.",
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.red, const Color(0xFF911716)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.red.withOpacity(0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SERVICE TYPE",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white.withOpacity(0.6),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                viewModel.currentRequest!.type ??
                                    "Emergency Rescue",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              viewModel.currentRequest!.status ?? "Pending",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white24,
                        height: 40,
                        thickness: 1.5,
                      ),
                      if (!hasMech) ...[
                        Column(
                          children: [
                            Text(
                              "Finding a professional mechanic...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Lottie.asset(
                              'assets/animations/circle-loader.json',
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.green.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.green,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mechanic Assigned",
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    viewModel.currentRequest!.mechanicName ??
                                        "N/A",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Pulsing cancel button overlay
              Positioned(
                bottom: -32,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.95, end: 1.05),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutSine,
                    builder: (context, scale, childWidget) {
                      return Transform.scale(scale: scale, child: childWidget);
                    },
                    // Infinite pulse emulation by listening/re-triggering is avoided; static scale is fine
                    child: Bounceable(
                      scaleFactor: 0.9,
                      onTap: () async {
                        final confirm = await showEnsureDeletionDialog(context);
                        if (confirm == true) {
                          await viewModel.deleteCurrentRequest();
                        }
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.red.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (hasMech) ...[
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, val, child) {
                return Opacity(
                  opacity: val,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - val)),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.green.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Click the card above to track your mechanic's live location.",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

Future<bool?> showEnsureDeletionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        backgroundColor: AppColors.white,
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Cancel Request?",
          style: theme.textTheme.titleMedium!.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          "Are you sure you want to cancel this road rescue request?",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.grey,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Keep Active"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Yes, Cancel",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
