import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.color,
    required this.action,
    required this.text,
    this.width,
  });
  final Color color;
  final double? width;
  final Function()? action;
  final String text;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Bounceable(
      onTap: action,
      child: Container(
        width: width ?? double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: AppColors.red),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: color == AppColors.red ? AppColors.white : AppColors.red,
            fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
