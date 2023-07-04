import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                message.userId,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(StringToHex.toColor(message.userId))),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                    fontSize: 13.0),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            message.text,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
