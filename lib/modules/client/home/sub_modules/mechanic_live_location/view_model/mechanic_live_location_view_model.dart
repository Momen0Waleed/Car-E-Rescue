import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../model/mechanic_live_location_repo.dart';

class MechanicLiveLocationViewModel extends ChangeNotifier {
  final MechanicLiveLocationRepo _repo = MechanicLiveLocationRepo();
  LatLng? mechanicLocation;
  bool hasArrived = false;
  bool isError = false;

  void initTracking(int requestId) {
    _repo.connectToTracking(requestId).listen(
          (data) {
        // Data format: {"lat": 30.12, "lng": 31.56, "arrived": false, ...}
        mechanicLocation = LatLng(data['lat'], data['lng']);
        hasArrived = data['arrived'] ?? false;
        isError = false;

        if (hasArrived) {
          _repo.closeConnection();
        }
        notifyListeners();
      },
      onError: (error) {
        debugPrint("WebSocket Error: $error");
        isError = true;
        notifyListeners();
      },
      onDone: () => debugPrint("WebSocket Connection Closed"),
    );
  }

  @override
  void dispose() {
    _repo.closeConnection();
    super.dispose();
  }
}