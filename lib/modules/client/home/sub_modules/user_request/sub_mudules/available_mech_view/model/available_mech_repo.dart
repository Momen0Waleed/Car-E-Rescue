import 'package:car_e_rescue/core/constants/api/dio_client.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/model/mechanic_data_model.dart';
import 'package:dio/dio.dart';

class AvailableMechRepo {
  Future<List<MechanicDataModel>> fetchAvailableMechanics({
    required String requestType,
    required String token,
  }) async {
    try {
      final String encodedType = Uri.encodeComponent(requestType);

      final response = await DioClient.instance.get(
        'requests/available_mechanics?type=$encodedType',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['Available mechanics'];
        return data.map((m) => MechanicDataModel.fromJson(m)).toList();
      }
      return [];
    } on DioException catch (e) {
      DioClient.logError(e);
      if (e.response != null) {
        final dynamic detail = e.response?.data['detail'];
        switch (e.response?.statusCode) {
          case 400: throw detail ?? "set your location first";
          case 401: throw "Unauthorized";
          case 403: throw "User access required";
          case 422: throw "Validation Error";
          default: throw "An unknown error occurred.";
        }
      }
      throw "Connection Error";
    }
  }
}