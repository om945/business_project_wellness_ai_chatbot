import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const List<String> _apiKeys = [
    "AIzaSyD7p-1sAR4kef-tKM-l-vNYxshUA7ML3Q", // Primary key
    "AIzaSyD4uuW6R--vD6mANp6eVUfdO_6ndZhhUQ8", // Fallback key
  ];

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
Gender: ${userProfile['gender']}
Age: ${userProfile['age']}
Weight: ${userProfile['weight']} KG
Height: ${userProfile['height']} CM
BMI: ${userProfile['bmi'].toStringAsFixed(2)}

You are a friendly and supportive wellness, diet & Workout coach. 
Always give short, clear, and practical suggestions based on the user’s profile (age, gender, weight, height, BMI, lifestyle). 
Keep the tone positive and motivating. 
Focus on simple daily actions, healthy food choices, and small habit improvements. 
Avoid medical claims. 
End each response with one motivating line that encourages the user to stay consistent and positive.

if use only say Hi or Hello or anything related to that just replay to there answer positively and motivate them

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

    for (final apiKey in _apiKeys) {
      try {
        final url = "${_baseUrl}${_model}:generateContent?key=$apiKey";

        final response = await _client.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data["candidates"][0]["content"]["parts"][0]["text"];
        } else if (response.statusCode == 429) {
          continue;
        }
      } catch (e) {
        return "Error: You have reached your today's limit, or there was a network issue. Please try again later.";
      }
    }
    return "You have reached your today's limit, or there was a network issue. Please try again later.";
  }
}
