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
        return AvailableRequestModel.fromJson(response.data['request']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;

      if (e.response?.statusCode == 500) {
        final detail = e.response?.data['detail']?.toString() ?? "";
        // Pass the server detail so the ViewModel/View can read it
        throw detail.isNotEmpty ? detail : "Internal Server Error";
      }
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

  Future<String> completeRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'requests/mechanic/complete',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Request completed successfully";
      }
      throw "Unexpected error during completion";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to complete request";
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
      if (e.response?.statusCode == 500) {
        throw "SERVER_ERROR_STOP_SYNC"; // Custom key to identify the stop condition
      }
      throw e.response?.data['detail'] ?? "Failed to update location";
    }
  }

}