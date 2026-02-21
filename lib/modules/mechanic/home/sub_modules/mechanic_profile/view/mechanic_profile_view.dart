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
                padding: const EdgeInsets.only(left: 16,right: 16,top:20),
                child: SingleChildScrollView(
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
                      // SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.pink
                        ),
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            if (editUserNameFlag)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextField(
                                  title: user.name,
                                  controller: nameController,
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                            Divider(color: AppColors.grey,thickness: 0.5,indent: 30,endIndent: 30,),
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
                            if (editUserEmailFlag)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextField(
                                  title: user.email,
                                  controller: emailController,
                                  validator: AppValidators.validateEmail,
                                ),
                              ),
                            Divider(color: AppColors.grey,thickness: 0.5,indent: 30,endIndent: 30,),
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
                            if (editUserPhoneFlag)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextField(
                                  title: user.phone,
                                  controller: phoneController,
                                  validator: AppValidators.validateEgyptianPhone,
                                ),
                              ),
                            Divider(color: AppColors.grey,thickness: 0.5,indent: 30,endIndent: 30,),
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
                                    !editWorkshopLocationFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                                    color: AppColors.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            if (editWorkshopLocationFlag)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextField(
                                  title: user.workshopName ?? "Workshop Name",
                                  controller: workshopNameController,
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                            Divider(color: AppColors.grey,thickness: 0.5,indent: 30,endIndent: 30,),
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
                                    !editExperienceYearsFlag?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,
                                    color: AppColors.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            if (editExperienceYearsFlag)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextField(
                                  title: user.experienceYears?.toString() ?? "0",
                                  controller: experienceYearsController,
                                  keyboardType: TextInputType.number,
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                          ],
                        ),
                      ),

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
                      Divider(thickness: 0.5,color: AppColors.black,indent: 20,endIndent: 20,),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Bounceable(
                              onTap: () => Navigator.of(context).pushNamed(PageRoutesName.workshopLocation),
                              child: Container(
                                height: 60,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.pink,
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.red,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Workshop Location",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: AppColors.red,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Bounceable(
                              onTap: () => Navigator.of(context).pushNamed(PageRoutesName.mechanicSkills),
                              child: Container(
                                height: 60,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.pink,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.build,
                                      color: AppColors.red,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "My Skills",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: AppColors.red,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 0.5,color: AppColors.black,indent: 20,endIndent: 20,),
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
                      SizedBox(height: 20,)
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
