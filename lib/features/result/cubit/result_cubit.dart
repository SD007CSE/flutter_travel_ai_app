import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_ai_app/core/models/ai_response.dart';
import 'package:flutter_travel_ai_app/core/repositories/remote/remote_repo_interface.dart';
import 'package:flutter_travel_ai_app/core/service_locator.dart';

part 'result_state.dart';

class ResultCubit extends Cubit<ResultState> {
  ResultCubit() : super(const ResultInital());

  final remoteRepo = locator<RemoteRepoInterface>();

  Future<void> getTheResponse({required String query}) async {
    emit(const ResultLoading());

    try {
      // debugPrint(state.toString());
      final response = await remoteRepo.getTravelItenary(query: query);
      if (response.candidates.first.content.parts.isNotEmpty) {
        emit(ResultLoaded(response: response));
      } else {
        emit(const ResultFailed(message: 'Failed To Get the result'));
      }
    } catch (e) {
      emit(const ResultFailed(message: 'Failed To Get the result'));
    }
  }
}
