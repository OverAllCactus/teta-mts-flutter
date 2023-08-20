import 'package:chat_app/main.dart';
import 'package:chat_app/view/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user/user.dart';
import '../services/database_service.dart';

class ContactsListPage extends ConsumerStatefulWidget {
  const ContactsListPage({super.key});

  @override
  ConsumerState<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends ConsumerState<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.watch(contactsProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return const ContactView(
                user: User(id: 'test', displayName: 'test name', photoUrl: ''));
          } else {
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
                      return ListView.builder(
                        reverse: false,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ContactView(user: snapshot.data![index]);
                        },
                      );
                    }),
                  ),
                ));
          }
        } else {
          return const Text('Data is not available!');
        }
      },
    );
  }
}
