import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import the package

void main() {
  try {
    Gemini.init(apiKey: "AIzaSyDueBLKTxP68nOom8LgytxpQAS6GbzC9BI");
  } catch (e) {
    print("ex1");
    print(e);
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
      home: const MyHomePage(title: 'Road Map AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _gemini = Gemini.instance; // Instance for interacting with Gemini API
  String _roadMapText = ""; // Variable to store the Gemini response
  final _textFieldController = TextEditingController(); // Controller for the TextField
  String _response = ""; // Variable to display API response

  // Method to call Gemini API and get the roadmap
  void _getRoadMap(String prompt) async {
    try {
      var text = "give me a road map for: $prompt";
      print(text);

      var value = await _gemini.text(text); // Await the response from the API

      if (value != null && value.output != null) {
        setState(() {
          _response = value.output!; // Update the state with the API response
        });
        print(_response);
      } else {
        print('No output received from the API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _clearResponse() {
    setState(() {
      _response = ""; // Clear the API response
      _roadMapText = ""; // Clear the roadmap text
      _textFieldController.clear(); // Clear the TextField input
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/70d1c82d5b7fe75cb61f7866311eafd4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Apply blur effect on top of the image
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          // Main content with ListView
          ListView(
            children: <Widget>[
              const Center(
                child: Text(
                  'WELCOME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.7),
                    border: const OutlineInputBorder(),
                    hintText: 'Road Map For',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 20),
              // Button to fetch roadmap
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
                child: TextButton(
                  onPressed: () {
                    final prompt = _textFieldController.text;
                    if (prompt.isNotEmpty) {
                      _getRoadMap(prompt);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Get it !!!'),
                ),
              ),
              // Response field
              if (_response.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SelectableText(
                    _response,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (_response.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 10),
                  child: TextButton(
                    onPressed: _clearResponse,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear'),
                  ),
                )
              else
                const SizedBox.shrink(), // This is a placeholder in case the condition is false


            ],
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
        title: Text(widget.title),
      ),
    );
  }
}
