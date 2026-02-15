import 'package:car_e_rescue/modules/client/home/sub_modules/user_profile/model/client_profile_repo.dart';
import 'package:flutter/material.dart';

class ClientProfileViewModel extends ChangeNotifier {
  final ClientProfileRepo _repo = ClientProfileRepo();
  bool isLoading = false;

  Future<bool> updateUserData({
    String? name,
    String? phone,
    String? email,
    String? carType,
    String? carModel,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.updateProfile(
        name: name,
        phone: phone,
        email: email,
        carType: carType,
        carModel: carModel,
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