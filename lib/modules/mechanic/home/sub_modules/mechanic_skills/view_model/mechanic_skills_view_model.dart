import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_skills/model/mechanic_skills_repo.dart';
import 'package:flutter/material.dart';

class MechanicSkillsViewModel extends ChangeNotifier {
  final MechanicSkillsRepo _repo = MechanicSkillsRepo();

  List<String> currentSkills = [];
  bool isLoading = false;

  Future<void> loadSkills() async {
    isLoading = true;
    notifyListeners();
    try {
      currentSkills = await _repo.getSkills();
    } catch (e) {
      debugPrint("Load Skills Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addSkill(String skill) {
    if (!currentSkills.contains(skill)) {
      currentSkills.add(skill);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    currentSkills.remove(skill);
    notifyListeners();
  }

  Future<bool> saveSkills() async {
    if (currentSkills.isEmpty) {
      SnackbarService.showErrorNotification("Please select at least one skill.");
      return false;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _repo.updateSkills(currentSkills);
      SnackbarService.showSuccessNotification("Skills updated successfully");
      return true;
    } catch (e) {
      print(e);
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> hasSkills() async {
    try {
      List<String> skills = await _repo.getSkills();
      return skills.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}