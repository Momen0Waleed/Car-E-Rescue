import 'package:car_e_rescue/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key});

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
      body: Center(
        child: Text("Email: ${user?.email}"),
      ),
    );
  }
}
