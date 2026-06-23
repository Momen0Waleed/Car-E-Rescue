import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_sensor_data_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/view_model/user_diagnose_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class UserDiagnoseView extends StatefulWidget {
  final bool showBackButton;
  const UserDiagnoseView({super.key, this.showBackButton = true});

  @override
  State<UserDiagnoseView> createState() => _UserDiagnoseViewState();
}

class _UserDiagnoseViewState extends State<UserDiagnoseView>
    with SingleTickerProviderStateMixin {
  final UserDiagnoseViewModel _viewModel = UserDiagnoseViewModel();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  IconData _getMetricIcon(String label) {
    final l = label.toLowerCase();
    if (l.contains("rpm")) return Icons.speed_rounded;
    if (l.contains("speed")) return Icons.directions_car_rounded;
    if (l.contains("coolant") || l.contains("temp"))
      return Icons.thermostat_rounded;
    if (l.contains("battery") || l.contains("volt"))
      return Icons.offline_bolt_rounded;
    if (l.contains("fuel")) return Icons.local_gas_station_rounded;
    if (l.contains("throttle")) return Icons.settings_input_hdmi_rounded;
    if (l.contains("ambient")) return Icons.cloud_queue_rounded;
    if (l.contains("oil")) return Icons.oil_barrel_rounded;
    if (l.contains("runtime")) return Icons.timer_outlined;
    return Icons.analytics_outlined;
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains("disconnected")) return AppColors.red;
    if (s.contains("connected")) return AppColors.green;
    if (s.contains("connecting") || s.contains("scanning"))
      return AppColors.yellow;
    return AppColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: defaultAppBar(
        title: "OBD2 Diagnostics",
        context: context,
        showBackButton: widget.showBackButton,
      ),
      body: StreamBuilder<ObdSensorDataModel>(
        stream: _viewModel.sensorDataStream,
        initialData: ObdSensorDataModel(),
        builder: (context, snapshot) {
          final data = snapshot.data!;
          final metrics = [
            _MetricItem("Engine RPM", data.rpm, "RPM"),
            _MetricItem("Vehicle Speed", data.speed, "km/h"),
            _MetricItem("Coolant Temp", data.coolantTemp, "°C"),
            _MetricItem("Battery Voltage", data.voltage, "V"),
            _MetricItem("Fuel Level", data.fuelLevel, "%"),
            _MetricItem("Throttle Position", data.throttle, "%"),
            _MetricItem("Ambient Air Temp", data.ambientTemp, "°C"),
            _MetricItem("Oil Temp", data.oilTemp, "°C"),
            _MetricItem("Runtime", data.runtime, "min"),
          ];

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Pulse status block
                  StreamBuilder<String>(
                    stream: _viewModel.statusStream,
                    initialData: "Disconnected",
                    builder: (c, s) {
                      final status = s.data ?? "Disconnected";
                      final color = _getStatusColor(status);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            ScaleTransition(
                              scale: Tween<double>(begin: 0.8, end: 1.1)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _pulseController,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.4),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Sensor Status: $status",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color == AppColors.grey
                                    ? AppColors.black.withOpacity(0.7)
                                    : color,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Metrics Grid
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.25,
                          ),
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        final item = metrics[index];
                        final isAlert =
                            item.value != "0" &&
                            item.value != "N/A" &&
                            ((item.label.contains("Temp") &&
                                    double.tryParse(item.value) != null &&
                                    double.parse(item.value) > 105) ||
                                (item.label.contains("Voltage") &&
                                    double.tryParse(item.value) != null &&
                                    double.parse(item.value) < 11.5));

                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutCubic,
                          builder: (context, val, childWidget) {
                            return Opacity(
                              opacity: val,
                              child: Transform.scale(
                                scale: 0.9 + (val * 0.1),
                                child: childWidget,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isAlert
                                    ? AppColors.red.withOpacity(0.5)
                                    : AppColors.grey.withOpacity(0.12),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      _getMetricIcon(item.label),
                                      color: isAlert
                                          ? AppColors.red
                                          : AppColors.red.withOpacity(0.7),
                                      size: 20,
                                    ),
                                    if (isAlert)
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: AppColors.red,
                                        size: 16,
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "${item.value} ${item.unit}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isAlert
                                              ? AppColors.red
                                              : AppColors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action buttons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ClientCustomButton(
                              color: AppColors.pink,
                              action: () => _viewModel.startConnection(),
                              text: "Connect Sensor",
                              textColor: AppColors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClientCustomButton(
                              color: AppColors.red,
                              action: () {},
                              text: "Diagnose",
                              useGradient: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Please enable Bluetooth on your device before connecting to the sensor.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: widget.showBackButton ? 8 : 88),
                    ],
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

class _MetricItem {
  final String label;
  final String value;
  final String unit;

  _MetricItem(this.label, this.value, this.unit);
}
