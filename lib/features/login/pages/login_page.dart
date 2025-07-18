import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/features/login/widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginPage();
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({super.key});

  @override
  State<_LoginPage> createState() => __LoginPageState();
}

class __LoginPageState extends State<_LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const LoginWidget();
  }
}