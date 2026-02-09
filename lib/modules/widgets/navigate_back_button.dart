import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NavigateBackButton extends StatelessWidget {
  const NavigateBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: CircleBorder(),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: CircleAvatar(
          backgroundColor: AppColors.red,
          radius: 30,
          child: Icon(Icons.arrow_back_ios_new,color: AppColors.white,)),
    );
  }
}
