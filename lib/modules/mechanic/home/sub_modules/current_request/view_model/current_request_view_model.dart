import 'dart:async';
import 'dart:io';

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
      late LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 30),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Car-E-Rescue is tracking your location for an active request",
            notificationTitle: "Service in Progress",
            enableWakeLock: true,
          ),
        );
      } else if (Platform.isIOS || Platform.isMacOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 10,
          pauseLocationUpdatesAutomatically: false,
          showBackgroundLocationIndicator: true,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      final result = await _repo.updateLiveLocation(
        currentRequest!.requestId,
        position.latitude,
        position.longitude,
      );

      if (result['arrived'] == true) {
        stopLocationUpdates();
        SnackbarService.showSuccessNotification("You have arrived!");
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
