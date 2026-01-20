import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${user?.name ?? 'Client'}")),
      body: Center(
        child: Text("Email: ${user?.email}"),
      ),
    );
  }
}
