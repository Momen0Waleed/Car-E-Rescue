class FeatureDeviation {
  final String feature;
  final double zScore;
  final double? value;
  final String system;

  const FeatureDeviation({
    required this.feature,
    required this.zScore,
    this.value,
    required this.system,
  });

  factory FeatureDeviation.fromJson(Map<String, dynamic> json) {
    return FeatureDeviation(
      feature: json['feature']?.toString() ?? '',
      zScore: _readDouble(json['z_score']) ?? 0.0,
      value: _readDouble(json['value']),
      system: json['system']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'feature': feature,
        'z_score': zScore,
        if (value != null) 'value': value,
        'system': system,
      };

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class HealthGate {
  final bool milOn;
  final List<String> dtcCodes;
  final bool passed;

  const HealthGate({
    required this.milOn,
    this.dtcCodes = const [],
    required this.passed,
  });

  factory HealthGate.fromJson(Map<String, dynamic> json) {
    return HealthGate(
      milOn: json['mil_on'] is bool
          ? json['mil_on'] as bool
          : json['mil_on']?.toString().toLowerCase() == 'true',
      dtcCodes: (json['dtc_codes'] as List<dynamic>?)
              ?.map((code) => code.toString())
              .toList() ??
          const [],
      passed: json['passed'] is bool
          ? json['passed'] as bool
          : json['passed']?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
        'mil_on': milOn,
        'dtc_codes': dtcCodes,
        'passed': passed,
      };
}

class Diagnosis {
  final String vehicleId;
  final bool isAnomaly;
  final double anomalyScore;
  final double threshold;
  final String? likelySystem;
  final String confidence;
  final String baselineUsed;
  final HealthGate healthGate;
  final List<FeatureDeviation> topDeviations;
  final String message;
  final int? windowSize;

  const Diagnosis({
    required this.vehicleId,
    required this.isAnomaly,
    required this.anomalyScore,
    required this.threshold,
    this.likelySystem,
    required this.confidence,
    required this.baselineUsed,
    required this.healthGate,
    this.topDeviations = const [],
    required this.message,
    this.windowSize,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      vehicleId: json['vehicle_id']?.toString() ?? '',
      isAnomaly: json['is_anomaly'] is bool
          ? json['is_anomaly'] as bool
          : json['is_anomaly']?.toString().toLowerCase() == 'true',
      anomalyScore: _readDouble(json['anomaly_score']) ?? 0.0,
      threshold: _readDouble(json['threshold']) ?? 0.0,
      likelySystem: json['likely_system']?.toString(),
      confidence: json['confidence']?.toString() ?? '',
      baselineUsed: json['baseline_used']?.toString() ?? '',
      healthGate: json['health_gate'] is Map<String, dynamic>
          ? HealthGate.fromJson(json['health_gate'] as Map<String, dynamic>)
          : const HealthGate(milOn: false, passed: true),
      topDeviations: (json['top_deviations'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(FeatureDeviation.fromJson)
              .toList() ??
          const [],
      message: json['message']?.toString() ?? '',
      windowSize: _readInt(json['window_size']),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        'is_anomaly': isAnomaly,
        'anomaly_score': anomalyScore,
        'threshold': threshold,
        if (likelySystem != null) 'likely_system': likelySystem,
        'confidence': confidence,
        'baseline_used': baselineUsed,
        'health_gate': healthGate.toJson(),
        'top_deviations': topDeviations.map((d) => d.toJson()).toList(),
        'message': message,
        if (windowSize != null) 'window_size': windowSize,
      };

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
