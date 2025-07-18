import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_ai_app/features/loading/widgets/loading_widget.dart';
import 'package:flutter_travel_ai_app/features/result/cubit/result_cubit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResultCubit>(
      create: (context) => ResultCubit(),
      child: const _LoadingPage(),
    );
  }
}

class _LoadingPage extends StatefulWidget {
  const _LoadingPage({super.key});

  @override
  State<_LoadingPage> createState() => __LoadingPageState();
}

class __LoadingPageState extends State<_LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const LoadingWidget();
  }
}
