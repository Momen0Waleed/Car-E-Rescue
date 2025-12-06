import 'package:car_e_rescue/core/routes/app_routes.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PageRoutesName.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
