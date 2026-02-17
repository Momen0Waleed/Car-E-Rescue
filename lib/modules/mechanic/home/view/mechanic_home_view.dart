import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/mechanic/home/view_model/mechanic_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart' show Provider, Consumer, ChangeNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';

class MechanicHomeView extends StatefulWidget {
  const MechanicHomeView({super.key});

  @override
  State<MechanicHomeView> createState() => _MechanicHomeViewState();
}

class _MechanicHomeViewState extends State<MechanicHomeView> {
  bool available = false;
  bool workShopLocationWasSet = false;
  @override
  void initState() {
    super.initState();
    _checkWorkshopStatus();
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
      create: (_) => MechanicHomeViewModel() ,
      child: Consumer<MechanicHomeViewModel>(
        builder: ( context,  viewModel,  child) {
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
                    Navigator.of(context).pushNamed(PageRoutesName.mechanicProfile);
                  },
                  child: Icon(Icons.person_sharp, size: 35, color: AppColors.white),
                ),
                SizedBox(width: 20),
              ],
            ),
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
                            Text("Available: ", style: theme.textTheme.bodyLarge),
                            Switch(
                              value: available,
                              activeThumbColor: AppColors.green,
                              onChanged: (bool value) async{
                                bool success = await viewModel.toggleAvailability(value);
                                if (success) {
                                  setState(() {
                                    available = value;
                                  });
                                } else {
                                  SnackbarService.showErrorNotification("Failed to update status");
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
                            if (available == false) {
                              SnackbarService.showErrorNotification("Be Available to View Requests");
                              return;
                            }

                            // Refresh status from prefs
                            final prefs = await SharedPreferences.getInstance();
                            workShopLocationWasSet = prefs.getBool('workShopLocationWasSet') ?? false;

                            // Inside "Available Requests" onTap:
                            if (workShopLocationWasSet) {
                              Navigator.of(context).pushNamed(PageRoutesName.mechanicAvailableRequests);
                            } else {
                              // Use workshopLocation to avoid the MechanicDataModel crash
                              final result = await Navigator.of(context).pushNamed(PageRoutesName.workshopLocation);
                              if (result == true) {
                                setState(() => workShopLocationWasSet = true);
                              }
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
  }
}
