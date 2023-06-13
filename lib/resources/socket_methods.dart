import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:typeracer/provider/client_state_provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_client.dart';
import 'package:typeracer/screens/game_screen.dart';
import 'package:typeracer/widgets/snackbar.dart';
import 'package:typeracer/screens/waiting_lobby.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

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

  void sendUserInput(String value, String gameId) {
    _socketClient.emit("userInput", {
      'userInput': value,
      'gameId': gameId,
    });
  }

  //Listeners
  void updateGameListener(
      {required BuildContext context, required bool isGameCreator}) {
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

      if (data['_id'].isNotEmpty && !_isPlaying) {
        if (isGameCreator) {
          Navigator.pushNamed(context, WaitingLobby.routeName);
        } else {
          Navigator.pushNamed(context, GameScreen.routeName);
        }
        _isPlaying = true;
      }
    });
  }

  void notCorrectGameListener(BuildContext context) {
    _socketClient.on("notCorrectGame", (data) {
      showSnackBar(context, data);
    });
  }

  void updateTimerListener(BuildContext context) {
    final clientStateProvider =
        Provider.of<ClientStateProvider>(context, listen: false);
    _socketClient.on("timer", (data) {
      clientStateProvider.setClientState(data);
    });
  }

  void updateGame(BuildContext context) {
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
    });
  }

  void gameFinishedListener(BuildContext context) {
    _socketClient.on(
      'done',
      (data) => _socketClient.off('timer'),
    );
  }
}
