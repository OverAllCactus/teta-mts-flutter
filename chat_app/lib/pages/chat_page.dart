import 'package:chat_app/main.dart';
import 'package:chat_app/view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../services/database_service.dart';
import '../view/messageForm_view.dart';
import '../view/shimmer_view.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
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
          title: const Text('Chat Name'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: isLoading
                          ? const ShimmerView()
                          : StreamBuilder(
                              stream: ref.watch(messagesProvider),
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
                                  return const ShimmerView();
                                }
                              },
                            ))),
            ])),
        floatingActionButton: FloatingActionButton(
          child: const Text('Start'),
          onPressed: () => onChangeAnimation(),
        ),
        bottomNavigationBar: const MessageFormView());
  }
}
