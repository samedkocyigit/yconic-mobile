import 'package:flutter/material.dart';

class AiSuggestionScreen extends StatelessWidget {
  const AiSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yconic Ai Suggestion'),
      ),
      body: Center(
        child: Text(
          'Welcome to Yconic!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
