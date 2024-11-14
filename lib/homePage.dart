import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this

import 'drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _gemini = Gemini.instance;
  final _textFieldController = TextEditingController();
  List<Map<String, List<String>>> _parsedRoadMap = [];
  bool _isLoading = false;

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _parseRoadMap(String response) {
    // Split the response into sections based on empty lines
    final sections = response.split('\n\n');
    List<Map<String, List<String>>> parsedRoadMap = [];

    for (String section in sections) {
      final lines = section.split('\n');
      if (lines.isNotEmpty) {
        final title = lines.first;
        final items = lines.skip(1).toList();

        // Clean up the items by removing * and [] from the strings
        final cleanedItems = items.map((item) {
          // Use a RegExp to find URLs and make them clickable using a TextSpan
          final urlRegExp = RegExp(
              r'((http|https):\/\/)?([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/[a-zA-Z0-9\#\-_\/]+)*\/?');
          return item
              .replaceAll('*', '')
              .replaceAll(RegExp(r'\[|\]'), '')
              .replaceAllMapped(urlRegExp, (match) {
            final url = match[0];
            return url!;
          });
        }).toList();

        parsedRoadMap.add({title: cleanedItems});
      }
    }

    setState(() {
      _parsedRoadMap = parsedRoadMap;
    });
  }

  void _getRoadMap(String prompt) async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetAlert(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var text =
          "give me a road map for a: $prompt with sources to learn each step.";
      var value = await _gemini.text(text);

      if (value != null && value.output != null) {
        _parseRoadMap(value.output!);
      } else {
        _showAlert(
            context, 'Error', 'Could not fetch the roadmap. Please try again.');
      }
    } catch (e) {
      _showAlert(
          context, 'Error', 'Could not fetch the roadmap. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearResponse() {
    setState(() {
      _parsedRoadMap = [];
      _textFieldController.clear();
    });
  }

  List<TextSpan> _buildTextSpans(String text) {
    final urlRegExp = RegExp(
        r'((http|https):\/\/)?([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/[a-zA-Z0-9\#\-_\/]+)*\/?');

    final matches = urlRegExp.allMatches(text);
    int currentIndex = 0;
    List<TextSpan> spans = [];

    for (final match in matches) {
      // Add text before the URL
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      // Add clickable URL
      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(color: Colors.green),
        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(url),
      ));

      currentIndex = match.end;
    }

    // Add remaining text after the last URL
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }

  void launchUrl(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      drawer: MyDrower(),
      body: Stack(
        children: [
          // Background and blur effect
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Main content
          ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'The AI Job Roadmap app helps users plan and achieve their career goals.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const Center(
                child: Text(
                  'Get Your Roadmap Now!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Job Title',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final prompt = _textFieldController.text;
                    if (prompt.isNotEmpty) {
                      _getRoadMap(prompt);
                    } else {
                      _showAlert(
                          context, 'Error', 'Please enter a valid job title.');
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Get Roadmap'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(),
                ))
              else if (_parsedRoadMap.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _parsedRoadMap.length,
                    itemBuilder: (context, index) {
                      final section = _parsedRoadMap[index];
                      final title = section.keys.first;
                      final items = section[title]!;
                      return Card(
                        color: Colors.black.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _textFilter(title),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              for (var item in items)
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.white),
                                    children: _buildTextSpans(item),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (_parsedRoadMap.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: _clearResponse,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _textFilter(String value) {
    String text = "";
    for (int i = 0; i < value.length; i++) {
      if (value[i] != "*") {
        text += value[i];
      }
    }
    return text;
  }
}
