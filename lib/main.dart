import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_bird_chat_example/constants/send_bird_configurations.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart'; 
import 'screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
      await SendbirdChat.init(appId: SEND_BIRD_APPLICATION_ID); 

runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SendBirdChannelProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Theme Demo',
      theme: ThemeData.dark().copyWith( 
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueGrey.shade900,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
        ),
        colorScheme: const ColorScheme.dark(background: Color(0xFFD9D9D9), secondary:Colors.pinkAccent), 
      ),
      home: const HomeScreen(),
    );
  }

}
