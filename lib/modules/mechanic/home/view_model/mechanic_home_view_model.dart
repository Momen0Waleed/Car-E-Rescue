// mechanic_home_view_model.dart
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_model.dart';
import 'package:car_e_rescue/modules/mechanic/home/model/mechanic_home_repo.dart';
import 'package:flutter/material.dart';

class MechanicHomeViewModel extends ChangeNotifier {
  final MechanicHomeRepo _repo = MechanicHomeRepo();
  bool isLoading = false;
  UserModel? mechanicProfile;

  Future<void> getMechanicProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _repo.fetchMechanicData();
      mechanicProfile = UserModel.fromMap(data);
    } catch (e) {
      debugPrint("Fetch Mechanic Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleAvailability(bool value) async {
    try {
      await _repo.updateAvailability(value);
      if (mechanicProfile != null) {
        mechanicProfile = mechanicProfile!.copyWith(role: mechanicProfile!.role);
      }
      return true;
    } catch (e) {
      debugPrint("Availability Update Error: $e");
      return false;
    }
  }
}