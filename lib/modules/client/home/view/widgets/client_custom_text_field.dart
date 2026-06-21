import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ClientCustomTextField extends StatefulWidget {
  const ClientCustomTextField({
    super.key,
    required this.title,
    this.prefixIcon,
    this.isPassword = false,
    this.maxlines = 1,
    this.minlines,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  final String title;
  final Widget? prefixIcon;
  final bool isPassword;
  final int? maxlines;
  final int? minlines;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<ClientCustomTextField> createState() => _ClientCustomTextFieldState();
}

class _ClientCustomTextFieldState extends State<ClientCustomTextField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxlines,
        minLines: widget.minlines,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? obscurePassword : false,
        style: theme.bodyMedium!.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: AppColors.red,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintText: widget.title,
          hintStyle: theme.bodySmall!.copyWith(
            color: AppColors.grey.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 1, color: AppColors.grey.withOpacity(0.25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(width: 2, color: AppColors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.red.withOpacity(0.8), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.red, width: 2),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: AppColors.red.withOpacity(0.8),
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
