import 'dart:async';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/rating/model/rating_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/client_current_request_repo.dart';
import 'package:flutter/material.dart';

class RatingViewModel extends ChangeNotifier {
  final RatingRepo _repo = RatingRepo();
  final ClientCurrentRequestRepo _requestRepo = ClientCurrentRequestRepo();

  final int requestId;
  int selectedRating = 0;
  String feedback = "";

  bool isCompleted = false;
  bool isSubmitting = false;

  Timer? _statusTimer;

  RatingViewModel({required this.requestId}) {
    checkStatus();
    _statusTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => checkStatus(),
    );
  }

  Future<void> checkStatus() async {
    if (isCompleted) return;

    try {
      final request = await _requestRepo.fetchCurrentRequest();
      if (request == null) {
        isCompleted = true;
        _statusTimer?.cancel();
        notifyListeners();
        SnackbarService.showSuccessNotification(
          "Request completed (No active request found)",
        );
      } else if (request.status.toLowerCase() == 'completed') {
        isCompleted = true;
        _statusTimer?.cancel();
        notifyListeners();
        SnackbarService.showSuccessNotification("Request marked as Completed");
      } else {
        SnackbarService.showErrorNotification(
          "Waiting to complete the request",
        );
      }
    } catch (e) {
      debugPrint("Error checking status: $e");
      SnackbarService.showErrorNotification("Error checking status: $e");
    }
  }

  void setRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void setFeedback(String text) {
    feedback = text;
    notifyListeners();
  }

  Future<bool> submitRating() async {
    if (selectedRating < 1 || selectedRating > 5) {
      SnackbarService.showErrorNotification(
        "Please select a valid rating between 1 and 5.",
      );
      return false;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      final message = await _repo.submitRating(
        requestId: requestId,
        rateNum: selectedRating,
        feedback: feedback,
      );
      SnackbarService.showSuccessNotification(message);
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}
