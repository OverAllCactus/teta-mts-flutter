import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../services/database_service.dart';
import '../view/chat_view.dart';
import '../view/shimmer_view.dart';

class ChatsListPage extends ConsumerStatefulWidget {
  const ChatsListPage({super.key});

  @override
  ConsumerState<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends ConsumerState<ChatsListPage> {
  final getIt = GetIt.instance;

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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: GoogleFonts.oswald().copyWith(color: Colors.blue),
          ),
        ),
        body: StreamBuilder(
          stream:
              getIt<DatabaseService>().getChats(ref.read(profileProvider).id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Text('Chats list is empty!');
              } else {
                return Consumer(
                  builder: ((context, ref, child) {
                    return ListView.builder(
                      reverse: false,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ChatView(chatId: snapshot.data![index]);
                      },
                    );
                  }),
                );
              }
            } else {
              return const ShimmerView();
            }
          },
        ));
  }
}
