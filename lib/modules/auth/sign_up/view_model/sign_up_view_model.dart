import 'package:car_e_rescue/core/constants/services/snackbar_service.dart' show SnackbarService;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpViewModel extends ChangeNotifier {
  Future<bool> providerSignUpActionButton({
    required TextEditingController mailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required String selectedService,
  }) async {
    try {
      EasyLoading.show(status: 'Creating Account...');

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: mailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        await userCredential.user!.updateDisplayName(nameController.text);

        await FirebaseFirestore.instance
            .collection("providers")
            .doc(uid) // Use the UID as the document ID
            .set({
          "uid": uid,
          "name": nameController.text,
          "phone": phoneController.text,
          "email": mailController.text,
          "service": selectedService,
          "createdAt": DateTime.now(),
          "role": "provider", // Useful for managing access later
        });

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

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: mailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        await userCredential.user!.updateDisplayName(nameController.text);

        await FirebaseFirestore.instance
            .collection("clients")
            .doc(uid) // Use the UID as the document ID
            .set({
          "uid": uid,
          "name": nameController.text,
          "phone": phoneController.text,
          "email": mailController.text,
          "createdAt": DateTime.now(),
          "role": "client", // Useful for managing access later
        });

        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      SnackbarService.showErrorNotification(e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
