import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkshopLocationRepo {
  final Dio _dio = DioClient.instance;

  Future<String> updateWorkshopLocation(double lat, double lng) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // PATCH /mechanics/workshop_location/me?lat=30.222&lng=34.2316
      final response = await _dio.patch(
        'mechanics/workshop_location/me',
        queryParameters: {'lat': lat, 'lng': lng},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Save flag so the mechanic is only asked once
        await prefs.setBool('workShopLocationWasSet', true);
        return response.data['message'] ?? "Location updated successfully";
      }
      throw "Unexpected error during update";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update location";
    }
  }
}