import 'package:flutter/material.dart';

import '../models/user/user.dart';
import '../services/database_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.userList});

  final List<User> userList;

  @override
  State<ContactsPage> createState() => _ContactsPageState(userList: userList);
}

class _ContactsPageState extends State<ContactsPage> {
  _ContactsPageState({required this.userList});

  final List<User> userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            reverse: false,
            itemCount: userList.length,
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
                      title: Text(userList[index].displayName),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
