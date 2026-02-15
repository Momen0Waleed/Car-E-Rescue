import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileRepo {
  final Dio _dio = DioClient.instance;

  Future<String> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? carType,
    String? carModel,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          if (name != null) "name": name,
          if (phone != null) "phone": phone,
          if (email != null) "email": email,
          if (carType != null) "car_type": carType,
          if (carModel != null) "car_model": carModel,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "User profile updated successfully";
      }
      throw "Unexpected error during update";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update profile";
    }
  }
}