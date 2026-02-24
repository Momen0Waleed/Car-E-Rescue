import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_skills/view_model/mechanic_skills_view_model.dart';
import 'package:car_e_rescue/modules/mechanic/home/view_model/mechanic_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart'
    show Provider, Consumer, ChangeNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';

class MechanicHomeView extends StatefulWidget {
  const MechanicHomeView({super.key});

  @override
  State<MechanicHomeView> createState() => _MechanicHomeViewState();
}

class _MechanicHomeViewState extends State<MechanicHomeView> {
  bool workShopLocationWasSet = false;

  Future<void> _initializeMechanicHome() async {
    await _checkWorkshopStatus();
    if (!mounted) return;

    if (!workShopLocationWasSet) {
      final confirm = await setLocationDialog(context);
      if (confirm == true && mounted) {
        await Navigator.of(context).pushNamed(PageRoutesName.workshopLocation);
        _checkWorkshopStatus();
      }
    }

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

  Future<void> _checkWorkshopStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      workShopLocationWasSet = prefs.getBool('workShopLocationWasSet') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => MechanicHomeViewModel(),
      builder: (context, child) {
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
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.red,
                title: FittedBox(
                  child: Text(
                    "Welcome, ${user?.name ?? 'Mechanic'}",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                actionsPadding: EdgeInsetsGeometry.all(0),
                actions: [
                  Bounceable(
                    scaleFactor: 0.7,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(PageRoutesName.mechanicProfile);
                    },
                    child: Icon(
                      Icons.person_sharp,
                      size: 35,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: "Current Request",
                backgroundColor: AppColors.red,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    PageRoutesName.mechanicCurrentRequest,
                  );
                },
                child: Image.asset(
                  ImagesDir.activeFilled,
                  width: 30,
                  height: 30,
                  color: AppColors.white,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: Container(
                color: AppColors.red,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Switch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Available: ",
                                style: theme.textTheme.bodyLarge,
                              ),
                              Switch(
                                value: isAvailable,
                                activeThumbColor: AppColors.green,
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

                          SizedBox(height: 20),
                          Bounceable(
                            duration: Duration(milliseconds: 400),
                            scaleFactor: 0.8,
                            onTap: () async {
                              if (isAvailable == false) {
                                SnackbarService.showErrorNotification(
                                  "Be Available to View Requests",
                                );
                                return;
                              }

                              if (workShopLocationWasSet) {
                                Navigator.of(context).pushNamed(
                                  PageRoutesName.mechanicAvailableRequests,
                                );
                              } else {
                                SnackbarService.showErrorNotification(
                                  "Set your Workshop Location to View Requests",
                                );
                                Duration(seconds: 2);
                                Navigator.of(
                                  context,
                                ).pushNamed(PageRoutesName.mechanicProfile);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  "Available Requests",
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Bounceable(
                            onTap: () {
                              Navigator.of(context).pushNamed(PageRoutesName.mechanicHistory);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 135,
                              decoration: BoxDecoration(
                                  color: AppColors.pink,
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.history,color: AppColors.red,size: 40,),
                                  SizedBox(height: 8,),
                                  Text("History",style: theme.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.red,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: 30),
                          // Row(
                          //   children: [
                          //     Spacer(),
                          //     Bounceable(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const CurrentRequestView(),
                          //           ),
                          //         );
                          //       },
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(60),
                          //         child: Container(
                          //           width: 100,
                          //           height: 100,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.pink,
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               "Current\nRequest",
                          //               textAlign: TextAlign.center,
                          //               style: theme.textTheme.bodyMedium,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Future<bool?> setLocationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      var theme = Theme.of(context);
      return AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Workshop Location", style: theme.textTheme.titleMedium),
        content: Text(
          "Do you want to set the workshop location now?",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel
            },
            child: Text("Not Now", style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm
            },
            child: Text(
              "Set",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
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
