import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';

class NavigateBackButton extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback? onPressed;

  const NavigateBackButton({
    super.key,
    this.isCompleted = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Bounceable(
        scaleFactor: 0.9,
        onTap: () {
          if (onPressed != null) {
            onPressed!();
            return;
          }
          if (isCompleted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              PageRoutesName.mechanicHome,
              (route) => false,
            );
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: AppColors.black.withOpacity(0.04),
                blurRadius: 2,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: AppColors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFC32B2A), // AppColors.red
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

