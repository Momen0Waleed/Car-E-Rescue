import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicAvailableRequestsRepo {
  final Dio _dio = DioClient.instance;

  Future<List<AvailableRequestModel>> fetchAvailableRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'requests/available_requests',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List data = response.data['requests'] ?? [];
        return data.map((json) => AvailableRequestModel.fromJson(json)).toList();
      }
      throw "Failed to load requests";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Connection error";
    }
  }

  Future<String> acceptRequest(int requestId) async {
    try {
      final prefs = await SharedPreferences.getInstance(); //
      final token = prefs.getString('auth_token'); //

      final response = await _dio.patch(
        'requests/mechanic/$requestId/accept',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Request accepted successfully"; //
      }
      throw "Unexpected error";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to accept request";
    }
  }
}