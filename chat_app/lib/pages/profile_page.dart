import 'package:chat_app/pages/chats-list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../services/database_service.dart';
import 'chat_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

@override
  void dispose() {
    super.dispose();
  }

  void _openChat(String title) {
    getIt<DatabaseService>().createChat(ref.read(profileProvider).id, title);
    Navigator.of(context).push(_createRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
                  TextButton(
                      onPressed: () => _openChat(widget.userId), child: const Text('Create chat')),
                ],
              ),
            );
          } else {
            return const Text('Data is not available!');
          }
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatsListPage(),
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
