import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/llm_response.dart';
import '';
class LLMRepository {
  final String baseUrl= 'http://localhost:5261';

  LLMRepository();
  final url = Uri.parse('http://localhost:5261/prompt');
 Future<List<LLMResponse>> sendPrompt(String prompt, List<String> llms, String token,String email) async {
    String prompty = jsonEncode(prompt).toString();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email':email,
        'prompt': prompty,
        'llms': llms,
      }),
    );
    print("Using Token: $token");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => LLMResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get LLM responsessssssssssssssssssssssss');
    }
  }
}
