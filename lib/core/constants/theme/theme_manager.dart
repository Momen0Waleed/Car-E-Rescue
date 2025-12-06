import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ThemeManager {
  static ThemeData themeManager = ThemeData(
      primaryColor: AppColors.red,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.red),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.red,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(
        color: AppColors.red,
        fontWeight: FontWeight.w700,
        fontFamily: "Poppins",
        fontSize: 12,
      ),
      unselectedItemColor: AppColors.grey,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
