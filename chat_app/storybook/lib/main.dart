import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/view/messagesList_view.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const MyApp());

final _plugins = initializePlugins(
  contentsSidePanel: true,
  knobsSidePanel: true,
  initialDeviceFrameData: DeviceFrameData(
    device: Devices.ios.iPhone13,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Screens/Scaffold',
        plugins: _plugins,
        stories: [
          Story(
            name: 'List of chats',
            builder: (context) { 
              final userId = context.knobs.text(label: 'Id', initial: 'Добро пожаловать!');
              final text = context.knobs.text(label: 'Text', initial: 'Начните с Вашего первого сообщения...');
              final timestamp = context.knobs.text(label: 'Time', initial: '0');

              return Center(child: MessagesListView(messageList: [
                  Message(
                      userId: userId,
                      text: text,
                      timestamp: int.parse(timestamp))]));
            }
          ),
        ],
      );
}