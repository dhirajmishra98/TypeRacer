import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/provider/game_state_provider.dart';
import 'package:typeracer/screens/create_room_screen.dart';
import 'package:typeracer/screens/game_screen.dart';
import 'package:typeracer/screens/home_page_screen.dart';
import 'package:typeracer/screens/join_room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameStateProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TypeRacer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: HomePageScreen.routeName,
        routes: {
          CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
          JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
          HomePageScreen.routeName: (context) => const HomePageScreen(),
          GameScreen.routeName: (context) => const GameScreen(),
        },
      ),
    );
  }
}
