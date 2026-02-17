import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLogic {
  final LoginRepo _loginRepo = LoginRepo();

  Future<String> decideNextRoute(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Check for your JWT token instead of Firebase User
    String? token = prefs.getString('auth_token');

    if (token != null) {
      try {
        // Fetch the user data from your custom backend using the token
        final userDataMap = await _loginRepo.fetchUserProfile(token);
        final userModel = UserModel.fromMap(userDataMap);
        final String role = userModel.role;

        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        }

        // Navigate based on the role returned by your API
        return (role == 'user' || role == 'client')
            ? PageRoutesName.clientHome
            : PageRoutesName.mechanicHome;

      } catch (e) {
        // If the token is expired or the fetch fails, send to login
        return PageRoutesName.userType;
      }
    }

    // No token found, user is not logged in
    return PageRoutesName.userType;
  }
}