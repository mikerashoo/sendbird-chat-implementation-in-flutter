import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:send_bird_chat_example/constants/send_bird_configurations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class SendBirdChannelProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  late OpenChannel openChannel;
  late User user;
  List<BaseMessage> messageList = [];
  late PreviousMessageListQuery query;
  bool hasPrevious = false;
  int scrollIndex = 0;

  Future<void> initialize(User _user, OpenChannel _openChannel) async {
    try {
      user = _user;
      openChannel = _openChannel;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  void populateMessages() {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();
      openChannel.enter().then((_) => {
            OpenChannel.getChannel(SEND_BIRD_CHANNEL_URL).then((openChannel) {
              query = PreviousMessageListQuery(
                channelType: ChannelType.open,
                channelUrl: SEND_BIRD_CHANNEL_URL,
              )..next().then((messages) {
                  messageList
                    ..clear()
                    ..addAll(messages);
                  if (scrollIndex == 0 && messageList.isNotEmpty) {
                    scrollIndex = messageList.length - 1;
                  }
                  hasPrevious = query.hasNext;
                  isLoading = false;
                  hasError = false;
                  notifyListeners();
                });
            })
          });
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
      if (kDebugMode) {
        print("Error fetching message: $e");
      }
    }
  }

  Future<bool> sendMessage(String messageToSend) async {
    try {
      bool result = false;
      openChannel.sendUserMessageWithText(
        messageToSend,
        handler: (message, e) {
          if (e == null) {
            print("Message sent: $message");
            messageList.add(message);
            notifyListeners();
            result = true;
          } else {
            // TODO: handle error
            print("Errror sending message: $e");
            result = false;
          }
        },
      );
      return result;
      // Use message to display the message before it is sent to the server.
    } catch (e) {
      print("error $e");
      return false;
    }
  }

  void addMessage(BaseMessage message) {
    try {
      messageList.add(message);
      int _newIndex = messageList.length - 1;
      scrollIndex = _newIndex;
      notifyListeners();
    } catch (e) {
      print("Error adding message: $e");
    }
  }
}
