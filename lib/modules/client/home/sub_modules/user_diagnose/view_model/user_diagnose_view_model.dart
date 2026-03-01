import 'dart:async';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/obd_sensor_data_model.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/model/user_diagnose_repo.dart';

class UserDiagnoseViewModel {
  final UserDiagnoseRepo _repo = UserDiagnoseRepo();

  Stream<String> get statusStream => _repo.statusStream;

  Stream<ObdSensorDataModel> get sensorDataStream =>
      _repo.rawDataStream.map((map) => ObdSensorDataModel.fromMap(map));

  void startConnection() {
    _repo.connect();
  }

  void dispose() {
    _repo.dispose();
  }
}