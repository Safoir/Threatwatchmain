import 'package:flutter/material.dart';

import 'game/game_screen.dart';

void main() {
  runApp(const FlappyCatApp());
}

class FlappyCatApp extends StatelessWidget {
  const FlappyCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Cat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange)),
      home: const GameScreen(),
    );
  }
}
