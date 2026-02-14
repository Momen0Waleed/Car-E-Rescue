import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/view_model/available_mech_view_model.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
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
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => AvailableMechViewModel(),
      child: Consumer<AvailableMechViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            floatingActionButton: NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Service Type", style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.red, width: 2),
                    ),
                    child: DropdownButton<String>(
                      value: vm.selectedRequestType,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      items: vm.requestTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: theme.textTheme.bodyMedium),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) vm.updateRequestType(newValue);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: vm.isLoading
                        ? Center(child: CircularProgressIndicator(color: AppColors.red,))
                        : vm.mechanics.isEmpty
                        ? const Center(
                            child: Text("No mechanics found for this type"),
                          )
                        : MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              itemCount: vm.mechanics.length,
                              itemBuilder: (context, index) {
                                final mechanic = vm.mechanics[index];
                                return Bounceable(
                                  onTap: (){
                                    Navigator.of(context).pushNamed(PageRoutesName.mechanicLocation,arguments: mechanic);
                                  },
                                  child: Card(
                                    color: AppColors.pink,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.build_circle,
                                        color: AppColors.red,
                                      ),
                                      title: Text(mechanic.workshopName),
                                      subtitle: Text(
                                        "${mechanic.distanceInKm.toStringAsFixed(1)} km away",
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: AppColors.red,
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
