import 'package:car_e_rescue/core/diagnostics/models/obd_health.dart';
import 'package:car_e_rescue/core/diagnostics/models/obd_sensors.dart';
import 'package:car_e_rescue/core/diagnostics/models/obd_snapshot.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_sensor_data_model.dart';

abstract class ObdSnapshotMapper {
  static const int baselineSnapshotCount = 30;
  static const int windowSnapshotCount = 30;

  static OBDSnapshot fromSensorData({
    required String vehicleId,
    required ObdSensorDataModel data,
    OBDHealth? health,
    String source = 'live',
  }) {
    return OBDSnapshot(
      vehicleId: vehicleId,
      timestamp: DateTime.now(),
      source: source,
      health: health ?? const OBDHealth(),
      sensors: OBDSensors(
        engineRpm: _parse(data.rpm),
        vehicleSpeed: _parse(data.speed),
        engineLoad: _parse(data.engineLoad),
        coolantTemperature: _parse(data.coolantTemp),
        controlModuleVoltage: _parse(data.voltage),
        fuelTankLevel: _parse(data.fuelLevel),
        throttle: _parse(data.throttle),
        intakeAirTemp: _parse(data.intakeTemp),
        barometricPressure: _parse(data.baro),
        engineRunTime: _parse(data.runtime),
      ),
    );
  }

  static double? _parse(String value) => double.tryParse(value);
}
