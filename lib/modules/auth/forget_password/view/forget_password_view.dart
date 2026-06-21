import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NavigateBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Lottie.asset(
                  'assets/animations/Email Marketing.json',
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  title: "Email Account",
                  controller: emailController,
                  validator: AppValidators.validateEmail,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Send Reset Link",
                  color: AppColors.red,
                  action: () {
                    if (formKey.currentState!.validate()) {
                      // Logic to trigger Firebase Password Reset
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}