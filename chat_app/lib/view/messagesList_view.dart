import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';

class MessagesListView extends StatelessWidget {

  const MessagesListView({
    super.key,
    required this.messageList
  });

  final List<Message> messageList;

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  reverse: true,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                messageList[index].userId,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(StringToHex.toColor(
                                        messageList[index].userId))),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                timeago.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        messageList[index].timestamp)),
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
                            messageList[index].text,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
  }
}