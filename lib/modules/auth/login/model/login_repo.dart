import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  final Dio _dio = DioClient.instance;

  // 1. Authenticate and return the access_token
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'auth/jwt/login',
        data: {
          'grant_type': 'password',
          'username': email,
          'password': password,
          'scope': '',
          'client_id': 'string',
          'client_secret': '********',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        // Optional: save token here if you want it persistent
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return token;
      }
      throw Exception("Login failed");
    } on DioException catch (e) {
      DioClient.logError(e);
      String message = e.response?.data['detail'] ?? "Login failed";
      if (message == "LOGIN_BAD_CREDENTIALS") {
        message = "Invalid email or password.";
      }
      throw Exception(message);
    }
  }

  // 2. Fetch the profile using the JWT token to find the user's role
  // login_repo.dart

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    try {
      final response = await _dio.get(
        'users/account',
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );

      return response.data['user'];
    } on DioException catch (e) {
      DioClient.logError(e);
      throw Exception("Failed to load user profile");
    }
  }

  Future<void> saveUserRoleLocally(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<String?> getUserRoleLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
  }
}