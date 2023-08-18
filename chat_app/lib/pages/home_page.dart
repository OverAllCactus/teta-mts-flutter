import 'dart:async';

import 'package:chat_app/main.dart';
import 'package:chat_app/pages/map_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/user/user.dart';
import 'chat_page.dart';
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
  int currentPageIndex = 1;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp");
      Navigator.of(context).push(_createRoute());
    });
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final id = firebaseUser.uid;
      final displayName = firebaseUser.phoneNumber ?? 'default name';
      final photoUrl = firebaseUser.photoURL ?? '';
      Future(() {
        ref.read(userProvider.notifier).update((state) =>
            User(id: id, displayName: displayName, photoUrl: photoUrl));
      });
    } else {
      Future(() {
        ref.read(userProvider.notifier).update((state) => const User(
            id: 'mock_id',
            displayName: 'mock_displayName',
            photoUrl: 'mock_photoUrl'));
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
        const MapPage()
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
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
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
