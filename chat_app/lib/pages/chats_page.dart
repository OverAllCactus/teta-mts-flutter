import 'package:chat_app/models/user/user.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  State<ChatsPage> createState() => _ChatsPageState(databaseService: databaseService);
}

class _ChatsPageState extends State<ChatsPage> {
  _ChatsPageState({required this.databaseService});

  final DatabaseService databaseService;
List<User> userList = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')), 
      body: ListView(
        children: const <Widget>[          
          ListTile(
            leading: CircleAvatar(child: Text('a'),),
            title: Text('data'),
            subtitle: Text('data'),
            trailing: Text('data'),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(child: Text('a'),),
            title: Text('data'),
            subtitle: Text('data'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          Divider(height: 0),
        ],
      ),
      );
  }
}
