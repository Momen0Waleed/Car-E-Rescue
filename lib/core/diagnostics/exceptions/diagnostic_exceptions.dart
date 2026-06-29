class DiagnosticException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const DiagnosticException(
    this.message, {
    this.statusCode,
    this.cause,
  });

  @override
  String toString() =>
      'DiagnosticException(statusCode: $statusCode, message: $message)';
}

class VehicleNotCalibratedException extends DiagnosticException {
  final String vehicleId;

  VehicleNotCalibratedException(this.vehicleId)
      : super(
          'Vehicle $vehicleId is not calibrated. Route user to Calibration Screen.',
        );

  @override
  String toString() =>
      'VehicleNotCalibratedException(vehicleId: $vehicleId, message: $message)';
}
