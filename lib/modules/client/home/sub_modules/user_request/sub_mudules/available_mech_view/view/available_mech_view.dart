import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/view_model/available_mech_view_model.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class AvailableMechView extends StatefulWidget {
  const AvailableMechView({super.key});

  @override
  State<AvailableMechView> createState() => _AvailableMechViewState();
}

class _AvailableMechViewState extends State<AvailableMechView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvailableMechViewModel(),
      child: Consumer<AvailableMechViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: defaultAppBar(title: "Available Mechanics", context: context),
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Horizontal Pill Selector
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.requestTypes.length,
                      itemBuilder: (context, index) {
                        final type = vm.requestTypes[index];
                        final isSelected = vm.selectedRequestType == type;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Bounceable(
                            scaleFactor: 0.95,
                            onTap: () => vm.updateRequestType(type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.red : AppColors.grey.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.red : Colors.transparent,
                                  width: 1.5,
                                ),
                                boxShadow: isSelected 
                                    ? [
                                        BoxShadow(
                                          color: AppColors.red.withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.white : AppColors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mechanics list with fade-in slide entries
                  Expanded(
                    child: vm.isLoading
                        ? Center(child: CircularProgressIndicator(color: AppColors.red))
                        : vm.mechanics.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off_rounded, color: AppColors.grey, size: 48),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No mechanics found for this type",
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: vm.mechanics.length,
                                  itemBuilder: (context, index) {
                                    final mechanic = vm.mechanics[index];
                                    
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0.0, end: 1.0),
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, val, childWidget) {
                                        return Opacity(
                                          opacity: val,
                                          child: Transform.translate(
                                            offset: Offset(0, 20 * (1 - val)),
                                            child: childWidget,
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Bounceable(
                                          scaleFactor: 0.97,
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              PageRoutesName.mechanicLocation,
                                              arguments: mechanic,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black.withOpacity(0.04),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: AppColors.grey.withOpacity(0.12),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              leading: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: AppColors.pink.withOpacity(0.35),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.build_circle_rounded,
                                                  color: AppColors.red,
                                                  size: 24,
                                                ),
                                              ),
                                              title: Text(
                                                mechanic.workshopName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  "${mechanic.distanceInKm.toStringAsFixed(1)} km away",
                                                  style: TextStyle(
                                                    color: AppColors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 14,
                                                color: AppColors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

