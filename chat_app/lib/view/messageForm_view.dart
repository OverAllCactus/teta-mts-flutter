import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/database_service.dart';

class MessageFormView extends StatefulWidget {
  const MessageFormView({super.key});

  @override
  State<MessageFormView> createState() =>
      _MessageFormState();
}

class _MessageFormState extends State<MessageFormView> {

  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;

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
                getIt<DatabaseService>().sendMessage(_controller.text);
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
