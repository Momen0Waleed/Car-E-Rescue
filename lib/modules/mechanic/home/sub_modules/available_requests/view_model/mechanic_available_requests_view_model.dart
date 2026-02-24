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

  Future<void> getRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      requests = await _repo.fetchAvailableRequests();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> acceptRequest(int requestId) async {
    isAccepting = true;
    notifyListeners();
    try {
      String message = await _repo.acceptRequest(requestId);
      SnackbarService.showSuccessNotification(message);
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