part of 'llm_bloc_bloc.dart';

@immutable
sealed class LlmBlocState {}

final class LlmBlocInitial extends LlmBlocState {}

final class LlmDataFetched extends LlmBlocState {
  final String deepseekData;
  final String mistralData;
  final String llamaData;
  final String geminiData;

  LlmDataFetched({required this.deepseekData, required this.mistralData, required this.llamaData, required this.geminiData});
}
final class LlmBlocIndsideResponse extends LlmBlocState {
  final String title;
  final String message;
  final String futureprompt;

  LlmBlocIndsideResponse({required this.message, required this.title, required this.futureprompt});
}
final class LlmBlocFailure extends LlmBlocState {
  final String error;

  LlmBlocFailure({required this.error});
}
final class LlmBlocLoading extends LlmBlocState {
  final String message;

  LlmBlocLoading({required this.message});
}
final class LlmBlocHistory extends LlmBlocState {
  final List<String> responses;

  LlmBlocHistory({required this.responses});
}
final class LlmBlocSuccess extends LlmBlocState {
  final String message;

  LlmBlocSuccess({required this.message});
}