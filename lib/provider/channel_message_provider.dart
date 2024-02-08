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

  Future<void> insertMessages(List<BaseMessage> messages) async {
    try {
     
       messageList.insertAll(0, messages);
       
              hasPrevious = query.hasNext;
              notifyListeners();
    } catch (e) { 
      print("Error adding previous messages $e");
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
