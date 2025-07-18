import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_ai_app/features/home/widgets/home_widget.dart';
import 'package:flutter_travel_ai_app/features/result/cubit/result_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResultCubit>(
      create: (context) => ResultCubit(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeWidget();
  }
}
