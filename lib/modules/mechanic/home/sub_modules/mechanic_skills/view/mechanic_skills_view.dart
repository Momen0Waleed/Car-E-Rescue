import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_skills/view_model/mechanic_skills_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MechanicSkillsView extends StatefulWidget {
  const MechanicSkillsView({super.key});

  @override
  State<MechanicSkillsView> createState() => _MechanicSkillsViewState();
}

class _MechanicSkillsViewState extends State<MechanicSkillsView> {
  // List of available skills as requested
  final List<String> requestTypes = [
    "tiers and wheels", "Interior", "Glass", "Paint & Finish", "Body Work",
    "Preventive Maintenance", "Diagnostics", "CLIMATE CONTROL", "Drivetrain",
    "Manual Transmission", "Automatic Transmission", "Suspension & Steering",
    "Brake Systems", "Lighting & Accessories", "Computer & Sensors",
    "Battery & Charging", "Cooling System", "Exhaust System", "Fuel System",
    "Core Engine Repair", "Other",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<MechanicSkillsViewModel>(
          context,
          listen: false,
        ).loadSkills();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: defaultAppBar(title: "My Skills", context: context),
      body: Consumer<MechanicSkillsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.currentSkills.isEmpty) {
            return Center(child: CircularProgressIndicator(color: AppColors.red,));
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Current Skills:",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: vm.currentSkills
                      .map(
                        (skill) => Chip(
                      backgroundColor: AppColors.pink,
                      label: Text(skill),
                      onDeleted: () => vm.removeSkill(skill),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButton<String>(
                    hint: Text("Select a skill to add", style: theme.textTheme.bodyMedium),
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    items: requestTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        vm.addSkill(newValue);
                      }
                    },
                  ),
                ),

                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Note: Skills cannot be changed easily once set. Please ensure accuracy.",
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Set Skills",
                  color: AppColors.red,
                  action: () async {
                    final viewModel = Provider.of<MechanicSkillsViewModel>(
                      context,
                      listen: false,
                    );
                    bool skillsExist = await viewModel.hasSkills();

                    if (skillsExist && mounted) {
                      SnackbarService.showErrorNotification("Skills already set.");
                      return;
                    }

                    bool success = await vm.saveSkills();
                    if (success && mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}