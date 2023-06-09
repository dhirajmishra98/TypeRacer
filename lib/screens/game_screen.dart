import 'package:flutter/material.dart';
import 'package:typeracer/widgets/game_textfield.dart';

class GameScreen extends StatelessWidget {
  static const String routeName = '/game-screen';
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Game Screen"),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        child: const GameTextField(),
      ),
    );
  }
}
