/// API configuration for the diagnostics / ML model service.
/// Override at build time with:
/// `flutter run --dart-define=DIAGNOSTICS_API_URL=https://your-model-api.example.com/`
class ApiConstants {
  ApiConstants._();

  static const String diagnosticsBaseUrl = String.fromEnvironment(
    'DIAGNOSTICS_API_URL',
    defaultValue: 'https://carerescuemodel-production.up.railway.app/',
  );

  static const String diagnosticsBaseline = 'diagnostics/baseline';
  static const String diagnosticsAnalyzeWindow = 'diagnostics/analyze-window';

  static String calibrationKey(String vehicleId) => 'calibrated_$vehicleId';
}
