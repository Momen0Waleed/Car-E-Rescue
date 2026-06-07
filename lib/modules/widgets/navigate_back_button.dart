import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';

class NavigateBackButton extends StatelessWidget {
  final bool isCompleted;
  const NavigateBackButton({super.key, this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: CircleBorder(),
      onPressed: () {
        if (isCompleted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            PageRoutesName.clientHome,
            (route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: CircleAvatar(
        backgroundColor: AppColors.red,
        radius: 30,
        child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
      ),
    );
  }
}
