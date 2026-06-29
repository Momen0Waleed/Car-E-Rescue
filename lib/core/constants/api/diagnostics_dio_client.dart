import 'package:car_e_rescue/core/constants/api/api_constants.dart';
import 'package:dio/dio.dart';

/// Dio client for the OBD diagnostics / ML model API only.
class DiagnosticsDioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.diagnosticsBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  static void logError(DioException e) {
    if (e.response != null) {
      // Log model API error details in debug builds if needed.
    }
  }
}
