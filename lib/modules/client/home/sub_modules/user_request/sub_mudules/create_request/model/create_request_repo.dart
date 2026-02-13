import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:dio/dio.dart';

class CreateRequestRepo {
  Future<String> createRescueRequest({
    required String requestType,
    required String token,
  }) async {
    try {
      final String encodedType = Uri.encodeComponent(requestType);

      final response = await DioClient.instance.post(
        'requests/user/create?request_type=$encodedType',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Request submitted successfully";
      }

      throw "Unexpected error occurred";
    } on DioException catch (e) {
      DioClient.logError(e);

      if (e.response != null) {
        final dynamic detail = e.response?.data['detail'];

        switch (e.response?.statusCode) {
          case 400:
            throw detail ?? "Please set your location first.";
          case 401:
            throw "Unauthorized: Please log in again.";
          case 403:
            throw "Forbidden: User access required.";
          case 422:
            throw "Validation Error: Please check your request details.";
          case 500:
            if (detail != null && detail.toString().contains("Pending")) {
              return "You Have a Pending Request Already";
            }
            throw "Server Error: Please try again later.";
          default:
            throw detail?.toString() ?? "An unknown error occurred.";
        }
      }
      throw "Connection Error: Please check your internet.";
    }
  }
}