import 'package:flutter/material.dart';
import 'package:typeracer/resources/socket_methods.dart';
import 'package:typeracer/responsive/responsive.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  static const String routeName = '/create-room-screen';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
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
                'Create Room',
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
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Create',
                onTap: () =>
                    _socketMethods.createGame(_nameController.text.trim()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
