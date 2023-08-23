import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/database_service.dart';

class ChatDetailsPage extends ConsumerStatefulWidget {
  const ChatDetailsPage({super.key, required this.userId, required this.chatId});

final String userId;
final String chatId;

  @override
  ConsumerState<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends ConsumerState<ChatDetailsPage> {
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
            'Chat details',
            style: GoogleFonts.oswald().copyWith(color: Colors.blue),
          ),
        ),
        body: StreamBuilder(
        stream: getIt<DatabaseService>().getUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: (snapshot.data!.photoUrl.isNotEmpty)
                        ? Image.network(snapshot.data!.photoUrl).image
                        : Image.asset('assets/avatar.png').image,
                    backgroundColor: Colors.transparent,
                    radius: 32,
                  ),
                  Text(
                    snapshot.data!.displayName,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            );
          } else {
            return const Text('Data is not available!');
          }
        },
      ));
  }
}
