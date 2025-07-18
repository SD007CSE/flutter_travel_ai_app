import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/features/offlinedb/widgets/offlinedb_widget.dart';

class OfflinedbPage extends StatelessWidget {
  const OfflinedbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _offlinedbPage();
  }
}

class _offlinedbPage extends StatefulWidget {
  const _offlinedbPage({super.key});

  @override
  State<_offlinedbPage> createState() => __offlinedbPageState();
}

class __offlinedbPageState extends State<_offlinedbPage> {
  @override
  Widget build(BuildContext context) {
    return const OfflinedbWidget();
  }
}