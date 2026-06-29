class OBDHealth {
  final bool? milOn;
  final int? dtcCount;
  final List<String> dtcCodes;
  final double? timeRunWithMilOn;
  final double? distanceWithMilOn;

  const OBDHealth({
    this.milOn,
    this.dtcCount,
    this.dtcCodes = const [],
    this.timeRunWithMilOn,
    this.distanceWithMilOn,
  });

  factory OBDHealth.fromJson(Map<String, dynamic> json) {
    return OBDHealth(
      milOn: _readBool(json['mil_on']),
      dtcCount: _readInt(json['dtc_count']),
      dtcCodes: (json['dtc_codes'] as List<dynamic>?)
              ?.map((code) => code.toString())
              .toList() ??
          const [],
      timeRunWithMilOn: _readDouble(json['time_run_with_mil_on']),
      distanceWithMilOn: _readDouble(json['distance_with_mil_on']),
    );
  }

  Map<String, dynamic> toJson() => {
        'mil_on': milOn ?? false,
        'dtc_count': dtcCount ?? 0,
        'dtc_codes': dtcCodes,
        'time_run_with_mil_on': timeRunWithMilOn ?? 0.0,
        'distance_with_mil_on': distanceWithMilOn ?? 0.0,
      };

  OBDHealth copyWith({
    bool? milOn,
    int? dtcCount,
    List<String>? dtcCodes,
    double? timeRunWithMilOn,
    double? distanceWithMilOn,
  }) {
    return OBDHealth(
      milOn: milOn ?? this.milOn,
      dtcCount: dtcCount ?? this.dtcCount,
      dtcCodes: dtcCodes ?? this.dtcCodes,
      timeRunWithMilOn: timeRunWithMilOn ?? this.timeRunWithMilOn,
      distanceWithMilOn: distanceWithMilOn ?? this.distanceWithMilOn,
    );
  }

  static bool? _readBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
