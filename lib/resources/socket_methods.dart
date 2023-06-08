import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_client.dart';
import 'package:typeracer/screens/game_screen.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  //Emitters
  void createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit("createGame", {
        'nickname': nickname,
      });
    }
  }

  //Listeners
  void updateGameListener(BuildContext context) {
    _socketClient.on("updateGame", (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
        id: data['_id'],
        words: data['words'],
        players: data['players'],
        isJoin: data['isJoin'],
        isOver: data['isOver'],
      );

      if (data['_id'].isNotEmpty) {
        Navigator.pushNamed(context, GameScreen.routeName);
      }
    });
  }
}
