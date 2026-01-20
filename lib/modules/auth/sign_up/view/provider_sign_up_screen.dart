import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/sign_up/view_model/sign_up_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class ProviderSignUpScreen extends StatefulWidget {
  const ProviderSignUpScreen({super.key});

  @override
  State<ProviderSignUpScreen> createState() => _ProviderSignUpScreenState();
}

class _ProviderSignUpScreenState extends State<ProviderSignUpScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double _formSpacing = 20;

  List<String> services = ["Tiers", "Battery", "Electricity", "Other.."];
  String? selectedService;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
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
                  spacing: 20,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        spacing: _formSpacing,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomTextField(
                            title: "Full Name",
                            controller: nameController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            title: "Phone Number",
                            controller: phoneController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your phone number";
                              }
                              if (!RegExp(r'^01[0125]\d{8}$').hasMatch(value)) {
                                return "Please enter a valid Egyptian phone number";
                              }
                              return null;
                            },
                          ),
                          CustomDropdown<String>(
                            items: services,
                            hintText: "Select Service",
                            onChanged: (value) {
                              setState(() {
                                selectedService = value;
                              });
                            },
                            decoration: CustomDropdownDecoration(
                              closedFillColor: AppColors.white,
                              closedBorder: BoxBorder.all(
                                width: 1.5,
                                color: Colors.black45,
                              ),
                              headerStyle: theme.textTheme.bodyLarge!.copyWith(
                                color: AppColors.black,
                              ),
                              hintStyle: theme.textTheme.bodyLarge!.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          CustomTextField(
                            title: "Email",
                            controller: mailController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            title: "Password",
                            controller: passwordController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            isPassword: true,
                          ),
                          Consumer<SignUpViewModel>(
                            builder: (context, provider, child) {
                              return CustomButton(
                                text: "Sign Up",
                                color: AppColors.red,
                                action: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (selectedService != null) {
                                      bool value = await provider.providerSignUpActionButton(
                                        mailController: mailController,
                                        passwordController: passwordController,
                                        nameController: nameController,
                                        phoneController: phoneController,
                                        selectedService: selectedService!,
                                      );
                                      if (value) {
                                        SnackbarService.showSuccessNotification(
                                          "Provider is created Successfully ",
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      SnackbarService.showErrorNotification(
                                        "Please Choose Service",
                                      );
                                      _formSpacing = 20;
                                    }
                                  } else {
                                    setState(() {
                                      _formSpacing = 8;
                                    });
                                  }
                                },
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
                          "If you already have an account, Please ",
                          style: theme.textTheme.bodyLarge,
                        ),
                        Bounceable(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(PageRoutesName.login);
                          },
                          child: Text(
                            "Login Now",
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
                    SizedBox(height: 20),
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
