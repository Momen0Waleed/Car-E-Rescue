import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
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
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        CustomTextField(
                          title: "Password",
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Bounceable(
                            onTap: () {
                              Navigator.of(context).pushNamed(PageRoutesName.forgetPassword);
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
                        CustomButton(
                          color: AppColors.red,
                          action: () {
                            if (formKey.currentState!.validate()){
                              // Navigator.of(context).pushNamedAndRemoveUntil(PageRoutesName.home,(route) => false);
                            Navigator.of(context).pushNamed(PageRoutesName.home);
                            }
                          },
                          text: "Login",
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
                        style: theme.textTheme.bodyLarge!.copyWith(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "If you don't have an account, Please ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Bounceable(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sign Up Now",
                          style: theme.textTheme.bodyLarge!.copyWith(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
