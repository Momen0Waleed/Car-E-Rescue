import 'package:bot_toast/bot_toast.dart';
import 'package:car_e_rescue/core/constants/theme/theme_manager.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/app_routes.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';

import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/view_model/mechanic_available_requests_view_model.dart';
import 'package:car_e_rescue/modules/mechanic/home/view_model/mechanic_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'modules/client/home/sub_modules/user_request/sub_mudules/current_requests/view_model/client_current_request_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MechanicHomeViewModel()),
        ChangeNotifierProvider(
          create: (context) => MechanicAvailableRequestsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientCurrentRequestViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => CreateRequestViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeManager.themeManager,
        debugShowCheckedModeBanner: false,
        initialRoute: PageRoutesName.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        builder: EasyLoading.init(builder: BotToastInit()),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
