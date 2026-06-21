import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/sign_up/view_model/sign_up_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class ProviderSignUpView extends StatefulWidget {
  const ProviderSignUpView({super.key});

  @override
  State<ProviderSignUpView> createState() => _ProviderSignUpViewState();
}

class _ProviderSignUpViewState extends State<ProviderSignUpView> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController workshopController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  // double _formSpacing = 20;

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
                        spacing: 20,
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
                            validator: AppValidators.validateEmptyField,
                          ),
                          CustomTextField(
                            title: "Phone Number",
                            controller: phoneController,
                            validator: AppValidators.validateEgyptianPhone,
                          ),
                          // CustomDropdown<String>(
                          //   items: services,
                          //   hintText: "Select Service",
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectedService = value;
                          //     });
                          //   },
                          //   decoration: CustomDropdownDecoration(
                          //     closedFillColor: AppColors.white,
                          //     closedBorder: BoxBorder.all(
                          //       width: 1.5,
                          //       color: Colors.black45,
                          //     ),
                          //     headerStyle: theme.textTheme.bodyLarge!.copyWith(
                          //       color: AppColors.black,
                          //     ),
                          //     hintStyle: theme.textTheme.bodyLarge!.copyWith(
                          //       color: Colors.black45,
                          //     ),
                          //   ),
                          // ),
                          CustomTextField(
                            title: "Workshop Name",
                            controller: workshopController,
                            validator: AppValidators.validateEmptyField,
                          ),

                          CustomTextField(
                            title: "Years of Experience",
                            controller: experienceController,
                            keyboardType: TextInputType.number,
                            validator: AppValidators.validateEmptyField,
                          ),
                          CustomTextField(
                            title: "Email",
                            controller: mailController,
                            validator: AppValidators.validateEmail,
                          ),
                          CustomTextField(
                            title: "Password",
                            controller: passwordController,
                            validator:AppValidators.validatePassword,
                            isPassword: true,
                          ),
                          Consumer<SignUpViewModel>(
                            builder: (context, provider, child) {
                              return CustomButton(
                                text: "Sign Up",
                                color: AppColors.red,
                                action: () async {
                                  if (formKey.currentState!.validate()) {
                                    bool value = await provider.mechanicSignUpActionButton(
                                      mailController: mailController,
                                      passwordController: passwordController,
                                      nameController: nameController,
                                      phoneController: phoneController,
                                      workshopNameController: workshopController,
                                      experienceController: experienceController,
                                    );
                                    if (value) {
                                      SnackbarService.showSuccessNotification("Provider is created Successfully");
                                      Navigator.of(context).pushReplacementNamed(PageRoutesName.login);
                                    }
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "If you already have an account, Please ",
                            style: theme.textTheme.bodySmall,
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(PageRoutesName.login);
                            },
                            child: Text(
                              "Login Now",
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
