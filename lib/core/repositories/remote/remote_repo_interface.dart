import 'package:flutter_travel_ai_app/core/models/ai_response.dart';

abstract class RemoteRepoInterface {

Future<AiResponse> getTravelItenary({required String query});

}