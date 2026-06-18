import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import '../model/available_request_model.dart';
import '../model/mechanic_available_requests_repo.dart';

class MechanicAvailableRequestsViewModel extends ChangeNotifier {
  final MechanicAvailableRequestsRepo _repo = MechanicAvailableRequestsRepo();

  List<AvailableRequestModel> requests = [];
  bool isLoading = false;
  String? errorMessage;

  bool isAccepting = false;

  Future<void> getRequests({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    }

    try {
      requests = await _repo.fetchAvailableRequests();
      errorMessage = null;
    } catch (e) {
      if (showLoading || requests.isEmpty) {
        errorMessage = e.toString();
      }
    } finally {
      if (showLoading) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<bool> acceptRequest(int requestId) async {
    isAccepting = true;
    notifyListeners();
    try {
      String message = await _repo.acceptRequest(requestId);
      SnackbarService.showSuccessNotification(message);
      requests.removeWhere((req) => req.requestId == requestId);
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      isAccepting = false;
      notifyListeners();
    }
  }
}