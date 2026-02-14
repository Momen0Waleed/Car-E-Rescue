import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/current_request_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:flutter/material.dart';

class CurrentRequestViewModel extends ChangeNotifier {
  final CurrentRequestRepo _repo = CurrentRequestRepo();
  UserRequestModel? currentRequest;
  bool isLoading = true;

  CurrentRequestViewModel() {
    loadCurrentRequest();
  }

  Future<void> loadCurrentRequest() async {
    isLoading = true;
    notifyListeners();
    try {
      currentRequest = await _repo.fetchCurrentRequest();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCurrentRequest() async {
    isLoading = true;
    notifyListeners();
    try {
      await _repo.cancelRequest();
      currentRequest = null;
      return true;
    } catch (e) {
      debugPrint("Cancellation Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}