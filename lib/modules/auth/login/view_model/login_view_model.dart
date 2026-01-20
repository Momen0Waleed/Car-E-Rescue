import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepo _repository = LoginRepo();

  Future<bool> loginActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
  }) async {
    try {
      EasyLoading.show(status: 'Logging in...');

      await _repository.login(
        mailController.text.trim(),
        passwordController.text,
      );

      return true;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}