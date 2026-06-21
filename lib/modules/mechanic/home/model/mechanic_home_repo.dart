import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicHomeRepo {
  final Dio _dio = DioClient.instance;

  Future<String> updateAvailability(bool isAvailable) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'mechanics/availabilty/me',
        queryParameters: {'availability': isAvailable},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Availability updated";
      }
      throw "Unexpected error during update";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update availability";
    }
  }


  Future<Map<String, dynamic>> fetchMechanicData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'mechanics/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['mechanic'];
      }
      throw "Failed to load mechanic data";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Error fetching mechanic info";
    }
  }
}