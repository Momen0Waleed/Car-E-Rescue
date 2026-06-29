import 'dart:async';

import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_snapshot_mapper.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/view_model/user_diagnose_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CalibrationView extends StatefulWidget {
  final UserDiagnoseViewModel viewModel;

  const CalibrationView({super.key, required this.viewModel});

  @override
  State<CalibrationView> createState() => _CalibrationViewState();
}

class _CalibrationViewState extends State<CalibrationView> {
  UserDiagnoseViewModel get _viewModel => widget.viewModel;
  StreamSubscription<void>? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel.errorStream.listen((message) {
      if (mounted) SnackbarService.showErrorNotification(message);
    });
    _viewModel.loadingStream.listen((loading) {
      if (loading) {
        EasyLoading.show(status: 'Registering baseline...');
      } else {
        EasyLoading.dismiss();
      }
    });
    _completeSubscription =
        _viewModel.calibrationCompleteStream.listen((_) {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  Future<void> _startCalibration() async {
    final status = _viewModel.currentStatus;
    if (!status.toLowerCase().contains('connected')) {
      SnackbarService.showErrorNotification(
        'Connect the OBD sensor before starting calibration.',
      );
      return;
    }

    await _viewModel.startCalibrationCollection();
  }

  @override
  Widget build(BuildContext context) {
    final total = ObdSnapshotMapper.baselineSnapshotCount;

    return Scaffold(
      appBar: defaultAppBar(
        title: 'Vehicle Calibration',
        context: context,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.pink.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Baseline Setup',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Drive normally with the sensor connected. We collect '
                      '$total readings (~30 seconds) to learn your vehicle\'s '
                      'normal behavior before AI diagnostics can run.',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder<String>(
                stream: _viewModel.statusStream,
                initialData: _viewModel.currentStatus,
                builder: (context, snapshot) {
                  final status = snapshot.data ?? 'Disconnected';
                  final connected = status.toLowerCase().contains('connected');

                  return Row(
                    children: [
                      Icon(
                        connected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                        color: connected ? AppColors.green : AppColors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sensor: $status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: connected ? AppColors.green : AppColors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Calibration Progress',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<int>(
                stream: _viewModel.calibrationProgressStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final progress = snapshot.data ?? 0;
                  final fraction = progress / total;

                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: fraction.clamp(0.0, 1.0),
                          minHeight: 10,
                          backgroundColor: AppColors.grey.withOpacity(0.2),
                          color: AppColors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$progress / $total readings collected',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              StreamBuilder<bool>(
                stream: _viewModel.calibratingStream,
                initialData: false,
                builder: (context, snapshot) {
                  final calibrating = snapshot.data ?? false;

                  return Column(
                    children: [
                      if (!calibrating)
                        ClientCustomButton(
                          color: AppColors.red,
                          useGradient: true,
                          text: 'Start Calibration',
                          action: _startCalibration,
                        )
                      else
                        ClientCustomButton(
                          color: AppColors.pink,
                          text: 'Cancel',
                          textColor: AppColors.red,
                          action: () => _viewModel.cancelCalibrationCollection(),
                        ),
                      const SizedBox(height: 12),
                      ClientCustomButton(
                        color: AppColors.pink,
                        text: 'Connect Sensor',
                        textColor: AppColors.red,
                        action: () => _viewModel.startConnection(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    EasyLoading.dismiss();
    super.dispose();
  }
}
