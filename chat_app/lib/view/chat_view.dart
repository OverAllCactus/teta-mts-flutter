import 'package:chat_app/main.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user/user.dart';
import '../services/database_service.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const ChatPage()));
        },
        child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                leading: CircleAvatar(
                  child: Text('a'),
                ),
                title: Text('user'),
                subtitle: Text('message'),
                trailing: Text('time'),
              ),
          ],
        ),
      ));
  }
}
