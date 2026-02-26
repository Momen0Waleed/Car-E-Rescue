import 'dart:async';

import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/current_request_repo.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';

class CurrentRequestViewModel extends ChangeNotifier {
  final CurrentRequestRepo _repo = CurrentRequestRepo();

  AvailableRequestModel? currentRequest;
  bool isLoading = false;
  String? errorMessage;
  bool isActionLoading = false;

  Timer? _locationTimer;

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  Future<void> getCurrentRequest() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentRequest = await _repo.fetchCurrentRequest();
      if (currentRequest != null) {
        startLocationUpdates();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void startLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (currentRequest == null) {
        timer.cancel();
        return;
      }
      await _sendCurrentLocation();
    });
  }

  void stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  Future<void> _sendCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final result = await _repo.updateLiveLocation(
        currentRequest!.requestId,
        position.latitude,
        position.longitude,
      );

      if (result['arrived'] == true) {
        stopLocationUpdates();
        SnackbarService.showSuccessNotification(
          "You have arrived at the destination!",
        );
      }
    } catch (e) {
      debugPrint("Location Update Error: $e");
    }
  }

  Future<bool> cancelCurrentRequest() async {
    isActionLoading = true;
    notifyListeners();
    try {
      await _repo.cancelRequest();
      stopLocationUpdates();
      currentRequest = null;
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }
}
