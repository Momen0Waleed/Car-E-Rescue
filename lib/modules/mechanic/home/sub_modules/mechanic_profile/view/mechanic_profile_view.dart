import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_profile/view_model/mechanic_profile_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:car_e_rescue/modules/widgets/custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class MechanicProfileView extends StatefulWidget {
  MechanicProfileView({super.key});
  final LoginRepo _loginRepo = LoginRepo();


  @override
  State<MechanicProfileView> createState() => _MechanicProfileViewState();
}

class _MechanicProfileViewState extends State<MechanicProfileView> {
  bool editUserNameFlag = false;
  bool editUserEmailFlag = false;
  bool editUserPhoneFlag = false;
  bool editWorkshopLocationFlag = false;
  bool editExperienceYearsFlag = false;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? workshopNameController;
  TextEditingController? experienceYearsController;



  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    nameController = TextEditingController(text: user?.name);
    emailController = TextEditingController(text: user?.email);
    phoneController = TextEditingController(text: user?.phone);
    workshopNameController = TextEditingController(text: user?.workshopName);
    experienceYearsController = TextEditingController(text: user!.experienceYears.toString());
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => MechanicProfileViewModel(),
      child: Scaffold(
        floatingActionButton: NavigateBackButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (user == null) {
              return Center(child: CircularProgressIndicator(color: AppColors.red,));
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
                      width: 150,
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
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    if (editUserNameFlag)
                      CustomTextField(
                        title: user.name,
                        controller: nameController,
                        validator: AppValidators.validateEmptyField,
                      ),
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
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    if (editUserEmailFlag)
                      CustomTextField(
                        title: user.email,
                        controller: emailController,
                        validator: AppValidators.validateEmail,
                      ),
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
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    if (editUserPhoneFlag)
                      CustomTextField(
                        title: user.phone,
                        controller: phoneController,
                        validator: AppValidators.validateEgyptianPhone,
                      ),
                    Bounceable(
                      onTap: () {
                        editWorkshopLocationFlag = !editWorkshopLocationFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                          Expanded(
                            child: Text(
                              "Edit Your Workshop Name",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    if (editWorkshopLocationFlag)
                      CustomTextField(
                        title: user.workshopName ?? "Workshop Name",
                        controller: workshopNameController,
                        validator: AppValidators.validateEmptyField,
                      ),
                    Bounceable(
                      onTap: () {
                        editExperienceYearsFlag = !editExperienceYearsFlag;
                        setState(() {});
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.stars,
                            color: AppColors.red,
                            size: 30,
                          ),
                          Expanded(
                            child: Text(
                              "Edit Your Experience Years",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    if (editExperienceYearsFlag)
                      CustomTextField(
                        title: user.experienceYears?.toString() ?? "0",
                        controller: experienceYearsController,
                        keyboardType: TextInputType.number,
                        validator: AppValidators.validateEmptyField,
                      ),
                    SizedBox(height: 20),
                    CustomButton(
                      color: AppColors.red,
                      action: () async {
                        final viewModel = context.read<MechanicProfileViewModel>();
                        final userProv = Provider.of<UserProvider>(context, listen: false);

                        int? expYears = int.tryParse(experienceYearsController?.text ?? '');

                        bool success = await viewModel.updateUserData(
                          name: nameController?.text,
                          phone: phoneController?.text,
                          email: emailController?.text,
                          workshopName: workshopNameController?.text,
                          experienceYears: expYears,
                        );

                        if (success) {
                          userProv.updateMechanicInfo(
                            name: nameController?.text,
                            phone: phoneController?.text,
                            email: emailController?.text,
                            workshopName: workshopNameController?.text,
                            experienceYears: expYears,
                          );

                          SnackbarService.showSuccessNotification("Profile updated successfully");
                          Navigator.of(context).pop();
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
                        ).clearUser();
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
