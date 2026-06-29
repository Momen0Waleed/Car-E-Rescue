import 'package:car_e_rescue/core/diagnostics/models/obd_health.dart';
import 'package:car_e_rescue/core/diagnostics/models/obd_sensors.dart';

class OBDSnapshot {
  final String vehicleId;
  final DateTime? timestamp;
  final String? source;
  final OBDHealth health;
  final OBDSensors sensors;

  const OBDSnapshot({
    required this.vehicleId,
    this.timestamp,
    this.source,
    this.health = const OBDHealth(),
    this.sensors = const OBDSensors(),
  });

  factory OBDSnapshot.fromJson(Map<String, dynamic> json) {
    return OBDSnapshot(
      vehicleId: json['vehicle_id']?.toString() ?? '',
      timestamp: _readDateTime(json['timestamp']),
      source: json['source']?.toString(),
      health: json['health'] is Map<String, dynamic>
          ? OBDHealth.fromJson(json['health'] as Map<String, dynamic>)
          : const OBDHealth(),
      sensors: json['sensors'] is Map<String, dynamic>
          ? OBDSensors.fromJson(json['sensors'] as Map<String, dynamic>)
          : const OBDSensors(),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        if (timestamp != null) 'timestamp': timestamp!.toUtc().toIso8601String(),
        if (source != null) 'source': source,
        'health': health.toJson(),
        'sensors': sensors.toJson(),
      };

  OBDSnapshot copyWith({
    String? vehicleId,
    DateTime? timestamp,
    String? source,
    OBDHealth? health,
    OBDSensors? sensors,
  }) {
    return OBDSnapshot(
      vehicleId: vehicleId ?? this.vehicleId,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      health: health ?? this.health,
      sensors: sensors ?? this.sensors,
    );
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
