import 'package:flutter/material.dart';

import '../services/database_service.dart';

class MessageFormView extends StatefulWidget {
  const MessageFormView({super.key, required this.databaseService});

  final DatabaseService databaseService;
  @override
  State<MessageFormView> createState() =>
      _MessageFormState(databaseService: databaseService);
}

class _MessageFormState extends State<MessageFormView> {
  _MessageFormState({required this.databaseService});

  final TextEditingController _controller = TextEditingController();
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: [
            Expanded(
              child: BottomAppBar(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                databaseService.sendMessage(_controller.text);
                _controller.text = '';
              },
              icon: Icon(Icons.send),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
