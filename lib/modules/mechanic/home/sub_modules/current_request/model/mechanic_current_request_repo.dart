// ignore_for_file: avoid_print

import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicCurrentRequestRepo {
  final Dio _dio = DioClient.instance;

  Future<AvailableRequestModel?> fetchCurrentRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'requests/mechanic', // Ensure this matches the mechanic endpoint
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['request'] != null) {
        // Use AvailableRequestModel here
        return AvailableRequestModel.fromJson(response.data['request']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<String> cancelRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'requests/mechanic/cancel',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Request canceled successfully";
      }
      throw "Unexpected error during cancellation";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to cancel request";
    }
  }

  Future<Map<String, dynamic>> updateLiveLocation(int requestId, double lat, double lng) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'mechanics/mechanic/live_location/$requestId',
        queryParameters: {
          'lat': lat,
          'lng': lng,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("DEBUG: Location Sent Successfully. Server says: ${response.data['message']}"); //
        return response.data;
      }

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update location";
    }
  }

}