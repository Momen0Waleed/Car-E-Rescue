import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_skills/view_model/mechanic_skills_view_model.dart';
import 'package:car_e_rescue/modules/mechanic/home/view_model/mechanic_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart'
    show Provider, Consumer;

class MechanicHomeView extends StatefulWidget {
  const MechanicHomeView({super.key});

  @override
  State<MechanicHomeView> createState() => _MechanicHomeViewState();
}

class _MechanicHomeViewState extends State<MechanicHomeView> {
  Future<void> _initializeMechanicHome() async {
    if (!mounted) return;

    final viewModel = Provider.of<MechanicSkillsViewModel>(
      context,
      listen: false,
    );
    bool skillsExist = await viewModel.hasSkills();

    if (!skillsExist && mounted) {
      final goToSkills = await setSkillsDialog(context);
      if (goToSkills == true && mounted) {
        Navigator.of(context).pushNamed(PageRoutesName.mechanicSkills);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    var theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<MechanicHomeViewModel>(context, listen: false);
      if (vm.mechanicProfile == null && !vm.isLoading) {
        vm.getMechanicProfile().then((_) => _initializeMechanicHome());
      }
    });
    return Consumer<MechanicHomeViewModel>(
      builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.mechanicProfile == null) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.red),
                ),
              );
            }
            bool isAvailable = viewModel.mechanicProfile?.available ?? false;
            return Scaffold(
              backgroundColor: AppColors.red,
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Welcome, ${user?.name ?? 'Mechanic'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Bounceable(
                      scaleFactor: 0.85,
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(PageRoutesName.mechanicProfile);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withOpacity(0.2),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///Switch
                          _buildSlideUpCard(
                            delayMs: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.grey.withOpacity(0.15),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Available : ",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isAvailable
                                          ? AppColors.green
                                          : AppColors.red,
                                    ),
                                  ),
                                  Switch(
                                    value: isAvailable,
                                    activeColor: AppColors.green,
                                    activeTrackColor: AppColors.green
                                        .withOpacity(0.3),
                                    inactiveThumbColor: AppColors.red,
                                    inactiveTrackColor: AppColors.red
                                        .withOpacity(0.3),
                                    onChanged: (bool value) async {
                                      bool success = await viewModel
                                          .toggleAvailability(value);
                                      if (success) {
                                        viewModel.getMechanicProfile();
                                      } else {
                                        SnackbarService.showErrorNotification(
                                          "Failed to update status",
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSlideUpCard(
                            delayMs: 150,
                            child: Bounceable(
                              duration: const Duration(milliseconds: 300),
                              scaleFactor: 0.95,
                               onTap: () async {
                                if (isAvailable == false) {
                                  SnackbarService.showErrorNotification(
                                    "Be Available to View Requests",
                                  );
                                  return;
                                }

                                Navigator.of(context).pushNamed(
                                  PageRoutesName.mechanicAvailableRequests,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.red,
                                      const Color(0xFF9E1F1E),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.red.withOpacity(0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Available Requests",
                                              style: theme.textTheme.titleLarge!
                                                  .copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "View and accept roadside rescue requests",
                                              style: TextStyle(
                                                color: AppColors.white
                                                    .withOpacity(0.8),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withOpacity(
                                            0.2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.assignment_outlined,
                                          color: AppColors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildSlideUpCard(
                            delayMs: 300,
                            child: Bounceable(
                              duration: const Duration(milliseconds: 300),
                              scaleFactor: 0.95,
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(PageRoutesName.mechanicHistory);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 125,
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
                                  padding: const EdgeInsets.all(22.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "History",
                                              style: theme
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: AppColors.red,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Check your past completed/canceled rescues",
                                              style: TextStyle(
                                                color: AppColors.red
                                                    .withOpacity(0.7),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.red.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.history_rounded,
                                          color: AppColors.red,
                                          size: 28,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildSlideUpCard(
                            delayMs: 450,
                            child: Bounceable(
                              duration: const Duration(milliseconds: 300),
                              scaleFactor: 0.95,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PageRoutesName.mechanicCurrentRequest,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.green,
                                      const Color(0xFF008A00),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.green.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.explore_rounded,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Current Request",
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                            color: AppColors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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

  Widget _buildSlideUpCard({required int delayMs, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 40.0, end: 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, val, childWidget) {
        return Transform.translate(
          offset: Offset(0, val),
          child: Opacity(
            opacity: ((40.0 - val) / 40.0).clamp(0.0, 1.0),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
}


Future<bool?> setSkillsDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      var theme = Theme.of(context);
      return AlertDialog(
        title: Text("Skills Missing", style: theme.textTheme.titleMedium),
        content: Text("You need to set your skills before receiving requests."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Set Now", style: TextStyle(color: AppColors.white)),
          ),
        ],
      );
    },
  );
}
