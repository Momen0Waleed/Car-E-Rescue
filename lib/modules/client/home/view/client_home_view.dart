import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/progress_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart' show Provider;

class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.red,
        title: FittedBox(
          child: Text(
            "Welcome, ${user?.name ?? 'Client'}",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        actionsPadding: EdgeInsetsGeometry.all(0),
        actions: [
          Bounceable(
            scaleFactor: 0.7,
            onTap: () {
              Navigator.of(context).pushNamed(PageRoutesName.clientProfile);
            },
            child: Icon(Icons.person_sharp, size: 35,color: AppColors.white),
          ),
          SizedBox(width: 20),
        ],
      ),
      // you can also use this structure instead of using "user" parameter
      //   Consumer<UserProvider>(
      //     builder: (context, userProvider, child) {
      //       return Text("Welcome, ${userProvider.currentUser?.name ?? 'Guest'}");
      //     },
      //   )
      body: Container(
        color: AppColors.red,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TwoValueCircle(completed: 80, canceled: 20),
                  SizedBox(height: 30),
                  Bounceable(
                    duration: Duration(milliseconds: 400),
                    scaleFactor: 0.8,
                    onTap: () {
                      Navigator.of(context).pushNamed(PageRoutesName.userRequest);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          "Request",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Bounceable(
                    duration: Duration(milliseconds: 400),
                    scaleFactor: 0.8,
                    onTap: () {
                      Navigator.of(context).pushNamed(PageRoutesName.userDiagnose);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          "Diagnose with Sensor",
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
