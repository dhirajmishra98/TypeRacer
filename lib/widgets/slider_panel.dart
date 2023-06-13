import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/responsive/responsive.dart';

class SliderPanel extends StatefulWidget {
  const SliderPanel({super.key});

  @override
  State<SliderPanel> createState() => _SliderPanelState();
}

class _SliderPanelState extends State<SliderPanel> {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    return Responsive(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: game.gameState['players'].length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.gameState['players'][index]['nickname'],
                  style: const TextStyle(fontSize: 12),

                  // labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Slider(
                  value: (game.gameState['players'][index]['currentWordIndex'] /
                      game.gameState['words'].length),
                  onChanged: (val) {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
