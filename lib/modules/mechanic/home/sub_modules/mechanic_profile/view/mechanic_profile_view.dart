import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';

class MechanicProfileView extends StatefulWidget {
  const MechanicProfileView({super.key});

  @override
  State<MechanicProfileView> createState() => _MechanicProfileViewState();
}

class _MechanicProfileViewState extends State<MechanicProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NavigateBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(),
    );
  }
}
