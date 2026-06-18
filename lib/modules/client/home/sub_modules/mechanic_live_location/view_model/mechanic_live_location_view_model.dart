import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/mechanic_live_location_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/model/client_current_request_repo.dart';

class MechanicLiveLocationViewModel extends ChangeNotifier {
  final MechanicLiveLocationRepo _repo = MechanicLiveLocationRepo();
  final ClientCurrentRequestRepo _requestRepo = ClientCurrentRequestRepo();
  LatLng? mechanicLocation;
  LatLng? userLocation;
  bool hasArrived = false;
  bool isError = false;
  String mechanicStatus = "On his way";
  Timer? _statusTimer;

  Future<void> fetchUserLocation() async {
    try {
      // 1. Try to load from SharedPreferences first (instant cache)
      final prefs = await SharedPreferences.getInstance();
      final double? savedLat = prefs.getDouble('user_lat');
      final double? savedLng = prefs.getDouble('user_lng');
      if (savedLat != null && savedLng != null) {
        userLocation = LatLng(savedLat, savedLng);
        notifyListeners();
      }

      // 2. Try to get last known position (very fast)
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        userLocation = LatLng(lastKnown.latitude, lastKnown.longitude);
        notifyListeners();
      }

      // 3. Fallback to current position (slow but accurate)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      userLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user location: $e");
    }
  }

  // mechanic_live_location_view_model.dart
  void initTracking(int requestId) {
    debugPrint("DEBUG: ViewModel initTracking called for ID: $requestId");
    fetchUserLocation();

    _fetchStatus();
    _statusTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchStatus();
    });

    _repo.connectToTracking(requestId).listen(
          (data) {
        debugPrint("DEBUG: Parsed Data: $data");
        final rawLat = data['lat'] ?? data['latitude'];
        final rawLng = data['lng'] ?? data['longitude'];

        if (rawLat != null && rawLng != null) {
          final lat = double.tryParse(rawLat.toString());
          final lng = double.tryParse(rawLng.toString());
          
          if (lat != null && lng != null) {
            mechanicLocation = LatLng(lat, lng);
            hasArrived = data['arrived'] ?? false;
            isError = false;

            if (hasArrived) {
              mechanicStatus = "Arrived";
              debugPrint("DEBUG: Mechanic arrived. Closing...");
              _repo.closeConnection();
            } else {
              if (mechanicStatus != "Arrived") mechanicStatus = "On his way";
            }
            notifyListeners();
          } else {
            debugPrint("DEBUG: Failed to parse lat/lng: rawLat=$rawLat, rawLng=$rawLng");
          }
        } else {
          debugPrint("DEBUG: Received message without lat/lng keys: $data");
        }
      },
      onError: (error) {
        debugPrint("DEBUG: ViewModel caught Error: $error");
        isError = true;
        notifyListeners();
      },
      onDone: () {
        debugPrint("DEBUG: WebSocket Stream Closed (onDone)");
      },
      cancelOnError: true,
    );
  }

  Future<void> _fetchStatus() async {
    try {
      final request = await _requestRepo.fetchCurrentRequest();
      if (request != null) {
        if (request.status.toLowerCase() == 'arrived') {
          mechanicStatus = "Arrived";
          hasArrived = true;
        } else if (request.status.toLowerCase() == 'accepted' || request.status.toLowerCase() == 'on the way') {
          if (!hasArrived) mechanicStatus = "On his way";
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching status: $e");
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _repo.closeConnection();
    super.dispose();
  }
}
