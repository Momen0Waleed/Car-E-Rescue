import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ClientCustomButton extends StatelessWidget {
  const ClientCustomButton({
    super.key,
    required this.color,
    required this.action,
    required this.text,
    this.width,
    this.textColor,
    this.icon,
    this.useGradient = false,
  });

  final Color color;
  final double? width;
  final VoidCallback? action;
  final String text;
  final Color? textColor;
  final IconData? icon;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRed = color == AppColors.red;
    
    // Modern styling settings
    final resolvedTextColor = textColor ?? (isRed ? AppColors.white : AppColors.red);
    
    return Bounceable(
      scaleFactor: 0.95,
      onTap: action,
      child: Container(
        width: width ?? double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: useGradient ? null : color,
          gradient: useGradient 
              ? LinearGradient(
                  colors: [
                    AppColors.red,
                    AppColors.red.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isRed || useGradient
              ? null
              : Border.all(width: 1.5, color: AppColors.red.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: isRed || useGradient 
                  ? AppColors.red.withOpacity(0.3)
                  : AppColors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: resolvedTextColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: resolvedTextColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
