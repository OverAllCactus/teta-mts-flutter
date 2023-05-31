import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/view/messageForm_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/messagesList_view.dart';
import 'firebase_options.dart';

void main() async {
  final userService = UserService();
  userService.checkUser();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final databaseService = DatabaseService();
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
        primarySwatch: Colors.blue,
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
  final TextEditingController _controller = TextEditingController();
  List<Message> messageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          stream: DatabaseService().messages,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isNotEmpty) {
                messageList = snapshot.data!;
              }
              return MessagesListView(messageList: messageList);
            } else {
              return const Text('No messages');
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: MessageFormView(controller: _controller),
        ));
  }

  @override
  void initState() {
    messageList.add(Message(
      userId: 'Добро пожаловать!', 
      text: 'Начните с Вашего первого сообщения...', 
      timestamp: DateTime.now().millisecondsSinceEpoch));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
