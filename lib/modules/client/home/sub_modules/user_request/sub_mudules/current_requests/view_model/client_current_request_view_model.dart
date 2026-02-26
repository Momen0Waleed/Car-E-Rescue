import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/client_current_request_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/user_request_model.dart';
import 'package:flutter/material.dart';

class ClientCurrentRequestViewModel extends ChangeNotifier {
  final ClientCurrentRequestRepo _repo = ClientCurrentRequestRepo();
  UserRequestModel? currentRequest;
  bool isLoading = true;

  ClientCurrentRequestViewModel() {
    loadCurrentRequest();
  }

  Future<void> loadCurrentRequest() async {
    isLoading = true;
    notifyListeners();
    try {
      currentRequest = await _repo.fetchCurrentRequest();
      if (currentRequest != null) {
      }
    } catch (e) {
      // debugPrint(e.toString());
      debugPrint("VIEWMODEL ERROR: $e");
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

  Future<bool> hasActiveRequest() async {
    try {
      final request = await _repo.fetchCurrentRequest();
      return request != null;
    } catch (e) {
      return false;
    }
  }
}
