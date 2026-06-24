// ignore_for_file: deprecated_member_use

import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/view_model/login_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart' show Consumer, ChangeNotifierProvider;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  double _formSpacing = 25;

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        floatingActionButton: const NavigateBackButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Header with Gradient & Image Backdrop
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagesDir.authBackground),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.red.withOpacity(0.15),
                          const Color(0xFF5A0202).withOpacity(0.95),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 45),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Text(
                        "Car E-Rescue",
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: AppColors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          shadows: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Form Content with Slide & Fade entry animation
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 60.0, end: 0.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutQuart,
                builder: (context, slideOffset, child) {
                  return Transform.translate(
                    offset: Offset(0, slideOffset),
                    child: Opacity(
                      opacity: (60.0 - slideOffset) / 60.0,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 25),
                            ClientCustomTextField(
                              title: "Email",
                              controller: mailController,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: AppColors.red.withOpacity(0.7),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidators.validateEmail,
                            ),
                            SizedBox(height: _formSpacing),
                            ClientCustomTextField(
                              title: "Password",
                              isPassword: true,
                              controller: passwordController,
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.red.withOpacity(0.7),
                              ),
                              validator: AppValidators.validatePassword,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Bounceable(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(PageRoutesName.forgetPassword);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Forgot Password?",
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: AppColors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Consumer<LoginViewModel>(
                              builder: (context, provider, child) {
                                return ClientCustomButton(
                                  color: AppColors.red,
                                  useGradient: true,
                                  action: () async {
                                    if (formKey.currentState!.validate()) {
                                      String? nextRoute = await provider
                                          .loginAndGetRoute(
                                            context: context,
                                            mailController: mailController,
                                            passwordController:
                                                passwordController,
                                          );

                                      if (nextRoute != null) {
                                        SnackbarService.showSuccessNotification(
                                          "Welcome Back!",
                                        );
                                        if (context.mounted) {
                                          Navigator.of(
                                            context,
                                          ).pushNamedAndRemoveUntil(
                                            nextRoute,
                                            (route) => false,
                                          );
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        _formSpacing = 16;
                                      });
                                    }
                                  },
                                  text: "Login",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1.5,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              height: 1.5,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "If you don't have an account, Please ",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Sign Up Now",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.red,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
