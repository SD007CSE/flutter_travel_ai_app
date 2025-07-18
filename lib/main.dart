import 'package:flutter/material.dart';
import 'package:flutter_travel_ai_app/core/service_locator.dart';
import 'features/login/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupServiceLocator();
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY'] ?? ''); // TODO: Set GEMINI_API_KEY in your .env file
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}