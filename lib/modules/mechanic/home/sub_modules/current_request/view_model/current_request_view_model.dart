import 'package:flutter/material.dart';
import '../model/current_request_repo.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';

class CurrentRequestViewModel extends ChangeNotifier {
  final CurrentRequestRepo _repo = CurrentRequestRepo();

  AvailableRequestModel? currentRequest;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getCurrentRequest() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentRequest = await _repo.fetchCurrentRequest();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}