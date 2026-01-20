import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Forget Password",style: theme.textTheme.titleMedium!.copyWith(
          color: AppColors.red,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Container()
    );
    // padding: EdgeInsets.symmetric(vertical: 5),
  }
}
