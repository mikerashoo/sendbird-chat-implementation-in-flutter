import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = false;
  bool hasError = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: const Text('Chat'),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(onPressed: (){
              // TODO: open options
          }, icon: const Icon(Icons.menu))
          ],
        ),
      body: const SafeArea(child: Center(
        child: Text("Welcome to the screen"),
      )),
    );
  }
}