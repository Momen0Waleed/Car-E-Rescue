import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/auth/login/model/login_repo.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class ClientHomeView extends StatelessWidget {
  ClientHomeView({super.key});

  final LoginRepo _loginRepo = LoginRepo();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${user?.name ?? 'Provider'}")),
      // you can also use this structure instead of using "user" parameter
      //   Consumer<UserProvider>(
      //     builder: (context, userProvider, child) {
      //       return Text("Welcome, ${userProvider.currentUser?.name ?? 'Guest'}");
      //     },
      //   )
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Email: ${user?.email}"),
            ),
            SizedBox(height: 30,),
            CustomButton(color: AppColors.red,
                action: () async {
                  await _loginRepo.logout(); // Clear storage
                  Provider.of<UserProvider>(context, listen: false).clearUser(); // Clear memory
                  Navigator.of(context).pushNamedAndRemoveUntil(PageRoutesName.userType, (route) => false);
                }
            , text: "Logout")
          ],
        ),
      ),
    );
  }
}
