import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  static const String routeName = '/game-screen';
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Game Screen"),
      ),
    );
  }
}
