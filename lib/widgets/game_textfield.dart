import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_client.dart';
import 'package:typeracer/resources/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({super.key});

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethods _socketMethods = SocketMethods();
  late GameStateProvider? game;
  dynamic playerMe;

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  void findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  void handleStart(GameStateProvider game) {
    _socketMethods.startTimer(playerMe['_id'], game.gameState['id']);
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);
    return CustomButton(
      text: "Start",
      onTap: () => handleStart(gameData),
    );
  }
}
