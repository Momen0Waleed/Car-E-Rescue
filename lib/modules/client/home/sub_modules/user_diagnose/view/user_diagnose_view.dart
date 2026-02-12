import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class UserDiagnoseView extends StatefulWidget {
  const UserDiagnoseView({super.key});

  @override
  State<UserDiagnoseView> createState() => _UserDiagnoseViewState();
}

class _UserDiagnoseViewState extends State<UserDiagnoseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Diagnose", context: context),
      body: Center(
        child: Text("User Diagnose Page"),
      ),
    );
  }
}
