import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_bird_chat_example/constants/send_bird_configurations.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:send_bird_chat_example/widgets/page_state_checker.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool hasError = false;
  User? user;
  OpenChannel? openChannel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setUpChannel();
  }

  Future<void> setUpChannel() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

    final sendBirdChatProvider = Provider.of<SendBirdChannelProvider>(context, listen: false);
     User user = await SendbirdChat.connect(TEST_USER_ID);

      await OpenChannel.getChannel(SEND_BIRD_CHANNEL_URL).then((_openChannel) {

        sendBirdChatProvider.initialize(user, _openChannel);
        setState(() {
          openChannel = _openChannel;
          isLoading = false;
          hasError = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SendBird Implementation'),
        ),
        body: SafeArea(
            child: PageStateChecker(
                isLoading: isLoading,
                hasError: hasError,
                content: SizedBox(
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
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ChatScreen()));
                          },
                          child: Text("Open ${openChannel?.name} Chat"))
                    ],
                  ),
                ))));
  }
}
