import 'package:flutter/material.dart';

class ProviderSignUpScreen extends StatefulWidget {
  const ProviderSignUpScreen({super.key});

  @override
  State<ProviderSignUpScreen> createState() => _ProviderSignUpScreenState();
}

class _ProviderSignUpScreenState extends State<ProviderSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Provider Sign Up"),
      ),
    );
  }
}
