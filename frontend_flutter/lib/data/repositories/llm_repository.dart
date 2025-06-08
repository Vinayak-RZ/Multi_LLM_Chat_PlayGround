import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/llm_response.dart';

class LLMRepository {
  final String baseUrl= 'http://localhost:5261';

  LLMRepository();
  final url = Uri.parse('http://localhost:5261/prompt');
 Future<List<LLMResponse>> sendPrompt(String prompt, List<String> llms, String token) async {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'prompt': prompt,
        'llms': llms,
      }),
    );
    print("Using Token: $token");
    print(prompt);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => LLMResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get LLM responsessssssssssssssssssssssss');
    }
  }
}
