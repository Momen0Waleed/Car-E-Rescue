import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentRequestRepo {
  final Dio _dio = DioClient.instance;

  Future<AvailableRequestModel?> fetchCurrentRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'requests/mechanic',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['request'] != null) {
        // Reuse your existing model since the fields match
        return AvailableRequestModel.fromJson(response.data['request']);
      }
      return null; // No active request
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw e.response?.data['detail'] ?? "Failed to fetch current request";
    }
  }
}