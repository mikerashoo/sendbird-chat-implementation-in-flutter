import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/common_widgets.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MessageSender extends StatefulWidget {
  const MessageSender({super.key});

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> onSend() async {
    final sendBirdChannelProvider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);
    try {
      if (textEditingController.value.text.isEmpty) {
        return;
      }

      String message = textEditingController.value.text;

      print("TextField Value: " + message);
      bool isSubmitted = await sendBirdChannelProvider.sendMessage(message);
      print("IsSubmitted:  ${isSubmitted}");
        textEditingController.clear(); 
    } catch (e) {
      print("Error while sending message: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: onSend,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogToResendUserMessage(UserMessage message) async {
    final sendBirdChannelProvider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text('Resend: ${message.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  sendBirdChannelProvider.openChannel.resendUserMessage(
                    message,
                    handler: (message, e) async {
                      if (e != null) {
                        await _showDialogToResendUserMessage(message);
                      } else {
                        sendBirdChannelProvider.addMessage(message);
                      }
                    },
                  );

                  Get.back();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('No'),
              ),
            ],
          );
        });
  }
}
