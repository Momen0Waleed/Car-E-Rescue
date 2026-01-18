import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/theme/theme_manager.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 4), () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(PageRoutesName.userType, (route) => false);
      });
    });
  }

  var theme = ThemeManager.themeManager;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Car E-Rescue',
              textStyle: theme.textTheme.titleLarge!.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              colors: [AppColors.white, AppColors.pink,AppColors.red],
            ),
          ],
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }
}
