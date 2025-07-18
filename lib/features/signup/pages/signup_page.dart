import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/features/signup/widgets/signup_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignupPage();
  }
}

class _SignupPage extends StatefulWidget {
  const _SignupPage({super.key});

  @override
  State<_SignupPage> createState() => __SignupPageState();
}

class __SignupPageState extends State<_SignupPage> {
  @override
  Widget build(BuildContext context) {
    return const SignupWidget();
  }
}