import 'package:chat_app/view/message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../services/database_service.dart';
import '../view/messageForm_view.dart';
import '../view/shimmer_view.dart';
import 'chat-details_page.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(
      {super.key,
      required this.chatId,
      required this.userId,
      required this.title});

  final String chatId;
  final String userId;
  final String title;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Route _detailsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatDetailsPage(userId: widget.userId, chatId: widget.chatId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _openDetails() {
    Navigator.of(context).push(_detailsRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            TextButton(onPressed: _openDetails, child: const Text('Details'))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: StreamBuilder(
                        stream: getIt<DatabaseService>()
                            .getMessagesByChatId(widget.chatId),
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
        bottomNavigationBar: MessageFormView(chatId: widget.chatId));
  }
}
