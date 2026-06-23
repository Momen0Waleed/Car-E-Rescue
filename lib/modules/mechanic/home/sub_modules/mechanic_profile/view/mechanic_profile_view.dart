import 'package:car_e_rescue/core/constants/services/snackbar_service.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/constants/validators/app_validators.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/mechanic_profile/view_model/mechanic_profile_view_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_button.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_custom_text_field.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
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
    if (user != null) {
      nameController = TextEditingController(text: user.name);
      emailController = TextEditingController(text: user.email);
      phoneController = TextEditingController(text: user.phone);
      workshopNameController = TextEditingController(text: user.workshopName);
      experienceYearsController = TextEditingController(
        text: user.experienceYears?.toString() ?? "0",
      );
    }
  }

  @override
  void dispose() {
    nameController?.dispose();
    emailController?.dispose();
    phoneController?.dispose();
    workshopNameController?.dispose();
    experienceYearsController?.dispose();
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
          user.name ?? "Mechanic Profile",
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
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
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
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
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    var theme = Theme.of(context);
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.grey.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.red, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.red,
              size: 26,
            ),
          ],
        ),
      ),
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
    var theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => MechanicProfileViewModel(),
      child: Scaffold(
        appBar: defaultAppBar(title: "Profile", context: context),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;

            if (user == null) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.red),
              );
            }

            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAnimatedWidget(
                        delayMs: 0,
                        child: _buildProfileHeader(user, theme),
                      ),
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
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildExpandableField(
                                context: context,
                                title: "Edit Full Name",
                                icon: Icons.person_outline_rounded,
                                isExpanded: editUserNameFlag,
                                onTap: () => setState(
                                  () => editUserNameFlag = !editUserNameFlag,
                                ),
                                child: ClientCustomTextField(
                                  title: user.name,
                                  controller: nameController,
                                  prefixIcon: Icon(
                                    Icons.person_rounded,
                                    color: AppColors.red.withOpacity(0.6),
                                  ),
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                              Divider(
                                color: AppColors.grey.withOpacity(0.15),
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                height: 1,
                              ),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Email Address",
                                icon: Icons.mail_outline_rounded,
                                isExpanded: editUserEmailFlag,
                                onTap: () => setState(
                                  () => editUserEmailFlag = !editUserEmailFlag,
                                ),
                                child: ClientCustomTextField(
                                  title: user.email,
                                  controller: emailController,
                                  prefixIcon: Icon(
                                    Icons.email_rounded,
                                    color: AppColors.red.withOpacity(0.6),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: AppValidators.validateEmail,
                                ),
                              ),
                              Divider(
                                color: AppColors.grey.withOpacity(0.15),
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                height: 1,
                              ),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Phone Number",
                                icon: Icons.phone_android_rounded,
                                isExpanded: editUserPhoneFlag,
                                onTap: () => setState(
                                  () => editUserPhoneFlag = !editUserPhoneFlag,
                                ),
                                child: ClientCustomTextField(
                                  title: user.phone,
                                  controller: phoneController,
                                  prefixIcon: Icon(
                                    Icons.phone_rounded,
                                    color: AppColors.red.withOpacity(0.6),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator:
                                      AppValidators.validateEgyptianPhone,
                                ),
                              ),
                              Divider(
                                color: AppColors.grey.withOpacity(0.15),
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                height: 1,
                              ),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Workshop Name",
                                icon: Icons.store_outlined,
                                isExpanded: editWorkshopLocationFlag,
                                onTap: () => setState(
                                  () => editWorkshopLocationFlag =
                                      !editWorkshopLocationFlag,
                                ),
                                child: ClientCustomTextField(
                                  title: user.workshopName ?? "Workshop Name",
                                  controller: workshopNameController,
                                  prefixIcon: Icon(
                                    Icons.store_rounded,
                                    color: AppColors.red.withOpacity(0.6),
                                  ),
                                  validator: AppValidators.validateEmptyField,
                                ),
                              ),
                              Divider(
                                color: AppColors.grey.withOpacity(0.15),
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                height: 1,
                              ),
                              _buildExpandableField(
                                context: context,
                                title: "Edit Experience Years",
                                icon: Icons.star_outline_rounded,
                                isExpanded: editExperienceYearsFlag,
                                onTap: () => setState(
                                  () => editExperienceYearsFlag =
                                      !editExperienceYearsFlag,
                                ),
                                child: ClientCustomTextField(
                                  title:
                                      user.experienceYears?.toString() ?? "0",
                                  controller: experienceYearsController,
                                  prefixIcon: Icon(
                                    Icons.star_rounded,
                                    color: AppColors.red.withOpacity(0.6),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: AppValidators.validateEmptyField,
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
                            final viewModel = context
                                .read<MechanicProfileViewModel>();
                            final userProv = Provider.of<UserProvider>(
                              context,
                              listen: false,
                            );

                            int? expYears = int.tryParse(
                              experienceYearsController?.text ?? '',
                            );

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

                              SnackbarService.showSuccessNotification(
                                "Profile updated successfully",
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          text: "Save Changes",
                          useGradient: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedWidget(
                        delayMs: 400,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionTile(
                                context: context,
                                title: "Location",
                                icon: Icons.location_on,
                                onTap: () => Navigator.of(
                                  context,
                                ).pushNamed(PageRoutesName.workshopLocation),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionTile(
                                context: context,
                                title: "My Skills",
                                icon: Icons.build,
                                onTap: () => Navigator.of(
                                  context,
                                ).pushNamed(PageRoutesName.mechanicSkills),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedWidget(
                        delayMs: 450,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              thickness: 1.2,
                              color: AppColors.grey.withOpacity(0.15),
                              indent: 40,
                              endIndent: 40,
                            ),
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
