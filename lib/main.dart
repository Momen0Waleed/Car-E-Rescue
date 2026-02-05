import 'package:bot_toast/bot_toast.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/app_routes.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: PageRoutesName.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        builder: EasyLoading.init(builder: BotToastInit()),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
