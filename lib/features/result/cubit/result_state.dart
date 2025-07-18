part of 'result_cubit.dart';

abstract class ResultState extends Equatable {
  const ResultState();
}

class ResultInital extends ResultState {
  const ResultInital();

  @override
  List<Object?> get props => [];
}

class ResultLoading extends ResultState {
  const ResultLoading();

  @override
  List<Object?> get props => [];
}

class ResultLoaded extends ResultState {
  final AiResponse response;
  const ResultLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ResultFailed extends ResultState {
  final String message;
  const ResultFailed({required this.message});

  @override
  List<Object?> get props => [];

}
