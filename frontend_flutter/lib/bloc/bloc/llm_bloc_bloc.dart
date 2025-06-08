import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'llm_bloc_event.dart';
part 'llm_bloc_state.dart';

class LlmBlocBloc extends Bloc<LlmBlocEvent, LlmBlocState> {
  LlmBlocBloc() : super(LlmBlocInitial()) {
    on<LlmFetchData>(_llmFetchData);
    on<LlmBlocGoInResponse>(_llmGoInResponse);
  }
  void _llmFetchData(LlmFetchData event, Emitter<LlmBlocState> emit) {
    //Implement the logic to fetch data from the LLM API
    //This is a placeholder for the actual implementation
    emit(LlmDataFetched(deepseekData: event.query,
        mistralData: "Sample data from Mistral",
        llamaData: "Sample data from Llama",
        geminiData: "Sample data from Gemini"));
  }
  void _llmGoInResponse(LlmBlocGoInResponse event, Emitter<LlmBlocState> emit) {
    // Implement the logic to handle the response from the LLM API
    // This is a placeholder for the actual implementation
    emit(LlmBlocIndsideResponse(title: event.title, message: event.message));
  }
}
