import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import the package

import 'drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _gemini = Gemini.instance; // Instance for interacting with Gemini API
  String _roadMapText = ""; // Variable to store the Gemini response
  final _textFieldController =
      TextEditingController(); // Controller for the TextField
  String _response = ""; // Variable to display API response
  bool _isLoading = false; // Flag for showing loading indicator

  // Method to check for network connection
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _showNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No Internet Connection'),
        duration: Duration(seconds: 2), // Show for 2 seconds
      ),
    );
  }

  // Method to show an alert dialog when there's no internet
  void _showNoInternetAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content:
              const Text('Please check your network settings and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to call Gemini API and get the roadmap
  void _getRoadMap(String prompt) async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetAlert(context);
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      var text =
          "give me a road map for a: $prompt with a sources to learn each steps in the road map. i want the response in a language that the job written with";
      var value = await _gemini.text(text); // Await the response from the API

      if (value != null && value.output != null) {
        setState(() {
          print(value.output!);
          _response = value.output!; // Update the state with the API response
        });
      } else {
        _showAlert(context, 'Error',
            'Error: Could not fetch the roadmap. Please check your internet connection or try again later.1');
      }
    } catch (e) {
      _showAlert(context, 'Error',
          'Error: Could not fetch the roadmap. Please check your internet connection or try again later.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  _showAlert(
                      context, 'Error', 'Failed to load image: $exception');
                  // You can use a default color or an alternative image
                },
              ),
            ),
            child: Container(
                color:
                    Colors.black.withOpacity(0.3)), // Fallback if image fails
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
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'The AI Job Roadmap app helps users plan and achieve their career goals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    'Get your road map now !!!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
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
                    hintText: 'Job Title',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 20),
              // Button to fetch roadmap
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    final prompt = _textFieldController.text;
                    if (prompt.isNotEmpty) {
                      _getRoadMap(prompt);
                    } else {
                      _showAlert(
                          context, 'Error', 'Please provide a valid input.');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Get it !!!'),
                ),
              ),
              // Response field
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              // Loading indicator
              if (!_isLoading && _response.isNotEmpty)
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
              if (!_isLoading && _response.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: _clearResponse,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear'),
                  ),
                )
              else
                const SizedBox.shrink(),
              // Placeholder if there's no response
            ],
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
        title: Text(widget.title),
      ),
      drawer: MyDrower(),
    );
  }
}
