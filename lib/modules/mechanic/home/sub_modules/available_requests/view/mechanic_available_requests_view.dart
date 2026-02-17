import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';

class MechanicAvailableRequestsView extends StatefulWidget {
  const MechanicAvailableRequestsView({super.key});

  @override
  State<MechanicAvailableRequestsView> createState() => _MechanicAvailableRequestsViewState();
}

class _MechanicAvailableRequestsViewState extends State<MechanicAvailableRequestsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NavigateBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(),
    );
  }
}
