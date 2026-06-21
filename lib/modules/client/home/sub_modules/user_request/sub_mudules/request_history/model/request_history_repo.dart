// request_history_repo.dart

import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestHistoryRepo {
  final Dio _dio = DioClient.instance;

  Future<List<UserRequestModel>> fetchRequestHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'requests/user/old_requests', //
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Parse the list from the 'requests' key
        final List<dynamic> data = response.data['requests'];
        return data.map((item) => UserRequestModel.fromJson(item)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }
}