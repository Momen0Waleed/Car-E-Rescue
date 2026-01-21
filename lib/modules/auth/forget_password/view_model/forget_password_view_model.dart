import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/modules/auth/forget_password/model/forget_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgetPasswordViewModel extends ChangeNotifier {
  final ForgetPasswordRepo _repository = ForgetPasswordRepo();

  Future<bool> resetPasswordAction({required String email}) async {
    if (email.isEmpty) return false;

    try {
      EasyLoading.show(status: 'Sending reset link...');

      await _repository.sendResetEmail(email.trim());

      SnackbarService.showSuccessNotification("Reset link sent successfully!");
      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}