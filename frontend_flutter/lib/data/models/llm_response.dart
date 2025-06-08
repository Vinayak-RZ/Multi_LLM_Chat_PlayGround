class LLMResponse {
  final String llmModel;
  final String response;

  LLMResponse({required this.llmModel, required this.response});

  factory LLMResponse.fromJson(Map<String, dynamic> json) {
    return LLMResponse(
      llmModel: json['llmModel'],
      response: json['response'],
    );
  }
}
