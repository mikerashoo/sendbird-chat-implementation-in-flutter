
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SendBird Implementation'),
        ),
        body: SafeArea(
            child: SizedBox(
              // color: Colors.indigoAccent,
              width: double.infinity,
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              const Text("Welcome to SendBird"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                  },
                  child: const Text("Join Chat"))
                      ],
                    ),
            )));
  }
}
