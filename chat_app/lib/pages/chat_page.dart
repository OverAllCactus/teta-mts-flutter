import 'package:chat_app/view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';
import '../services/database_service.dart';
import '../view/messageForm_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat Name'),
        ),
        body: StreamBuilder(
          stream: getIt<DatabaseService>().messages,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return MessageView(
                    message: Message(
                        userId: 'Добро пожаловать!',
                        text: 'Начните с Вашего первого сообщения...',
                        timestamp: DateTime.now().millisecondsSinceEpoch));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MessageView(message: snapshot.data![index]);
                    },
                  ),
                );
              }
            } else {
              return const Text('Data is not available!');
            }
          },
        ),
        bottomNavigationBar: MessageFormView());
  }
}
