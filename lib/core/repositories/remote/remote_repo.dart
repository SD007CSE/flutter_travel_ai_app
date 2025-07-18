import 'package:flutter_travel_ai_app/core/models/ai_request.dart' as req;
import 'package:flutter_travel_ai_app/core/models/ai_response.dart' as res;
import 'package:flutter_travel_ai_app/core/networks/api_endpoints.dart';
import 'package:flutter_travel_ai_app/core/networks/network_config.dart';
import 'package:flutter_travel_ai_app/core/repositories/remote/remote_repo_interface.dart';

class RemoteRepo implements RemoteRepoInterface {
  final NetworkProvider networkProvider;

  RemoteRepo({required this.networkProvider});

  @override
  Future<res.AiResponse> getTravelItenary({required String query}) async {
    try {
      final aiRequest = req.AiRequest(
        systemInstruction: req.SystemInstruction(parts: [
          req.Parts(
              text:
                  "You are an expert travel planner AI. The user will give you a trip description in plain English.\n\nYour task is to generate a structured itinerary in **valid JSON** with the following format:\n\n{\n  \"JSON\": true,\n  \"title\": \"Trip title, e.g., Bali 7-Day Peaceful Trip\",\n  \"startDate\": \"YYYY-MM-DD\",\n  \"endDate\": \"YYYY-MM-DD\",\n  \"days\": [\n    {\n      \"date\": \"YYYY-MM-DD\",\n      \"summary\": \"Short summary of the day\",\n      \"items\": [\n        {\n          \"time\": \"HH:MM in 24-hour format\",\n          \"activity\": \"What they will do\",\n          \"location\": \"Latitude,Longitude (no place names)\"\n        }\n      ]\n    }\n  ]\n}\n\n❗Only return a valid JSON object. Do not include explanations, markdown, or any other text. Add a field \"JSON\": true at the top level of the JSON object. If you are returning a JSON itinerary. DO NOT ADD ANY NOTES, EXPLAINATION, MARKDOWN, OR ANY OTHER TEXT BEFORE OR AFTER THE JSON. ONLY RETURN THE JSON OBJECT.")
        ]),
        contents: [
          req.Contents(parts: [req.Parts(text: query)])
        ],
      );

      final response = await networkProvider.noAuth(headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': ApiEndpoints.apiKey,
      }).post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
        data: aiRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return res.AiResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to get itinerary:');
      }
    } catch (e) {
      throw Exception('Failed to get itinerary: $e');
    }
  }
}
