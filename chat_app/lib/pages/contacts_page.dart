import 'package:flutter/material.dart';

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
        appBar: AppBar(title: Text('Contacts', style: GoogleFonts.oswald().copyWith(color: Colors.blue),)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            reverse: false,
            itemCount: widget.userList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('a'),
                      ),
                      title: Text(widget.userList[index].displayName),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
