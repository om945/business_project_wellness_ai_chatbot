import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = "AIzaSyD7p-1sAR4kef-tKM-l-vNYx9shUA7ML3Q";

  static const String _model = "models/gemini-2.5-flash";

  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1/";

  final http.Client _client;

  AiService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> getResponse(
    String userMessage,
    Map<String, dynamic> userProfile,
  ) async {
    final prompt =
        """
User profile:
Name: ${userProfile['name']}
Age: ${userProfile['age']}
Weight: ${userProfile['weight']} KG
Height: ${userProfile['height']} CM

You are a friendly and supportive wellness & diet coach. 
Always give short, clear, and practical suggestions based on the user’s profile (age, weight, height, lifestyle). 
Keep the tone positive and motivating. 
Focus on simple daily actions, healthy food choices, and small habit improvements. 
Avoid medical claims. 
End each response with one motivating line that encourages the user to stay consistent and positive.

User query: "$userMessage"
""";

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    });

    try {
      final url = "${_baseUrl}${_model}:generateContent?key=$_apiKey";

      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Error: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
