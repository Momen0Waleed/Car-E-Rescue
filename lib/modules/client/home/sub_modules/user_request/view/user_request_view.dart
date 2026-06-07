// ignore_for_file: avoid_print

import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/view_model/client_current_request_view_model.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class UserRequestView extends StatefulWidget {
  const UserRequestView({super.key});

  @override
  State<UserRequestView> createState() => _UserRequestViewState();
}

class _UserRequestViewState extends State<UserRequestView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: defaultAppBar(title: "Request Options", context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Create New Request Card with slide animation
              _buildCascadeCard(
                delayMs: 0,
                child: Bounceable(
                  scaleFactor: 0.95,
                  onTap: () async {
                    try {
                      EasyLoading.show(status: 'Checking active status...');
                      final currentReqVM =
                          Provider.of<ClientCurrentRequestViewModel>(
                            context,
                            listen: false,
                          );
                      bool activeExists = await currentReqVM.hasActiveRequest();
                      EasyLoading.dismiss();

                      if (activeExists) {
                        SnackbarService.showErrorNotification(
                          "You already have a request.\nCancel it to make a new one",
                        );
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamed(PageRoutesName.clientCurrentRequest);
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamed(PageRoutesName.createRequest);
                        }
                      }
                    } catch (e) {
                      print(e);
                      SnackbarService.showErrorNotification(
                        "Error checking status: $e",
                      );
                    } finally {
                      EasyLoading.dismiss();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.green, const Color(0xFF008000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withOpacity(0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_location_alt_rounded,
                            color: AppColors.white,
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Create New Request",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Get connected with a nearby mechanic now",
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. View Available Mechanics Card
              _buildCascadeCard(
                delayMs: 100,
                child: Bounceable(
                  scaleFactor: 0.95,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(PageRoutesName.availableMech);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 135,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.pink,
                          AppColors.pink.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              ImagesDir.mechanicIcon,
                              width: 32,
                              height: 32,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Available Mechanics",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Browse local workshops on the map",
                                  style: TextStyle(
                                    color: AppColors.red.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.red.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Row containing History and Current Requests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // History Column
                  Expanded(
                    child: _buildCascadeCard(
                      delayMs: 200,
                      child: Bounceable(
                        scaleFactor: 0.95,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(PageRoutesName.requestHistory);
                        },
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.pink.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.history_rounded,
                                  color: AppColors.red,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Request History",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Current Requests Column
                  Expanded(
                    child: _buildCascadeCard(
                      delayMs: 300,
                      child: Bounceable(
                        scaleFactor: 0.95,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(PageRoutesName.clientCurrentRequest);
                        },
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.pink.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  ImagesDir.currentRequestIcon,
                                  width: 28,
                                  height: 28,
                                  // color: AppColors.red,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Active Tracker",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCascadeCard({required int delayMs, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 30.0, end: 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, val, childWidget) {
        return Transform.translate(
          offset: Offset(0, val),
          child: Opacity(
            opacity: ((30.0 - val) / 30.0).clamp(0.0, 1.0),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
}
