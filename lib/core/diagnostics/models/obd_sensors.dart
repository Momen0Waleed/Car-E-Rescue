class OBDSensors {
  final double? engineRpm;
  final double? vehicleSpeed;
  final double? engineLoad;
  final double? coolantTemperature;
  final double? shortTermFuelTrim;
  final double? longTermFuelTrim;
  final double? intakeManifoldPressure;
  final double? intakeAirTemp;
  final double? throttle;
  final double? relativeThrottlePosition;
  final double? absoluteThrottleB;
  final double? commandedThrottleActuator;
  final double? acceleratorPedalD;
  final double? acceleratorPedalE;
  final double? timingAdvance;
  final double? fuelAirEquivRatio;
  final double? barometricPressure;
  final double? catalystTempS1;
  final double? catalystTempS2;
  final double? controlModuleVoltage;
  final double? commandedEvapPurge;
  final double? fuelTankLevel;
  final double? engineRunTime;
  final double? warmUpsSinceCodesCleared;
  final double? timeSinceCodesCleared;

  const OBDSensors({
    this.engineRpm,
    this.vehicleSpeed,
    this.engineLoad,
    this.coolantTemperature,
    this.shortTermFuelTrim,
    this.longTermFuelTrim,
    this.intakeManifoldPressure,
    this.intakeAirTemp,
    this.throttle,
    this.relativeThrottlePosition,
    this.absoluteThrottleB,
    this.commandedThrottleActuator,
    this.acceleratorPedalD,
    this.acceleratorPedalE,
    this.timingAdvance,
    this.fuelAirEquivRatio,
    this.barometricPressure,
    this.catalystTempS1,
    this.catalystTempS2,
    this.controlModuleVoltage,
    this.commandedEvapPurge,
    this.fuelTankLevel,
    this.engineRunTime,
    this.warmUpsSinceCodesCleared,
    this.timeSinceCodesCleared,
  });

  factory OBDSensors.fromJson(Map<String, dynamic> json) {
    return OBDSensors(
      engineRpm: _readDouble(json['engine_rpm']),
      vehicleSpeed: _readDouble(json['vehicle_speed']),
      engineLoad: _readDouble(json['engine_load']),
      coolantTemperature: _readDouble(json['coolant_temperature']),
      shortTermFuelTrim: _readDouble(json['short_term_fuel_trim']),
      longTermFuelTrim: _readDouble(json['long_term_fuel_trim']),
      intakeManifoldPressure: _readDouble(json['intake_manifold_pressure']),
      intakeAirTemp: _readDouble(json['intake_air_temp']),
      throttle: _readDouble(json['throttle']),
      relativeThrottlePosition: _readDouble(json['relative_throttle_position']),
      absoluteThrottleB: _readDouble(json['absolute_throttle_b']),
      commandedThrottleActuator: _readDouble(json['commanded_throttle_actuator']),
      acceleratorPedalD: _readDouble(json['accelerator_pedal_d']),
      acceleratorPedalE: _readDouble(json['accelerator_pedal_e']),
      timingAdvance: _readDouble(json['timing_advance']),
      fuelAirEquivRatio: _readDouble(json['fuel_air_equiv_ratio']),
      barometricPressure: _readDouble(json['barometric_pressure']),
      catalystTempS1: _readDouble(json['catalyst_temp_s1']),
      catalystTempS2: _readDouble(json['catalyst_temp_s2']),
      controlModuleVoltage: _readDouble(json['control_module_voltage']),
      commandedEvapPurge: _readDouble(json['commanded_evap_purge']),
      fuelTankLevel: _readDouble(json['fuel_tank_level']),
      engineRunTime: _readDouble(json['engine_run_time']),
      warmUpsSinceCodesCleared:
          _readDouble(json['warm_ups_since_codes_cleared']),
      timeSinceCodesCleared: _readDouble(json['time_since_codes_cleared']),
    );
  }

  Map<String, dynamic> toJson() => {
        'engine_rpm': engineRpm ?? 0.0,
        'vehicle_speed': vehicleSpeed ?? 0.0,
        'engine_load': engineLoad ?? 0.0,
        'coolant_temperature': coolantTemperature ?? 0.0,
        'short_term_fuel_trim': shortTermFuelTrim ?? 0.0,
        'long_term_fuel_trim': longTermFuelTrim ?? 0.0,
        'intake_manifold_pressure': intakeManifoldPressure ?? 0.0,
        'intake_air_temp': intakeAirTemp ?? 0.0,
        'throttle': throttle ?? 0.0,
        'relative_throttle_position': relativeThrottlePosition ?? 0.0,
        'absolute_throttle_b': absoluteThrottleB ?? 0.0,
        'commanded_throttle_actuator': commandedThrottleActuator ?? 0.0,
        'accelerator_pedal_d': acceleratorPedalD ?? 0.0,
        'accelerator_pedal_e': acceleratorPedalE ?? 0.0,
        'timing_advance': timingAdvance ?? 0.0,
        'fuel_air_equiv_ratio': fuelAirEquivRatio ?? 0.0,
        'barometric_pressure': barometricPressure ?? 0.0,
        'catalyst_temp_s1': catalystTempS1 ?? 0.0,
        'catalyst_temp_s2': catalystTempS2 ?? 0.0,
        'control_module_voltage': controlModuleVoltage ?? 0.0,
        'commanded_evap_purge': commandedEvapPurge ?? 0.0,
        'fuel_tank_level': fuelTankLevel ?? 0.0,
        'engine_run_time': engineRunTime ?? 0.0,
        'warm_ups_since_codes_cleared': warmUpsSinceCodesCleared ?? 0.0,
        'time_since_codes_cleared': timeSinceCodesCleared ?? 0.0,
      };

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
