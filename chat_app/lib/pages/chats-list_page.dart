import 'package:chat_app/main.dart';
import 'package:chat_app/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/database_service.dart';
import '../view/chat_view.dart';

class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      return StreamBuilder(
        stream: getIt<DatabaseService>().chatsmock,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return ChatView(
                  user:
                      User(id: 'test', displayName: 'test name', photoUrl: ''));
            } else {
              return Scaffold(
                  appBar: AppBar(
                      title: Text(
                    'Chats',
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
                            return ChatView(user: snapshot.data![index]);
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
    }));
  }
}
