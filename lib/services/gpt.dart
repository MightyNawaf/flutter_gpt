import 'dart:convert';

import 'package:http/http.dart' as http;

class GPTService {
  static const url = 'https://api.openai.com/v1/chat/completions';
  static const key = 'Bearer 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';
  static const org = 'org-0QTu7VnH24YVr7oqKNL2iaBQ';

  Future<List<Suggestion>> getSuggestions() async {
    final uri = Uri.parse(url);
    final request = await http.post(
      uri,
      headers: {'OpenAI-Organization': org, 'Authorization': key, 'Content-Type': 'application/json'},
      body: json.encode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a traveling consultant and your name is Nawaf. people will try to give you their traveling budgets and thier intrests and your job is to provide suggestions about where the can travel to. response with the city name and a description in a json format, write super short description and the city key in the json object should be city and give multiple suggestions as a list of objects, make the response return a list conatining only the objects them selves without the suggestions key, list of objects directly"
            },
            {"role": "user", "content": "My budget is ${Data.budget} dollars"},
            {"role": "user", "content": "I like ${Data.interests}"}
          ]
        },
      ),
    );

    final jsonData = json.decode(request.body);
	final decodeContent = json.decode(jsonData['choices'][0]['message']['content']);
    // log('DATA: $jsonData');
    final suggestions = <Suggestion>[];
    for (final s in decodeContent) {
      suggestions.add(Suggestion.fromJson(s));
    }
    return suggestions;
  }
}

class Data {
  static List<String> interests = [];
  static int budget = 0;
}

class Suggestion {
  String? city;
  String? description;

  Suggestion.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    description = json['description'];
  }

  Suggestion({this.city, this.description});
}
