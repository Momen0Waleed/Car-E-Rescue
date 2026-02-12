import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

PreferredSizeWidget? defaultAppBar({required String title,required BuildContext context}) {
  return AppBar(
    centerTitle: true,

    title: Text(title),

    leading: Bounceable(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),

        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.red,
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        ),
      ),
    ),

    leadingWidth: 50,
  );
}
