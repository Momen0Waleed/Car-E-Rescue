import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/auth/sign_up/model/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SplashLogic {
  final LoginRepo _loginRepo = LoginRepo();

  Future<String> decideNextRoute(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? role = await _loginRepo.getUserRoleLocally();

      try {
        final userDataMap = await _loginRepo.getUserData(user.uid);
        final userModel = UserModel.fromMap(userDataMap);

        // Store in global provider
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(userModel);
        }

        return (role == 'client') ? PageRoutesName.clientHome : PageRoutesName.providerHome;
      } catch (e) {
        return PageRoutesName.userType; // If data fetch fails, re-login
      }
    }

    return PageRoutesName.userType;
  }
}