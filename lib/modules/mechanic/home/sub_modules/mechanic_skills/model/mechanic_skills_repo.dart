import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicSkillsRepo {
  final Dio _dio = DioClient.instance;

  Future<List<String>> getSkills() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'mechanics/skills/me',
        options: Options(headers: {'Authorization': 'Bearer $token'},listFormat: ListFormat.multiCompatible,),
      );
      if (response.statusCode == 200) {
        return List<String>.from(response.data['skills'] ?? []);
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to fetch skills";
    }
  }

  Future<void> updateSkills(List<String> skills) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      await _dio.post(
        'mechanics/skills/me',
        queryParameters: {'skills_in': skills},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          listFormat: ListFormat.multi,
        ),
      );
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update skills";
    }
  }
}