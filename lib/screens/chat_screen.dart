import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/message_list.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/message_sender.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
 

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {

    setupChannel();
    });
  }

  void setupChannel() {
    final provider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);
    provider.populateMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendBirdChannelProvider>(
        builder: (context, sendBirdChatProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(sendBirdChatProvider.openChannel.name),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  // TODO: open options
                },
                icon: const Icon(Icons.menu))
          ],
        ),
        body: SafeArea(
            child: sendBirdChatProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : sendBirdChatProvider.hasError
                    ? Center(
                        child: Column(
                          children: [
                            const Text(
                              "Something went wrong ",
                              style: TextStyle(color: Colors.amberAccent),
                            ),
                            ElevatedButton(
                                onPressed: setupChannel,
                                child: const Text("Try Again"))
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                              child: sendBirdChatProvider.messageList.isNotEmpty
                                  ? const MessageList()
                                  : Container()),

                           const MessageSender()
                          
                        ],
                      )),
      );
    });
  }

//   Widget _messageSender() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Widgets.textField(textEditingController, 'Message'),
//           ),
//           const SizedBox(width: 8.0),
//           ElevatedButton(
//             onPressed: () async {
//               if (textEditingController.value.text.isEmpty) {
//                 return;
//               }

//               openChannel?.sendUserMessage(
//                 UserMessageCreateParams(
//                   message: textEditingController.value.text,
//                 ),
//                 handler: (UserMessage message, SendbirdException? e) async {
//                   if (e != null) {
//                     await _showDialogToResendUserMessage(message);
//                   } else {
//                     _addMessage(message);
//                   }
//                 },
//               );

//               textEditingController.clear();
//             },
//             child: const Text('Send'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showDialogToResendUserMessage(UserMessage message) async {
//     await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Resend: ${message.message}'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   openChannel?.resendUserMessage(
//                     message,
//                     handler: (message, e) async {
//                       if (e != null) {
//                         await _showDialogToResendUserMessage(message);
//                       } else {
//                         _addMessage(message);
//                       }
//                     },
//                   );

//                   Get.back();
//                 },
//                 child: const Text('Yes'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text('No'),
//               ),
//             ],
//           );
//         });
//   }

//   void _addMessage(BaseMessage message) {
//     OpenChannel.getChannel(SEND_BIRD_CHANNEL_URL).then((openChannel) {
//       setState(() {
//         messageList.add(message);
//         title = '${openChannel.name} (${messageList.length})';
//         participantCount = openChannel.participantCount;
//       });

//       // Future.delayed(
//       //   const Duration(milliseconds: 100),
//       //   () => _scroll(messageList.length - 1),
//       // );
//     });
//   }

//   void _updateMessage(BaseMessage message) {
//     OpenChannel.getChannel(SEND_BIRD_CHANNEL_URL).then((openChannel) {
//       setState(() {
//         for (int index = 0; index < messageList.length; index++) {
//           if (messageList[index].messageId == message.messageId) {
//             messageList[index] = message;
//             break;
//           }
//         }

//         title = '${openChannel.name} (${messageList.length})';
//         participantCount = openChannel.participantCount;
//       });
//     });
//   }

//   void _deleteMessage(int messageId) {
//     OpenChannel.getChannel(SEND_BIRD_CHANNEL_URL).then((openChannel) {
//       setState(() {
//         for (int index = 0; index < messageList.length; index++) {
//           if (messageList[index].messageId == messageId) {
//             messageList.removeAt(index);
//             break;
//           }
//         }

//         title = '${openChannel.name} (${messageList.length})';
//         participantCount = openChannel.participantCount;
//       });
//     });
//   }
}
