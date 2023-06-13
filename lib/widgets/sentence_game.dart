import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_client.dart';
import 'package:typeracer/resources/socket_methods.dart';
import 'package:typeracer/widgets/score_board.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  final SocketMethods _socketMethods = SocketMethods();
  dynamic playerMe;

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGame(context);
  }

  void findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  Widget getTypedWords(words, player) {
    var tempWords = words.sublist(0, player['currentWordIndex']);
    String typedWords = tempWords.join(' ');
    return Text(
      typedWords,
      style: const TextStyle(
        color: Colors.green,
        fontSize: 25,
      ),
    );
  }

  Widget currentWords(words, player) {
    return Text(
      words[player['currentWordIndex']],
      style: const TextStyle(
        decoration: TextDecoration.underline,
        fontSize: 25,
      ),
    );
  }

  Widget getRemainingWords(words, player) {
    var tempWords = words.sublist(player['currentWordIndex'] + 1, words.length);
    String remainingWords = tempWords.join(' ');
    return Text(
      remainingWords,
      style: const TextStyle(
        fontSize: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayerMe(game);

    if (game.gameState['words'].length > playerMe['currentWordIndex'] &&
        !game.gameState['isOver']) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            getTypedWords(game.gameState['words'], playerMe),
            currentWords(game.gameState['words'], playerMe),
            getRemainingWords(game.gameState['words'], playerMe),
          ],
        ),
      );
    }
    return const ScoreBoard();
  }
}
