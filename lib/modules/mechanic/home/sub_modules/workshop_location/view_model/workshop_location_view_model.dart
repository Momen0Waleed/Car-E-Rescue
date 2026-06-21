import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/workshop_location/model/workshop_location_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class WorkshopLocationViewModel extends ChangeNotifier {
  final WorkshopLocationRepo _repo = WorkshopLocationRepo();
  final MapController mapController = MapController();

  double? latitude;
  double? longitude;
  bool isLoading = false;

  void updateLocation(LatLng point) {
    latitude = point.latitude;
    longitude = point.longitude;
    notifyListeners();
  }

  Future<void> requestLocation() async {
    isLoading = true;
    notifyListeners();
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        SnackbarService.showErrorNotification("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          SnackbarService.showErrorNotification("Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        SnackbarService.showErrorNotification("Permissions are permanently denied. Please enable them in settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      mapController.move(LatLng(latitude!, longitude!), 15);
    } catch (e) {
      debugPrint("Location Error: $e");
      SnackbarService.showErrorNotification("Could not fetch location: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveLocation() async {
    if (latitude == null || longitude == null) {
      SnackbarService.showErrorNotification("Please pick a location first.");
      return false;
    }

    isLoading = true;
    notifyListeners();
    try {
      await _repo.updateWorkshopLocation(latitude!, longitude!);
      return true;
    } catch (e) {
      debugPrint("Save Location Error: $e");
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}