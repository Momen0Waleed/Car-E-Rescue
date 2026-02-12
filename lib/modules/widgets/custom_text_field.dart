import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxlines,
        minLines: widget.minlines,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? obscurePassword : false,
        style: theme.bodySmall!.copyWith(color: AppColors.black),
        cursorColor: AppColors.red,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintText: widget.title,
          hintStyle: theme.bodySmall!.copyWith(color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1, color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 2, color: AppColors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.red, width: 2),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.red,
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
