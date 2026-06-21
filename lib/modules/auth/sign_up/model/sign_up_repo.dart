import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';

class SignUpRepo {
  final Dio _dio = DioClient.instance;

  Future<void> registerUser(Map<String, dynamic> userData) async {
    try {
      await _dio.post('auth/user/register', data: userData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['detail'] ?? "An error occurred";
      throw Exception(errorMessage);
    }
  }

  Future<void> registerMechanic(Map<String, dynamic> mechanicData) async {
    try {
      await _dio.post('auth/mechanic/register', data: mechanicData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['detail'] ?? "An error occurred";
      throw Exception(errorMessage);
    }
  }
}