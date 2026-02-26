import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../model/mechanic_live_location_repo.dart';

class MechanicLiveLocationViewModel extends ChangeNotifier {
  final MechanicLiveLocationRepo _repo = MechanicLiveLocationRepo();
  LatLng? mechanicLocation;
  bool hasArrived = false;
  bool isError = false;

  // void initTracking(int requestId) {
  //   _repo.connectToTracking(requestId).listen(
  //         (data) {
  //       // Data format: {"lat": 30.12, "lng": 31.56, "arrived": false, ...}
  //       mechanicLocation = LatLng(data['lat'], data['lng']);
  //       hasArrived = data['arrived'] ?? false;
  //       isError = false;
  //
  //       if (hasArrived) {
  //         _repo.closeConnection();
  //       }
  //       notifyListeners();
  //     },
  //     onError: (error) {
  //       debugPrint("WebSocket Error: $error");
  //       isError = true;
  //       notifyListeners();
  //     },
  //     onDone: () => debugPrint("WebSocket Connection Closed"),
  //   );
  // }

  // mechanic_live_location_view_model.dart
  void initTracking(int requestId) {
    debugPrint("DEBUG: ViewModel initTracking called for ID: $requestId");

    _repo.connectToTracking(requestId).listen(
          (data) {
        debugPrint("DEBUG: Parsed Data: $data");
        if (data.containsKey('lat')) {
          mechanicLocation = LatLng(data['lat'], data['lng']);
          hasArrived = data['arrived'] ?? false;
          isError = false;

          if (hasArrived) {
            debugPrint("DEBUG: Mechanic arrived. Closing...");
            _repo.closeConnection();
          }
          notifyListeners();
        } else {
          debugPrint("DEBUG: Received message without 'lat' key: $data");
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

  @override
  void dispose() {
    _repo.closeConnection();
    super.dispose();
  }
}
