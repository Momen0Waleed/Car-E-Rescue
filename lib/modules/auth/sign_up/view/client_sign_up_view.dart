import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/sign_up/view_model/sign_up_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_text_field.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart' show Consumer, ChangeNotifierProvider;

class ClientSignUpView extends StatefulWidget {
  const ClientSignUpView({super.key});

  @override
  State<ClientSignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<ClientSignUpView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  double _formSpacing = 20;

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: Scaffold(
        floatingActionButton: const ClientNavigateBackButton(),
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
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign Up",
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ClientCustomTextField(
                              title: "Full Name",
                              controller: nameController,
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.red.withOpacity(0.7)),
                              validator: AppValidators.validateEmptyField,
                            ),
                            SizedBox(height: _formSpacing),
                            ClientCustomTextField(
                              title: "Phone Number",
                              controller: phoneController,
                              prefixIcon: Icon(Icons.phone_android_outlined, color: AppColors.red.withOpacity(0.7)),
                              keyboardType: TextInputType.phone,
                              validator: AppValidators.validateEgyptianPhone,
                            ),
                            SizedBox(height: _formSpacing),
                            ClientCustomTextField(
                              title: "Email",
                              controller: mailController,
                              prefixIcon: Icon(Icons.email_outlined, color: AppColors.red.withOpacity(0.7)),
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidators.validateEmail,
                            ),
                            SizedBox(height: _formSpacing),
                            ClientCustomTextField(
                              title: "Password",
                              controller: passwordController,
                              prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.red.withOpacity(0.7)),
                              validator: AppValidators.validatePassword,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),
                            Consumer<SignUpViewModel>(
                              builder: (context, provider, child) {
                                return ClientCustomButton(
                                  text: "Sign Up",
                                  color: AppColors.red,
                                  useGradient: true,
                                  action: () async {
                                    if (formKey.currentState!.validate()) {
                                      bool value = await provider.clientSignUpActionButton(
                                        mailController: mailController,
                                        passwordController: passwordController,
                                        nameController: nameController,
                                        phoneController: phoneController,
                                      );
                                      if (value) {
                                        SnackbarService.showSuccessNotification(
                                          "Client created successfully!",
                                        );
                                        if (context.mounted) {
                                          Navigator.of(context).pushReplacementNamed(PageRoutesName.login);
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        _formSpacing = 12;
                                      });
                                    }
                                  },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "If you already have an account, Please ",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(PageRoutesName.login);
                            },
                            child: Text(
                              "Login Now",
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

