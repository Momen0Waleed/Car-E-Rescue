import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/mechanic_history_model.dart';

class MechaincHistoryRepo {
  final Dio _dio = DioClient.instance;

  Future<List<MechanicHistoryModel>> fetchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'requests/mechanic/old_requests',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List data = response.data['requests'] ?? [];
        return data.map((json) => MechanicHistoryModel.fromJson(json)).toList();
      }
      throw "Failed to load history";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Connection error";
    }
  }
}