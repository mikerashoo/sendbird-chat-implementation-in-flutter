import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MessageSender extends StatefulWidget {
  const MessageSender({super.key, required this.onAdd});

final Function(BaseMessage message) onAdd;
  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  TextEditingController textEditingController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {
        _isButtonDisabled = textEditingController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> onSend() async {
    try {
      String message = textEditingController.value.text;

      if (message.isEmpty) {
        return;
      }

      final sendBirdChannelProvider =
          Provider.of<SendBirdChannelProvider>(context, listen: false);
      OpenChannel openChannel = sendBirdChannelProvider.openChannel;

      openChannel.sendUserMessageWithText(
        message,
        handler: (buildMessage, e) {
          if (e == null) {
            widget.onAdd(buildMessage);
          } else {
            // TODO: handle error
            print("Errror sending message: ${e}");
          }
        },
      );

      textEditingController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      print("Error while sending message: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade900), // Change border color here
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade900), // Change border color here
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .grey.shade900), // Change focused border color here
                  borderRadius: BorderRadius.circular(10.0),
                ),
                isDense: true,
                hintText: '',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                suffixIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: Ink(
                    height: 4,
                    width: 4,
                    decoration: ShapeDecoration(
                      color: _isButtonDisabled
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.secondary,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                      ),
                      onPressed: _isButtonDisabled ? null : onSend,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
