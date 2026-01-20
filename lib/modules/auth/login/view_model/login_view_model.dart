import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepo _repository = LoginRepo();

  Future<String?> loginAndGetRoute({
    required TextEditingController mailController,
    required TextEditingController passwordController,
  }) async {
    try {
      EasyLoading.show(status: 'Logging in...');

      UserCredential userCredential = await _repository.login(
        mailController.text.trim(),
        passwordController.text,
      );

      // 2. Fetch User Data from Firestore
      String uid = userCredential.user!.uid;
      Map<String, dynamic> userData = await _repository.getUserData(uid);

      if (userData['role'] == 'client') {
        return PageRoutesName.clientHome;
      } else {
        return PageRoutesName.providerHome;
      }
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}