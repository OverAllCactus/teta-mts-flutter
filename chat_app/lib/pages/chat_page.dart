import 'package:chat_app/view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';
import '../services/database_service.dart';
import '../view/messageForm_view.dart';
import '../view/shimmer_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  final getIt = GetIt.instance;

  void onChangeAnimation() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat Name'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: isLoading
                          ? ShimmerView()
                          : StreamBuilder(
                              stream: getIt<DatabaseService>().messages,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListView.builder(
                                      reverse: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return MessageView(
                                            message: snapshot.data![index]);
                                      },
                                    ),
                                  );
                                } else {
                                  return ShimmerView();
                                }
                              },
                            ))),
            ])),
        floatingActionButton: FloatingActionButton(
          child: Text('Start'),
          onPressed: () => onChangeAnimation(),
        ),
        bottomNavigationBar: MessageFormView());
  }
}
