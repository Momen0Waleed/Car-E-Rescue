import 'package:car_e_rescue/core/constants/services/snackbar_service.dart' show SnackbarService;
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/sign_up_model.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpRepo _repository = SignUpRepo();

  Future<bool> providerSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required String selectedService,
  }) async {
    try {
      EasyLoading.show(status: 'Creating Account...');

      UserCredential userCredential = await _repository.createUser(
        mailController.text,
        passwordController.text,
      );

      if (userCredential.user != null) {
        UserModel provider = UserModel(
          uid: userCredential.user!.uid,
          name: nameController.text,
          email: mailController.text,
          phone: phoneController.text,
          role: "provider",
          service: selectedService,
          createdAt: DateTime.now(),
        );

        await _repository.saveUserData(provider, "providers");
        return true;
      }
      return false;
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> clientSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
  }) async {
    try {
      EasyLoading.show(status: 'Creating Account...');

      UserCredential userCredential = await _repository.createUser(
        mailController.text,
        passwordController.text,
      );

      if (userCredential.user != null) {
        UserModel client = UserModel(
          uid: userCredential.user!.uid,
          name: nameController.text,
          email: mailController.text,
          phone: phoneController.text,
          role: "client",
          createdAt: DateTime.now(),
        );

        await _repository.saveUserData(client, "clients");
        return true;
      }
      return false;
    } catch (e) {
      // debugPrint(e.toString());
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}