import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import the package

import 'homePage.dart'; // For checking network connectivity

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    String? apiKey =
        "AIzaSyDueBLKTxP68nOom8LgytxpQAS6GbzC9BI"; // Replace with actual API key
    if (apiKey.isEmpty) {
      throw Exception('API key is missing');
    }
    await Gemini.init(apiKey: apiKey); // Await initialization
  } catch (e) {
    print('Failed to initialize Gemini API: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Gemini Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.green,
          primaryContainer: Colors.black,
          secondary: Colors.greenAccent,
          secondaryContainer: Colors.black,
          surface: Colors.black,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AI Job Roadmap'),
    );
  }
}
