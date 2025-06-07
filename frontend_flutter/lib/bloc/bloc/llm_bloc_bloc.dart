import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'llm_bloc_event.dart';
part 'llm_bloc_state.dart';

class LlmBlocBloc extends Bloc<LlmBlocEvent, LlmBlocState> {
  LlmBlocBloc() : super(LlmBlocInitial()) {
    on<LlmFetchData>(_llmFetchData);
  }
  void _llmFetchData(LlmFetchData event, Emitter<LlmBlocState> emit) {
    // Implement the logic to fetch data from the LLM API
    // This is a placeholder for the actual implementation
    emit(LlmDataFetched(deepseekData: "Sample data from LLM",
        mistralData: "Sample data from Mistral",
        llamaData: "Sample data from Llama",
        geminiData: "Sample data from Gemini"));
  }
}
