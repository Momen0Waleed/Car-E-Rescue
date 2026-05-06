import 'dart:async';
import 'dart:io';

import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/mechanic_current_request_repo.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';

class MechanicCurrentRequestViewModel extends ChangeNotifier {
  final MechanicCurrentRequestRepo _repo = MechanicCurrentRequestRepo();

  AvailableRequestModel? currentRequest;
  bool isLoading = false;
  String? errorMessage;
  bool isActionLoading = false;

  StreamSubscription<Position>? _positionStream;
  DateTime? lastSyncedAt;

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

  // mechanic_current_request_view_model.dart

  Future<void> startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackbarService.showErrorNotification("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackbarService.showErrorNotification("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      SnackbarService.showErrorNotification(
          "Location permissions are permanently denied. Please enable them in settings."
      );
      return;
    }

    stopLocationUpdates();

    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 5), // Changed from 30s to 5s for smoother stream
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

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      if (position != null && currentRequest != null) {
        await _sendLocationUpdate(position);
      } else if (currentRequest == null) {
        stopLocationUpdates();
      }
    });
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _sendLocationUpdate(Position position) async {
    try {
      final result = await _repo.updateLiveLocation(
        currentRequest!.requestId,
        position.latitude,
        position.longitude,
      );

      if (result['arrived'] == true) {
        stopLocationUpdates();
        SnackbarService.showSuccessNotification("You have arrived!");
      }
      lastSyncedAt = DateTime.now(); // Update timestamp on success
      notifyListeners(); //
    } catch (e) {
      if (e.toString() == "SERVER_ERROR_STOP_SYNC") {
        stopLocationUpdates(); // Stop sending requests immediately
        errorMessage = "Tracking suspended: Server error encountered.";
        SnackbarService.showErrorNotification("Server error. Location tracking stopped.");
        notifyListeners();
      } else {
        debugPrint("Sync failed: $e");
      }
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
