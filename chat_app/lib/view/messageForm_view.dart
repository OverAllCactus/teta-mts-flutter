import 'package:flutter/material.dart';

import '../services/database_service.dart';

class MessageFormView extends StatelessWidget {

  const MessageFormView({
    super.key,
    required this.controller// = TextEditingController()
  });

final TextEditingController controller;// = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Expanded(
                child: BottomAppBar(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0)),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  DatabaseService().sendMessage(controller.text);
                  controller.text = '';
                },
                icon: Icon(Icons.send),
              )
            ],
          );
  }
}