import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingRepo {
  final Dio _dio = DioClient.instance;

  Future<String> submitRating({
    required int requestId,
    required int rateNum,
    required String feedback,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.post(
        'ratings/create/$requestId',
        queryParameters: {
          'rate_num': rateNum,
          'feedback': feedback,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Rating submitted successfully";
      }
      throw "Unexpected error during rating submission";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to submit rating";
    }
  }

  Future<List<RatingModel>> fetchUserRatings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        'ratings/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ratings'];
        return data.map((item) => RatingModel.fromJson(item)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  Future<String> updateRating({
    required int ratingId,
    required int rateNum,
    required String feedback,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.patch(
        'ratings/user/$ratingId',
        queryParameters: {
          'rate_num': rateNum,
          'feedback': feedback,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Rating updated successfully";
      }
      throw "Unexpected error during rating update";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to update rating";
    }
  }

  Future<String> deleteRating(int ratingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.delete(
        'ratings/user/$ratingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Rating deleted successfully";
      }
      throw "Unexpected error during rating deletion";
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? "Failed to delete rating";
    }
  }
}
