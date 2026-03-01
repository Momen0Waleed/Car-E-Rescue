class ObdSensorDataModel {
  final String rpm;
  final String speed;
  final String coolantTemp;
  final String voltage;
  final String fuelLevel;
  final String throttle;
  final String ambientTemp;
  final String oilTemp;
  final String runtime;
  final String baro;
  final String engineLoad;
  final String fuelPressure;
  final String intakeTemp;

  ObdSensorDataModel({
    this.rpm = "0",
    this.speed = "0",
    this.coolantTemp = "0",
    this.voltage = "0.0",
    this.fuelLevel = "0",
    this.throttle = "0",
    this.ambientTemp = "0",
    this.oilTemp = "0",
    this.runtime = "0",
    this.baro = "0",
    this.engineLoad = "0",
    this.fuelPressure = "0",
    this.intakeTemp = "0",
  });

  factory ObdSensorDataModel.fromMap(Map<String, String> data) {
    return ObdSensorDataModel(
      rpm: data["RPM"] ?? "0",
      speed: data["Speed"] ?? "0",
      coolantTemp: data["Temp"] ?? "0",
      voltage: data["Voltage"] ?? "0.0",
      fuelLevel: data["Fuel"] ?? "0",
      throttle: data["Throttle"] ?? "0",
      ambientTemp: data["Ambient"] ?? "0",
      oilTemp: data["OilTemp"] ?? "0",
      runtime: data["Runtime"] ?? "0",
      baro: data["Baro"] ?? "0",
      engineLoad: data["Load"] ?? "0",
      fuelPressure: data["FuelPressure"] ?? "0",
      intakeTemp: data["IntakeTemp"] ?? "0",
    );
  }
}