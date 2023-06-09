import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_client.dart';
import 'package:typeracer/screens/game_screen.dart';
import 'package:typeracer/widgets/snackbar.dart';

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

  void joinGame(String nickname, String gameId) {
    if (nickname.isNotEmpty && gameId.isNotEmpty) {
      _socketClient.emit("joinGame", {
        'nickname': nickname,
        'gameId': gameId,
      });
    }
  }

  void startTimer(String playerId, String gameId) {
    _socketClient.emit("timer", {
      'playerId': playerId,
      'gameId': gameId,
    });
  }

  //Listeners
  void updateGameListener(BuildContext context) {
    _socketClient.on("updateGame", (data) {
      // ignore: unused_local_variable
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

  void notCorrectGameListener(BuildContext context) {
    _socketClient.on("notCorrectGame", (data) {
      print(data);
      showSnackBar(context, data);
    });
  }

  void updateTimerListener(BuildContext context){}
}
