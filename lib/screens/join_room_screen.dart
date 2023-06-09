import 'package:flutter/material.dart';
import 'package:typeracer/resources/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';

import '../responsive/responsive.dart';
import '../widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static const String routeName = '/join-room-screen';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGameListener(context);
    _socketMethods.notCorrectGameListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Join Room',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              CustomTextField(
                controller: _nameController,
                hintText: "Enter your nickname",
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              CustomTextField(
                controller: _gameIdController,
                hintText: "Enter your GameID",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Join',
                onTap: () => _socketMethods.joinGame(
                    _nameController.text.trim(), _gameIdController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
