import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/user_type/view/widgets/selected_user_widget.dart';
import 'package:car_e_rescue/modules/auth/user_type/view_model/user_type_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => UserTypeViewModel(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<UserTypeViewModel>(
                builder: (context, provider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Car E-Rescue",
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Now you can fix your car easily",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 100),
                      SelectedUserWidget(),
                      SizedBox(height: 80),
                      CustomButton(
                        color: AppColors.red,
                        action: () {
                          Navigator.of(
                            context,
                          ).pushNamed(provider.signUpNavigator()!);
                        },
                        text: "Sign Up",
                      ),

                      SizedBox(height: 20),
                      CustomButton(
                        color: AppColors.white,
                        action: () {
                          Navigator.of(context).pushNamed(PageRoutesName.login);
                        },
                        text: "Login",
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
