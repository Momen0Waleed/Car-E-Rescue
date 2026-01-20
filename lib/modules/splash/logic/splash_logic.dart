import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashLogic {
  final LoginRepo _loginRepo = LoginRepo();

  Future<String> decideNextRoute() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? role = await _loginRepo.getUserRoleLocally();

      if (role == 'client') {
        return PageRoutesName.clientHome;
      } else if (role == 'provider') {
        return PageRoutesName.providerHome;
      }
    }

    // If no user or no role found, go to Login
    return PageRoutesName.userType;
  }
}