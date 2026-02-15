import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUserInfo({String? name, String? phone, String? email, String? carType, String? carModel}) {
    if (_currentUser != null) {
      // Assign to the private variable _currentUser, not the getter
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        email: email ?? _currentUser!.email,
        carType: carType ?? _currentUser!.carType,
        carModel: carModel ?? _currentUser!.carModel,
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}