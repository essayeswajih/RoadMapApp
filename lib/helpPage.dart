import 'package:flutter/material.dart';
import 'dart:ui'; // Import for ImageFilter

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'How to Use AI Job Roadmap?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Adjust text color for visibility
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '1. Enter a prompt in the text field.',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white, // Adjust text color for visibility
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '2. Click "Get it !!!" to get the road map.',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white, // Adjust text color for visibility
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '3. The road map will be displayed in the response field.',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white, // Adjust text color for visibility
                    ),
                  ),
                  const SizedBox(height: 70.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}