import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientProfileView extends StatefulWidget {
  const ClientProfileView({super.key});

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(),
                Text("Name: ${user?.name}"),
                Divider(),
                Text("Email: ${user?.email}"),
                Divider(),
                Text("Role: ${user?.role}"),
                Divider(),
                Text("Car Type: ${user?.carType}"),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
