import 'package:chat_app/view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key, required this.messageList});

  final List<Message> messageList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        reverse: true,
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          return MessageView(message: messageList[index]);
        },
      ),
    );
  }
}
