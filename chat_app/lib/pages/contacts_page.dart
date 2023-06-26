import 'package:chat_app/main.dart';
import 'package:chat_app/view/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user/user.dart';
import '../services/database_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.userList});

  final List<User> userList;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Contacts',
          style: GoogleFonts.oswald().copyWith(color: Colors.blue),
        )),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer(
            builder: ((context, ref, child) {
              final List<User> users = ref.watch(userProvider);
              return ListView.builder(
                reverse: false,
                itemCount: widget.userList.length,
                itemBuilder: (context, index) {
                  return ContactView(user: widget.userList[index]);
                },
              );
            }),
          ),
        ));
  }
}
