import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.vm});
  final CreateRequestViewModel vm;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  IconData _getServiceIcon(String serviceType) {
    final s = serviceType.toLowerCase();
    if (s.contains("towing") || s.contains("pull")) {
      return Icons.local_shipping_rounded;
    } else if (s.contains("battery") || s.contains("charge")) {
      return Icons.battery_charging_full_rounded;
    } else if (s.contains("fuel") || s.contains("gas")) {
      return Icons.local_gas_station_rounded;
    } else if (s.contains("tire") || s.contains("wheel")) {
      return Icons.build_circle_rounded;
    } else if (s.contains("electrical") || s.contains("wire")) {
      return Icons.electrical_services_rounded;
    } else if (s.contains("mechanical") || s.contains("engine")) {
      return Icons.engineering_rounded;
    }
    return Icons.build_rounded;
  }

  String _getServiceDescription(String serviceType) {
    final s = serviceType.toLowerCase();
    if (s.contains("towing") || s.contains("pull")) {
      return "Flatbed transport for disabled vehicles";
    } else if (s.contains("battery") || s.contains("charge")) {
      return "Jump start or replacement for dead batteries";
    } else if (s.contains("fuel") || s.contains("gas")) {
      return "Emergency fuel top-up delivered to you";
    } else if (s.contains("tire") || s.contains("wheel")) {
      return "Puncture repair or spare tire fitting";
    } else if (s.contains("electrical") || s.contains("wire")) {
      return "Troubleshoot wiring, sensors, and fuses";
    } else if (s.contains("mechanical") || s.contains("engine")) {
      return "Diagnostics for engine noise, brakes, etc.";
    }
    return "Professional roadside assistance and repairs";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Service Type",
            style: theme.textTheme.titleMedium!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.vm.requestTypes.length,
              itemBuilder: (context, index) {
                final service = widget.vm.requestTypes[index];
                final isSelected = widget.vm.selectedRequestType == service;
                final serviceIcon = _getServiceIcon(service);
                final serviceDesc = _getServiceDescription(service);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Bounceable(
                    scaleFactor: 0.96,
                    onTap: () {
                      widget.vm.updateRequestType(service);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.pink.withOpacity(0.25) : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.red : AppColors.grey.withOpacity(0.12),
                          width: isSelected ? 2 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                                ? AppColors.red.withOpacity(0.06) 
                                : AppColors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.red.withOpacity(0.1) : AppColors.grey.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              serviceIcon,
                              color: isSelected ? AppColors.red : AppColors.grey,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.red : AppColors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  serviceDesc,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected 
                                        ? AppColors.red.withOpacity(0.75) 
                                        : AppColors.grey.withOpacity(0.85),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.red,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

