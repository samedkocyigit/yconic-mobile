import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yconic Explore'),
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
