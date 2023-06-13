import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/client_state_provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/resources/socket_methods.dart';
import 'package:typeracer/widgets/game_textfield.dart';
import 'package:typeracer/widgets/sentence_game.dart';
import 'package:typeracer/widgets/slider_panel.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = '/game-screen';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateTimerListener(context);
    _socketMethods.updateGame(context);
    _socketMethods.gameFinishedListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Chip(
                    label: Text(
                      clientStateProvider.clientState['timer']['msg']
                          .toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                Text(
                  clientStateProvider.clientState['timer']['countDown']
                      .toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SentenceGame(),
                const SizedBox(
                  height: 10,
                ),
                const SliderPanel(),
                if (!game.gameState['isOver'])
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: const GameTextField(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
