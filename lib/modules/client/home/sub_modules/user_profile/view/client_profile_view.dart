import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_profile/view_model/client_profile_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class ClientProfileView extends StatefulWidget {
  ClientProfileView({super.key});
  final LoginRepo _loginRepo = LoginRepo();

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  bool editUserNameFlag = false;
  bool editUserEmailFlag = false;
  bool editUserPhoneFlag = false;
  bool editUserCarDataFlag = false;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? carTypeController;
  TextEditingController? carModelController;


  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    nameController = TextEditingController(text: user?.name);
    emailController = TextEditingController(text: user?.email);
    phoneController = TextEditingController(text: user?.phone);
    carTypeController = TextEditingController(text: user?.carType);
    carModelController = TextEditingController(text: user?.carModel);
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => ClientProfileViewModel(),
      child: Scaffold(
        floatingActionButton: NavigateBackButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Role: ${user.role}",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Bounceable(
                      onTap: () {
                        editUserNameFlag = !editUserNameFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                          Expanded(
                            child: Text(
                              "Edit Your Name",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            !editUserNameFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    ?editUserNameFlag
                        ? CustomTextField(
                            title: user.name,
                            controller: nameController,
                            validator: AppValidators.validateEmptyField,
                          )
                        : null,
                    Bounceable(
                      onTap: () {
                        editUserEmailFlag = !editUserEmailFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.mail, color: AppColors.red, size: 30),
                          Expanded(
                            child: Text(
                              "Edit Your Email",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            !editUserEmailFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    ?editUserEmailFlag
                        ? CustomTextField(
                            title: user.email,
                            controller: emailController,
                            validator: AppValidators.validateEmail,
                          )
                        : null,
                    Bounceable(
                      onTap: () {
                        editUserPhoneFlag = !editUserPhoneFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.phone, color: AppColors.red, size: 30),
                          Expanded(
                            child: Text(
                              "Edit Your Phone",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            !editUserPhoneFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    ?editUserPhoneFlag
                        ? CustomTextField(
                            title: user.phone,
                            controller: phoneController,
                            validator: AppValidators.validateEgyptianPhone,
                          )
                        : null,
                    Bounceable(
                      onTap: () {
                        editUserCarDataFlag = !editUserCarDataFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.car_rental_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                          Expanded(
                            child: Text(
                              "Edit Your Car Data",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            !editUserCarDataFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    ?editUserCarDataFlag
                        ? Column(
                            spacing: 10,
                            children: [
                              CustomTextField(
                                title: user.carType ?? "Unknown Type",
                                controller: carTypeController,
                                validator: AppValidators.validateEmptyField,
                              ),
                              CustomTextField(
                                title: user.carModel ?? "Unknown Model",
                                controller: carModelController,
                                validator: AppValidators.validateEmptyField,
                              ),
                            ],
                          )
                        : null,
                    SizedBox(height: 20),
                    CustomButton(
                      color: AppColors.red,
                      action: () async {
                        final viewModel = context.read<ClientProfileViewModel>();
                        bool success = await viewModel.updateUserData(
                          name: nameController?.text,
                          phone: phoneController?.text,
                          email: emailController?.text,
                          carType: carTypeController?.text,
                          carModel: carModelController?.text,
                        );

                        if (success) {
                          // Update the local provider so changes reflect everywhere
                          Provider.of<UserProvider>(context, listen: false).updateUserInfo(
                            name: nameController?.text,
                            phone: phoneController?.text,
                            email: emailController?.text,
                            carType: carTypeController?.text,
                            carModel: carModelController?.text,
                          );

                          SnackbarService.showSuccessNotification("Profile updated successfully");
                          Navigator.of(context).pop(); // Use pop() to go back to Home instead of pushReplacement
                        }
                      },
                      text: "Edit",
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      color: AppColors.red,
                      action: () async {
                        await widget._loginRepo.logout();
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).clearUser(); // Clear memory
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          PageRoutesName.userType,
                              (route) => false,
                        );
                      },
                      text: "Logout",
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
