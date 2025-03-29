import 'package:flutter/material.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yconic Home Tab'),
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
