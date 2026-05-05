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

  Widget _buildProfileHeader(dynamic user, ThemeData theme) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.pink,
            border: Border.all(color: AppColors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ]
          ),
          child: Center(
            child: Icon(Icons.person, size: 70, color: AppColors.red),
          ),
        ),
        SizedBox(height: 15),
        Text(
          user.name ?? "User Profile",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.red.withOpacity(0.5)),
          ),
          child: Text(
            user.role?.toUpperCase() ?? "ROLE",
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildExpandableField({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Bounceable(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      )
                    ]
                  ),
                  child: Icon(icon, color: AppColors.red, size: 20),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.red,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: child,
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
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
              return Center(child: CircularProgressIndicator(color: AppColors.red));
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileHeader(user, theme),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppColors.pink,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            )
                          ]
                        ),
                        child: Column(
                          children: [
                            _buildExpandableField(
                              context: context,
                              title: "Edit Your Name",
                              icon: Icons.person_rounded,
                              isExpanded: editUserNameFlag,
                              onTap: () => setState(() => editUserNameFlag = !editUserNameFlag),
                              child: CustomTextField(
                                title: user.name ?? "Name",
                                controller: nameController,
                                validator: AppValidators.validateEmptyField,
                              ),
                            ),
                            Divider(color: AppColors.grey.withOpacity(0.5), thickness: 1, indent: 20, endIndent: 20, height: 1),
                            _buildExpandableField(
                              context: context,
                              title: "Edit Your Email",
                              icon: Icons.mail_rounded,
                              isExpanded: editUserEmailFlag,
                              onTap: () => setState(() => editUserEmailFlag = !editUserEmailFlag),
                              child: CustomTextField(
                                title: user.email ?? "Email",
                                controller: emailController,
                                validator: AppValidators.validateEmail,
                              ),
                            ),
                            Divider(color: AppColors.grey.withOpacity(0.5), thickness: 1, indent: 20, endIndent: 20, height: 1),
                            _buildExpandableField(
                              context: context,
                              title: "Edit Your Phone",
                              icon: Icons.phone_rounded,
                              isExpanded: editUserPhoneFlag,
                              onTap: () => setState(() => editUserPhoneFlag = !editUserPhoneFlag),
                              child: CustomTextField(
                                title: user.phone ?? "Phone",
                                controller: phoneController,
                                validator: AppValidators.validateEgyptianPhone,
                              ),
                            ),
                            Divider(color: AppColors.grey.withOpacity(0.5), thickness: 1, indent: 20, endIndent: 20, height: 1),
                            _buildExpandableField(
                              context: context,
                              title: "Edit Your Car Data",
                              icon: Icons.car_rental_rounded,
                              isExpanded: editUserCarDataFlag,
                              onTap: () => setState(() => editUserCarDataFlag = !editUserCarDataFlag),
                              child: Column(
                                spacing: 15,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
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
                            Provider.of<UserProvider>(context, listen: false).updateUserInfo(
                              name: nameController?.text,
                              phone: phoneController?.text,
                              email: emailController?.text,
                              carType: carTypeController?.text,
                              carModel: carModelController?.text,
                            );

                            SnackbarService.showSuccessNotification("Profile updated successfully");
                            Navigator.of(context).pop();
                          }
                        },
                        text: "Save Changes",
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      SizedBox(height: 20),
                      Divider(thickness: 1, color: AppColors.grey.withOpacity(0.3), indent: 40, endIndent: 40),
                      SizedBox(height: 20),
                      CustomButton(
                        color: AppColors.white,
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
                        width: MediaQuery.of(context).size.width / 2,
                      ),
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
