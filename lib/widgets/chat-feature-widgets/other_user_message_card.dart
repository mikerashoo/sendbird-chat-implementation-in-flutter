

import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'common_widgets.dart';

class OtherUserMessageCard extends StatelessWidget {
  const OtherUserMessageCard({super.key, required this.baseMessage});
  final BaseMessage baseMessage;

  @override
  Widget build(BuildContext context) {
    final message = baseMessage.message;
    String userName = baseMessage.sender == null
        ? "Unkown"
        : baseMessage.sender?.nickname ??
            baseMessage.sender?.friendName ??
            'Unkown';
    String date = timeago
        .format(DateTime.fromMillisecondsSinceEpoch(baseMessage.createdAt));
    return ListTile(
      title: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipOval(
              child: Widgets.imageNetwork(
                  baseMessage.sender!.profileUrl, 32, Icons.account_circle)),
          Flexible(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(12)),
                color: Colors.grey.shade900),
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
          )),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          )
        ]),
      ),
    );
  }
}
