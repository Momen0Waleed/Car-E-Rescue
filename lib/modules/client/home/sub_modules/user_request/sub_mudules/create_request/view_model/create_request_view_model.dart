import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/model/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CreateRequestViewModel extends ChangeNotifier {
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  String? _errorMessage;

  final LocationRepository _repository = LocationRepository();
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  String? token;

  final MapController _mapController = MapController();

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MapController get mapController => _mapController;

  Future<void> requestLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw 'Permission denied.';
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Move camera using move() instead of animateCamera
      _mapController.move(LatLng(_latitude!, _longitude!), 15.0);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendLocation() async {
    token ??= await _repository.getSavedToken();
    if (_latitude == null || _longitude == null || token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateUserLocation(
        lat: _latitude!,
        lng: _longitude!,
        token: token!,
      );
      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccess = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocation(LatLng point) {
    _latitude = point.latitude;
    _longitude = point.longitude;
    _isSuccess = false; // Reset if user picks a new spot
    notifyListeners();
  }
}
