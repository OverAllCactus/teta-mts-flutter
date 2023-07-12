import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/database_service.dart';

class MessageFormView extends StatefulWidget {
  const MessageFormView({super.key});

  @override
  State<MessageFormView> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageFormView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;
  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 300),
        lowerBound: 22,
        upperBound: 24,
        vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
            AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) {
                  return IconButton(
                    onPressed: () {
                      getIt<DatabaseService>().sendMessage(_controller.text);
                      _controller.text = '';
                      _animationController.forward();
                    },
                    icon: Icon(
                      Icons.send,
                      size: _animationController.value,
                    ),
                  );
                })
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _animationController.dispose();
  }
}
