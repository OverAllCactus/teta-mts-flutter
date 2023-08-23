import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../main.dart';
import '../models/message/message.dart';

class MessageView extends ConsumerStatefulWidget {
  const MessageView({super.key, required this.message});

  final Message message;

  @override
  ConsumerState<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends ConsumerState<MessageView> {
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: (ref.read(profileProvider).id == widget.message.userId) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.message.text,
            style: const TextStyle(fontSize: 16.0),
          ),
          Text(
            timeago.format(
                DateTime.fromMillisecondsSinceEpoch(widget.message.timestamp)),
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black38,
                fontSize: 13.0),
          ),
        ],
      ),
    );
  }
}
