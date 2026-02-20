import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicProfileRepo {
  final Dio _dio = DioClient.instance;

  Future<String> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? workshopName,
    int? experienceYears,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'mechanics/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          if (name != null) "name": name,
          if (phone != null) "phone": phone,
          if (email != null) "email": email,
          if (workshopName != null) "workshop_name": workshopName,
          if (experienceYears != null) "experience_years": experienceYears,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Mechanic profile updated successfully";
      }
      throw "Unexpected error during update";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update profile";
    }
  }
}