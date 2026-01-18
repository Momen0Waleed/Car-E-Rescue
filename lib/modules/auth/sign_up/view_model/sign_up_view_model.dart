import 'package:car_e_rescue/core/utils/firebase_authentication_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpViewModel extends ChangeNotifier {
  bool providerSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
  }) {
    EasyLoading.show();
    FirebaseAuthenticationUtils.createUserWithEmailAndPassword(
      emailAddress: mailController.text,
      password: passwordController.text,
    ).then((value) async {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        nameController.text,
      );
      await FirebaseAuth.instance.currentUser!.reload();
      return value;
    });
    return false;
  }
}
