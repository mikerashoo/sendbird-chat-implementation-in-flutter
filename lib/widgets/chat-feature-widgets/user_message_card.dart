import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class UserMessageCard extends StatelessWidget {
  const UserMessageCard({super.key, required this.baseMessage});
  final BaseMessage baseMessage;


  @override
  Widget build(BuildContext context) {
    return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.9),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            )),
                        child: Text(
                          baseMessage.message,
                          style: const TextStyle(fontSize: 18),
                        )),
                  );
  }
}