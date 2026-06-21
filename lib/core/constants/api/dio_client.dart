import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      // Note: Use 10.0.2.2 for Android Emulator to access your computer's localhost
      // Use localhost for iOS Simulator
      // baseUrl: 'http://10.0.2.2:8000/',
      baseUrl: 'https://backend-carerescue-production.up.railway.app/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  // Added a helper for error logging based on your Postman error response
  static void logError(DioException e) {
    if (e.response != null) {
      // This helps you see "REGISTER_USER_ALREADY_EXISTS" in your Flutter console
    } else {}
  }
}
