import 'package:flutter/material.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<ClientSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Text("Client Sign Up"),
      ),
    );
  }
}
