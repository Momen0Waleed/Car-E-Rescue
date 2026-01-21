import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/modules/auth/forget_password/view_model/forget_password_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgetPasswordViewModel(),
      child: Scaffold(
        floatingActionButton: NavigateBackButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Consumer<ForgetPasswordViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 80,
                ),
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
                        action: () async {
                          if (formKey.currentState!.validate()) {
                            bool success = await viewModel.resetPasswordAction(
                              email: emailController.text,
                            );
                            if (success && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
