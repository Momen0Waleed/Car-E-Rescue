import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepository {
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String> updateUserLocation({
    required double lat,
    required double lng,
    required String token,
  }) async {
    try {
      final response = await DioClient.instance.patch(
        'users/location/me?lat=$lat&lng=$lng',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Location updated successfully";
      }
      throw "Unexpected status code: ${response.statusCode}";
    } on DioException catch (e) {
      if (e.response != null) {
        final detail = e.response?.data['detail'] ?? "An error occurred";
        switch (e.response?.statusCode) {
          case 401:
            throw "Unauthenticated: $detail";
          case 403:
            throw "Forbidden: $detail";
          case 422:
            throw "Validation Error: $detail";
          case 500:
            throw "Internal Server Error";
          default:
            throw detail;
        }
      }
      throw "Connection Error: Check your internet";
    }
  }
}
