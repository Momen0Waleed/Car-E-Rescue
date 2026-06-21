import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_model.dart'; //
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepo _repository = LoginRepo();

  Future<String?> loginAndGetRoute({
    required BuildContext context,
    required TextEditingController mailController,
    required TextEditingController passwordController,
  }) async {
    try {
      EasyLoading.show(status: 'Logging in...');

      // 1. Authenticate and get token
      String token = await _repository.login(
        mailController.text.trim(),
        passwordController.text,
      );

      // 2. Fetch user profile from /users/account
      Map<String, dynamic> userData = await _repository.fetchUserProfile(token);

      // 3. Create UserModel and update UserProvider
      UserModel user = UserModel.fromMap(userData);
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      // 4. Determine navigation based on role
      String role = user.role;
      if (role == 'user' || role == 'client') {
        await _repository.saveUserRoleLocally('client');
        return PageRoutesName.clientHome;
      } else {
        await _repository.saveUserRoleLocally('provider');
        return PageRoutesName.mechanicHome;
      }
    } catch (e) {
      SnackbarService.showErrorNotification(e.toString().replaceAll("Exception: ", ""));
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}