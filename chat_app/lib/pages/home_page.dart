import 'dart:async';

import 'package:chat_app/main.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/user/user.dart';
import 'chats-list_page.dart';
import 'contacts-list_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final getIt = GetIt.instance;
  int currentPageIndex = 2;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {
      Navigator.of(context).push(_createRoute());
    });
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      Future(() {
        ref.read(profileProvider.notifier).update((state) => User(
            id: firebaseUser.uid,
            displayName: 'User',
            photoUrl:
                'https://firebasestorage.googleapis.com/v0/b/chat-app-16547.appspot.com/o/images%2Fimage.png?alt=media&token=73bc4131-8bae-4e67-97dd-02beea4716e3'));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const ContactsListPage(),
        const ChatsListPage(),
        const SettingsPage(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.people_alt),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ChatsListPage(),
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
