import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/forget_password/view/forget_password_view.dart';
import 'package:car_e_rescue/modules/auth/login/view/login_view.dart';
import 'package:car_e_rescue/modules/auth/sign_up/view/client_sign_up_view.dart';
import 'package:car_e_rescue/modules/auth/sign_up/view/provider_sign_up_view.dart';
import 'package:car_e_rescue/modules/auth/user_type/view/user_type_screen.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_diagnose/view/user_diagnose_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_profile/view/client_profile_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/view/available_mech_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/create_request_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/current_requests/view/current_requests_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/request_history/view/request_history_view.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/view/user_request_view.dart';
import 'package:car_e_rescue/modules/client/home/view/client_home_view.dart';
import 'package:car_e_rescue/modules/mechanic/home/view/provider_home_view.dart';
import 'package:car_e_rescue/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';

abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRoutesName.splash:
        return _slideRoute(const SplashScreen());
      case PageRoutesName.userType:
        return _slideRoute(const UserTypeScreen());
      case PageRoutesName.login:
        return _slideRoute(const LoginView());
      case PageRoutesName.clientSignUp:
        return _slideRoute(const ClientSignUpView());
      case PageRoutesName.providerSignUp:
        return _slideRoute(const ProviderSignUpView());
      case PageRoutesName.clientHome:
        return _slideRoute(ClientHomeView());
      case PageRoutesName.providerHome:
        return _slideRoute(ProviderHomeView());
      case PageRoutesName.forgetPassword:
        return _slideRoute(const ForgetPasswordView());
      case PageRoutesName.userRequest:
        return _slideUpRoute(const UserRequestView());
      case PageRoutesName.userDiagnose:
        return _slideUpRoute(const UserDiagnoseView());
      case PageRoutesName.createRequest:
        return _slideRoute(const CreateRequestView());
      case PageRoutesName.requestHistory:
        return _slideRoute(const RequestHistoryView());
      case PageRoutesName.availableMech:
        return _slideRoute(const AvailableMechView());
      case PageRoutesName.clientProfile:
        return _slideRoute(const ClientProfileView());
        case PageRoutesName.clientCurrentRequest:
        return _slideRoute(const CurrentRequestsView());

      default:
        return _slideRoute(const SplashScreen());
    }
  }

  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _slideUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}
