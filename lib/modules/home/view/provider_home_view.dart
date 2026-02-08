import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${user?.name ?? 'Client'}")),
      body:Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Email: ${user?.email}"),
            ),
            SizedBox(height: 30,),
            CustomButton(color: AppColors.red, action: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');
              await prefs.remove('user_role');

              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false).clearUser();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  PageRoutesName.userType,
                      (route) => false,
                );
              }
            }, text: "Logout")
          ],
        ),
      ),
    );
  }
}
