import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/view/shimmer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/chat/chat.dart';
import '../services/database_service.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key, required this.chatId});

  final String chatId;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final getIt = GetIt.instance;
  Chat? chat;

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
      child: StreamBuilder(
        stream: getIt<DatabaseService>().getChatById(widget.chatId),
        builder: (chatContext, chatSnapshot) {
          if (chatSnapshot.hasData && chatSnapshot.data != null) {
            return StreamBuilder(
              stream: getIt<DatabaseService>()
                  .getUserById(chatSnapshot.data!.title),
              builder: (userContext, userSnapshot) {
                if (userSnapshot.hasData && userSnapshot.data != null) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_createRoute(
                            chatSnapshot.data!.title,
                            userSnapshot.data!.displayName));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: (userSnapshot
                                      .data!.photoUrl.isNotEmpty)
                                  ? Image.network(userSnapshot.data!.photoUrl)
                                      .image
                                  : Image.asset('assets/avatar.png').image,
                              backgroundColor: Colors.transparent,
                              radius: 32,
                            ),
                            title: Text(userSnapshot.data!.displayName),
                            subtitle: Text(timeago.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    chatSnapshot.data!.timestamp))),
                          ),
                        ],
                      ));
                } else {
                  return const ShimmerView();
                }
              },
            );
          } else {
            return const ShimmerView();
          }
        },
      ),
    );
  }

  Route _createRoute(String userId, String title) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatPage(chatId: widget.chatId, userId: userId, title: title),
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
}
