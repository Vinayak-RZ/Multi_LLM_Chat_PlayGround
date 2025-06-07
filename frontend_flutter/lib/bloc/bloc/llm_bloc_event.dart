part of 'llm_bloc_bloc.dart';

@immutable
sealed class LlmBlocEvent {}

class LlmFetchData extends LlmBlocEvent {
  final String query;

  LlmFetchData({required this.query});
}
class LlmFetchDataWithContext extends LlmBlocEvent {
  final String query;
  final String context;

  LlmFetchDataWithContext({required this.query, required this.context});
}