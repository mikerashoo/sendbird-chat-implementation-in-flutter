import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:send_bird_chat_example/constants/send_bird_configurations.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/common_widgets.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:timeago/timeago.dart' as timeago;
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);

    return ScrollablePositionedList.builder(
      padding: const EdgeInsets.all(8),
      physics: const ClampingScrollPhysics(),
      initialScrollIndex: provider.messageList.length - 1,
      itemScrollController: itemScrollController,
      itemCount: provider.messageList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= provider.messageList.length) return Container();

        BaseMessage message = provider.messageList[index];

        bool isUserMessage = message.sender != null &&
            message.sender!.userId == provider.user.userId;
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: isUserMessage
                ? Align(
                  alignment: Alignment.centerRight,
                  child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

                    decoration:  BoxDecoration(
                       gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                ],
              ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16),  bottomRight: Radius.circular(16), ) 
                    ),
                    child: Text(message.message, style: const TextStyle(fontSize: 18),)),
                )
                : OtherUserMessageBubble(baseMessage: message));
      },
    );
  }
}

class OtherUserMessageBubble extends StatelessWidget {
  const OtherUserMessageBubble({super.key, required this.baseMessage});
  final BaseMessage baseMessage;

  

  @override
  Widget build(BuildContext context) {
    final message = baseMessage.message;
    String userName = baseMessage.sender == null ? "Unkown" : baseMessage.sender?.nickname ?? baseMessage.sender?.friendName ?? 'Unkown';
    String date = timeago.format(DateTime.fromMillisecondsSinceEpoch(baseMessage.createdAt));
    return ListTile(
      title: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ClipOval(
            
            child:  Widgets.imageNetwork(baseMessage.sender!.profileUrl, 32, Icons.account_circle)),
            Flexible(child: Container(
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft:  Radius.circular(4), bottomLeft:  Radius.circular(8), bottomRight:  Radius.circular(12)),
                color: Colors.grey.shade900),
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  Text(message, style: const TextStyle(fontSize: 18),)
                ],
              ),
            )),
            Container(
          alignment: Alignment.bottomRight,
          child: Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade400),),
        )
        ]),
      ),
     
    );
  }
} 