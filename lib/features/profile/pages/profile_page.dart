import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/features/profile/widgets/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfilePage();
  }
}

class _ProfilePage extends StatefulWidget {
  const _ProfilePage({super.key});

  @override
  State<_ProfilePage> createState() => __ProfilePageState();
}

class __ProfilePageState extends State<_ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const ProfileWidget();
  }
}