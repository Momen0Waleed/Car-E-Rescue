import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_profile/model/mechanic_profile_repo.dart';
import 'package:flutter/material.dart';

class MechanicProfileViewModel extends ChangeNotifier {
  final MechanicProfileRepo _repo = MechanicProfileRepo();
  bool isLoading = false;

  Future<bool> updateUserData({
    String? name,
    String? phone,
    String? email,
    String? workshopName,
    int? experienceYears,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.updateProfile(
        name: name,
        phone: phone,
        email: email,
        workshopName: workshopName,
        experienceYears: experienceYears,
      );
      return true;
    } catch (e) {
      debugPrint("Profile Update Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}