import 'package:chat_app/main.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user/user.dart';
import '../services/database_service.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute());
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Text('a'),
              ),
              title: Text(user.displayName),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ChatPage(),
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
