import 'dart:collection';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/data/repositories/llm_repository.dart';
part 'llm_bloc_event.dart';
part 'llm_bloc_state.dart';

class LlmBlocBloc extends Bloc<LlmBlocEvent, LlmBlocState> {
final LLMRepository llmRepository;

  LlmBlocBloc({required this.llmRepository}) : super(LlmBlocInitial()) {
    on<LlmFetchData>(_llmFetchData);
    on<LlmBlocGoInResponse>(_llmGoInResponse);
  }
  void _llmFetchData(LlmFetchData event, Emitter<LlmBlocState> emit) async {
    
    emit(LlmBlocLoading(message:"Loading LLM data..."));

    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        emit(LlmBlocFailure(error:"Auth token not found."));
        return;
      }

       final responses = await llmRepository.sendPrompt(
        event.query,
        event.selectedLLMs,
        token,
      );

      // Create variables to hold each LLM's response
      String deepseekData = "";
      String mistralData = "";
      String llamaData = "";
      String geminiData = "";

      for (var res in responses) {
        switch (res.llmModel.toLowerCase()) {
          case "deepseek":
            deepseekData = res.response;
            break;
          case "mistral":
            mistralData = res.response;
            break;
          case "llama":
            llamaData = res.response;
            break;
          case "gemini":
            geminiData = res.response;
            break;
        }
      }

      emit(
        LlmDataFetched(
          deepseekData: deepseekData,
          mistralData: mistralData,
          llamaData: llamaData,
          geminiData: geminiData,
        ),
      );
    } catch (e) {
      emit(LlmBlocFailure(error:"Failed to fetch LLM responses: $e"));
    }
  }

  void _llmGoInResponse(LlmBlocGoInResponse event, Emitter<LlmBlocState> emit) {
    // Implement the logic to handle the response from the LLM API
    // This is a placeholder for the actual implementation
    emit(LlmBlocIndsideResponse(title: event.title, message: event.message));
  }
}
