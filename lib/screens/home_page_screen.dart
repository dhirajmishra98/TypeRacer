import 'package:flutter/material.dart';
import 'package:typeracer/screens/create_room_screen.dart';
import 'package:typeracer/screens/join_room_screen.dart';
import 'package:typeracer/widgets/custom_button.dart';

class HomePageScreen extends StatelessWidget {
  static const String routeName = "/home-page-screen";
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create/Join Rooms',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "Create",
                  onTap: () =>
                      Navigator.pushNamed(context, CreateRoomScreen.routeName),
                  isHome: true,
                ),
                CustomButton(
                  text: "join",
                  onTap: () =>
                      Navigator.pushNamed(context, JoinRoomScreen.routeName),
                  isHome: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
