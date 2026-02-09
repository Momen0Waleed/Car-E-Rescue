import 'package:car_e_rescue/core/constants/services/snackbar_service.dart' show SnackbarService;
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpRepo _repository = SignUpRepo();

  // For ClientSignUpView
  Future<bool> clientSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
  }) async {
    try {
      EasyLoading.show(status: 'Creating Client...');
      await _repository.registerUser({
        "email": mailController.text.trim(),
        "password": passwordController.text,
        "is_active": true,
        "is_superuser": false,
        "is_verified": false,
        "role": "user",
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "car_type": "",
        "car_model": ""
      });
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // For MechanicSignUpView
  Future<bool> mechanicSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController workshopNameController, // Changed to Controller
    required TextEditingController experienceController,   // Added for experience
  }) async {
    try {
      EasyLoading.show(status: 'Creating Mechanic...');

      await _repository.registerMechanic({
        "email": mailController.text.trim(),
        "password": passwordController.text,
        "is_active": true,
        "is_superuser": false,
        "is_verified": false,
        "role": "mechanic",
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "workshop_name": workshopNameController.text.trim(),
        "experience_years": int.tryParse(experienceController.text) ?? 0,
        "is_available": true,
        "avg_rating": 0,
        "total_jobs": 0,
        "review_count": 0
      });

      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}