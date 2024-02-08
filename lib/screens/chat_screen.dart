import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:send_bird_chat_example/provider/channel_message_provider.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/message_sender.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/other_user_message_card.dart';
import 'package:send_bird_chat_example/widgets/chat-feature-widgets/user_message_card.dart';
import 'package:send_bird_chat_example/widgets/page_state_checker.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final itemScrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setupChannel();
    });
  }

  void _addMessage(BaseMessage message) {
    final provider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);
    provider.addMessage(message);

    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scroll(),
    );
  }

  void _scroll() async {
    final provider =
        Provider.of<SendBirdChannelProvider>(context, listen: false);

    final messageList = provider.messageList;
    if (messageList.length <= 1) return;

    while (!itemScrollController.isAttached) {
      await Future.delayed(const Duration(milliseconds: 1));
    }

    itemScrollController.scrollTo(
      index: messageList.length - 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
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
            title: Text(
              sendBirdChatProvider.openChannel.name,
              style: TextStyle(color: Colors.grey.shade500),
            ),
            leading: IconButton(
                color: Colors.grey.shade600,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            actions: [
              IconButton(
                  color: Colors.grey.shade600,
                  onPressed: () {
                    // TODO: open options
                  },
                  icon: const Icon(Icons.menu))
            ],
          ),
          body: SafeArea(
            child: PageStateChecker(
                isLoading: sendBirdChatProvider.isLoading,
                hasError: sendBirdChatProvider.isLoading,
                onTryAgain: setupChannel,
                content: Column(
                  children: [
                    sendBirdChatProvider.hasPrevious
                        ? _previousButton(sendBirdChatProvider)
                        : Container(),
                    Expanded(
                        child: sendBirdChatProvider.messageList.isNotEmpty
                            ? ScrollablePositionedList.builder(
                                padding: const EdgeInsets.all(8),
                                physics: const ClampingScrollPhysics(),
                                initialScrollIndex:
                                    sendBirdChatProvider.messageList.length - 1,
                                itemScrollController: itemScrollController,
                                itemCount:
                                    sendBirdChatProvider.messageList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index >=
                                      sendBirdChatProvider.messageList.length) {
                                    return Container();
                                  }

                                  BaseMessage message =
                                      sendBirdChatProvider.messageList[index];

                                  bool isUserMessage = message.sender != null &&
                                      message.sender!.userId ==
                                          sendBirdChatProvider.user.userId;
                                  return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: isUserMessage
                                          ? UserMessageCard(
                                              baseMessage: message)
                                          : OtherUserMessageCard(
                                              baseMessage: message));
                                },
                              )
                            : Container()),
                    MessageSender(onAdd: _addMessage)
                  ],
                )),
          ));
    });
  }

  Widget _previousButton(SendBirdChannelProvider sendBirdChatProvider) {
    return Container(
      width: 32,
      height: 32.0,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),

      ),
      child: IconButton(
        icon: const Icon(Icons.expand_less, size: 16.0),
        color: Colors.white,
        onPressed: () async {
          if (sendBirdChatProvider.query.hasNext &&
              !sendBirdChatProvider.query.isLoading) {
            final messages = await sendBirdChatProvider.query.next();
            sendBirdChatProvider.insertMessages(messages);
            itemScrollController.scrollTo(
              index: 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
            );
          }
        },
      ),
    );
  }
}
