import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/models/user/user.dart';
import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/view/messageForm_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/messagesList_view.dart';
import 'firebase_options.dart';

List<User> userList = [];
List<Message> messageList = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final DatabaseService databaseService = DatabaseService();
  databaseService.createUser();
  databaseService.testData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService databaseService = DatabaseService();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: <Widget>[
          StreamBuilder(
          stream: databaseService.users,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                userList = [
                  User(
                      id: 'test',
                      displayName: 'test name',
                      photoUrl: '')];
              } else {
                userList = snapshot.data!;
              }
              return ContactsPage(userList: userList);
            } else {
              return const Text('Data is not available!');
            }
          },
        ),
          // ChatsPage(),
        StreamBuilder(
          stream: databaseService.messages,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                messageList = [
                  Message(
                      userId: 'Добро пожаловать!',
                      text: 'Начните с Вашего первого сообщения...',
                      timestamp: DateTime.now().millisecondsSinceEpoch)];
              } else {
                messageList = snapshot.data!;
              }
              return MessagesListView(messageList: messageList);
            } else {
              return const Text('Data is not available!');
            }
          },
        ),
          SettingsPage(),
        ] [currentPageIndex],
        // bottomNavigationBar: MessageFormView(databaseService: databaseService));
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
              // selectedIcon: Icon(Icons.settings), 
              icon: Icon(Icons.settings), 
              label: 'Settings',
            ),
          ],
        ),
    );
  }
}
