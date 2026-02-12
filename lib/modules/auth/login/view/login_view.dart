import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/view_model/login_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        floatingActionButton: NavigateBackButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagesDir.authBackground),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.red.withValues(alpha: 0.1),
                          Color(0xFF630101).withValues(alpha: 1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 45),
                    child: Text(
                      "Car E-Rescue",
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: AppColors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 30,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 25),
                          CustomTextField(
                            title: "Email",
                            controller: mailController,
                            validator: AppValidators.validateEmail,
                          ),
                          SizedBox(height: 25),
                          CustomTextField(
                            title: "Password",
                            isPassword: true,
                            controller: passwordController,
                            validator: AppValidators.validatePassword,
                          ),
                          SizedBox(height: 8),
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
                                children: [
                                  Text(
                                    "Forgot Password?",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: AppColors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Consumer<LoginViewModel>(
                            builder: (context, provider, child) {
                              return CustomButton(
                                color: AppColors.red,
                                action: () async {
                                  if (formKey.currentState!.validate()) {
                                    String? nextRoute = await provider.loginAndGetRoute(
                                      context: context,
                                      mailController: mailController,
                                      passwordController: passwordController,
                                    );

                                    if (nextRoute != null) {
                                      SnackbarService.showSuccessNotification("Welcome Back!");
                                      // Navigator.of(context).pushReplacementNamed(
                                      //   nextRoute,
                                      // );
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                        nextRoute,
                                            (route) => false,
                                      );
                                    }
                                  }
                                },
                                text: "Login",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 3,
                            color: AppColors.black,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          " OR ",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 3,
                            color: AppColors.black,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "If you don't have an account, Please ",
                            style: theme.textTheme.bodySmall,
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Sign Up Now",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.red,
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
