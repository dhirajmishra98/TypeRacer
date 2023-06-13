import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/responsive/responsive.dart';
import 'package:typeracer/screens/game_screen.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/snackbar.dart';

class WaitingLobby extends StatelessWidget {
  static String routeName = '/waiting-lobby-screen';
  const WaitingLobby({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String gameId =
        Provider.of<GameStateProvider>(context, listen: false).gameState['id'];
    return Scaffold(
      body: Responsive(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Invite your friend to join Race with given below GameID"),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: const Text('GameID : '),
                title: Text(gameId.toString()),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: gameId.toString(),
                      ),
                    ).then(
                      (_) =>
                          showSnackBar(context, "GameId copied to clipBoard"),
                    );
                  },
                  icon: const Icon(Icons.copy),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.5,
            ),
            CustomButton(
              isHome: true,
              text: "Next",
              onTap: () => Navigator.pushNamed(
                context,
                GameScreen.routeName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
