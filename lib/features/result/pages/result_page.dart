import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_ai_app/core/models/ai_response.dart';
import 'package:flutter_travel_ai_app/features/result/cubit/result_cubit.dart';
import 'package:flutter_travel_ai_app/features/result/widgets/result_widget.dart';

class ResultPage extends StatelessWidget {
  final AiResponse response;
  final String userQuery;
  const ResultPage({super.key, required this.response, required this.userQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResultCubit>(
      create: (context) => ResultCubit(),
      child: _ResultPage(
        response: response,
        userQuery: userQuery,
      ),
    );
  }
}

class _ResultPage extends StatefulWidget {
  final AiResponse response;
  final String userQuery;
  const _ResultPage({required this.response, required this.userQuery});

  @override
  State<_ResultPage> createState() => __ResultPageState();
}

class __ResultPageState extends State<_ResultPage> {
  @override
  Widget build(BuildContext context) {
    return ResultWidget(
      response: widget.response,
      userQuery: widget.userQuery,
    );
  }
}
