import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_profile/view_model/client_profile_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_text_field.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class ClientProfileView extends StatefulWidget {
  final bool showBackButton;
  ClientProfileView({super.key, this.showBackButton = true});
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
    if (user != null) {
      nameController = TextEditingController(text: user.name);
      emailController = TextEditingController(text: user.email);
      phoneController = TextEditingController(text: user.phone);
      carTypeController = TextEditingController(text: user.carType);
      carModelController = TextEditingController(text: user.carModel);
    }
  }

  @override
  void dispose() {
    nameController?.dispose();
    emailController?.dispose();
    phoneController?.dispose();
    carTypeController?.dispose();
    carModelController?.dispose();
    super.dispose();
  }

  Widget _buildProfileHeader(dynamic user, ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 106,
              height: 106,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.red, AppColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.person_rounded,
                size: 56,
                color: AppColors.red.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name ?? "Name",
          style: theme.textTheme.titleMedium!.copyWith(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? "Email",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
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
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Icon(icon, color: AppColors.red, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: child,
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  Widget _buildAnimatedWidget({required Widget child, required int delayMs}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, val, childWidget) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - val)),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => ClientProfileViewModel(),
      child: Scaffold(
        floatingActionButton: widget.showBackButton ? const ClientNavigateBackButton() : null,
        floatingActionButtonLocation: widget.showBackButton ? FloatingActionButtonLocation.startTop : null,
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (user == null) {
              return Center(child: CircularProgressIndicator(color: AppColors.red));
            }

            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAnimatedWidget(
                        delayMs: 0,
                        child: _buildProfileHeader(user, theme),
                      ),
                      
                      // Expandable profile choices card
                      _buildAnimatedWidget(
                        delayMs: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.04),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              )
                            ],
                            border: Border.all(color: AppColors.grey.withOpacity(0.12), width: 1.5),
                          ),
                          child: Column(
                            children: [
                              _buildExpandableField(
                                context: context,
                                title: "Edit Full Name",
                                icon: Icons.person_outline_rounded,
                                isExpanded: editUserNameFlag,
                                onTap: () => setState(() => editUserNameFlag = !editUserNameFlag),
                                child: ClientCustomTextField(
                                  title: user.name ?? "Name",
                                  controller: nameController,
                                  prefixIcon: Icon(Icons.person_rounded, color: AppColors.red.withOpacity(0.6)),
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                              Divider(color: AppColors.grey.withOpacity(0.15), thickness: 1, indent: 20, endIndent: 20, height: 1),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Email Address",
                                icon: Icons.mail_outline_rounded,
                                isExpanded: editUserEmailFlag,
                                onTap: () => setState(() => editUserEmailFlag = !editUserEmailFlag),
                                child: ClientCustomTextField(
                                  title: user.email ?? "Email",
                                  controller: emailController,
                                  prefixIcon: Icon(Icons.email_rounded, color: AppColors.red.withOpacity(0.6)),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: AppValidators.validateEmail,
                                ),
                              ),
                              Divider(color: AppColors.grey.withOpacity(0.15), thickness: 1, indent: 20, endIndent: 20, height: 1),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Phone Number",
                                icon: Icons.phone_android_rounded,
                                isExpanded: editUserPhoneFlag,
                                onTap: () => setState(() => editUserPhoneFlag = !editUserPhoneFlag),
                                child: ClientCustomTextField(
                                  title: user.phone ?? "Phone",
                                  controller: phoneController,
                                  prefixIcon: Icon(Icons.phone_rounded, color: AppColors.red.withOpacity(0.6)),
                                  keyboardType: TextInputType.phone,
                                  validator: AppValidators.validateEgyptianPhone,
                                ),
                              ),
                              Divider(color: AppColors.grey.withOpacity(0.15), thickness: 1, indent: 20, endIndent: 20, height: 1),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Car Specifications",
                                icon: Icons.car_rental_rounded,
                                isExpanded: editUserCarDataFlag,
                                onTap: () => setState(() => editUserCarDataFlag = !editUserCarDataFlag),
                                child: Column(
                                  children: [
                                    ClientCustomTextField(
                                      title: user.carType ?? "Car Type",
                                      controller: carTypeController,
                                      prefixIcon: Icon(Icons.commute_rounded, color: AppColors.red.withOpacity(0.6)),
                                      validator: AppValidators.validateEmptyField,
                                    ),
                                    const SizedBox(height: 12),
                                    ClientCustomTextField(
                                      title: user.carModel ?? "Car Model",
                                      controller: carModelController,
                                      prefixIcon: Icon(Icons.today_rounded, color: AppColors.red.withOpacity(0.6)),
                                      validator: AppValidators.validateEmptyField,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildAnimatedWidget(
                        delayMs: 300,
                        child: ClientCustomButton(
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
                              if (context.mounted) {
                                Provider.of<UserProvider>(context, listen: false).updateUserInfo(
                                  name: nameController?.text,
                                  phone: phoneController?.text,
                                  email: emailController?.text,
                                  carType: carTypeController?.text,
                                  carModel: carModelController?.text,
                                );
                              }
                              SnackbarService.showSuccessNotification("Profile updated successfully");
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          text: "Save Changes",
                          useGradient: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildAnimatedWidget(
                        delayMs: 450,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(thickness: 1.2, color: AppColors.grey.withOpacity(0.15), indent: 40, endIndent: 40),
                            const SizedBox(height: 20),
                            ClientCustomButton(
                              color: AppColors.pink,
                              action: () async {
                                await widget._loginRepo.logout();
                                if (context.mounted) {
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).clearUser();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    PageRoutesName.userType,
                                    (route) => false,
                                  );
                                }
                              },
                              text: "Logout",
                              textColor: AppColors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: widget.showBackButton ? 0 : 95),
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
