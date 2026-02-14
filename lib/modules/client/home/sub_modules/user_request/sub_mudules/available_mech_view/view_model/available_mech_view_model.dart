import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/model/available_mech_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/model/mechanic_data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableMechViewModel extends ChangeNotifier{
  final AvailableMechRepo _repo = AvailableMechRepo();

  List<MechanicDataModel> mechanics = [];
  bool isLoading = false;
  String? errorMessage;

  String _selectedRequestType = "tiers and wheels";
  String get selectedRequestType => _selectedRequestType;
  final List<String> requestTypes = [
    "tiers and wheels", "Interior", "Glass", "Paint & Finish", "Body Work",
    "Preventive Maintenance", "Diagnostics", "CLIMATE CONTROL", "Drivetrain",
    "Manual Transmission", "Automatic Transmission", "Suspension & Steering",
    "Brake Systems", "Lighting & Accessories", "Computer & Sensors",
    "Battery & Charging", "Cooling System", "Exhaust System", "Fuel System",
    "Core Engine Repair", "Other"
  ];
  AvailableMechViewModel() {
    getMechanics();
  }

  void updateRequestType(String type) {
    _selectedRequestType = type;
    notifyListeners();
    getMechanics();
  }

  Future<void> getMechanics() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        mechanics = await _repo.fetchAvailableMechanics(
          requestType: _selectedRequestType,
          token: token,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// MOCK DATA: Injecting 10 fake mechanics for UI testing
  // Future<void> getMechanics() async {
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   // Simulate a short network delay
  //   await Future.delayed(const Duration(milliseconds: 800));
  //
  //   // MOCK DATA: Injecting 10 fake mechanics for UI testing
  //   mechanics = List.generate(10, (index) => MechanicDataModel(
  //     mechanicId: "id_$index",
  //     workshopName: index == 0 ? "Very Long Workshop Name Garage Center $index" : "Workshop $index",
  //     workshopLat: 30.0 + (index * 0.01),
  //     workshopLng: 31.0 + (index * 0.01),
  //     distanceInKm: 1.5 + index,
  //   ));
  //
  //   isLoading = false;
  //   notifyListeners(); // Triggers the ListView to build with 10 items
  // }

}