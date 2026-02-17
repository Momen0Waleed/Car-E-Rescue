import 'package:car_e_rescue/modules/mechanic/home/model/mechanic_home_repo.dart';
import 'package:flutter/material.dart';

class MechanicHomeViewModel extends ChangeNotifier {
  final MechanicHomeRepo _repo = MechanicHomeRepo();
  bool isLoading = false;

  Future<bool> toggleAvailability(bool value) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.updateAvailability(value);
      return true;
    } catch (e) {
      debugPrint("Availability Update Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}