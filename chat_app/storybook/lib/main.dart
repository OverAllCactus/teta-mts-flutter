import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/models/user/user.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/view/messagesList_view.dart';
import 'package:chat_app/view/message_view.dart';
import 'package:chat_app/view/contact_view.dart';
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
              name: 'List of messages',
              builder: (context) {
                final userId = context.knobs
                    .text(label: 'Id', initial: 'Добро пожаловать!');
                final text = context.knobs.text(
                    label: 'Text',
                    initial: 'Начните с Вашего первого сообщения...');
                final timestamp =
                    context.knobs.text(label: 'Time', initial: '0');

                return Center(
                    child: MessagesListView(messageList: [
                  Message(
                      userId: userId,
                      text: text,
                      timestamp: int.parse(timestamp)),
                  Message(
                      userId: userId,
                      text: text,
                      timestamp: int.parse(timestamp))
                ]));
              }),
          Story(
              name: 'contact',
              builder: (context) {
                final id = context.knobs.text(label: 'Id', initial: 'test id');
                final displayName =
                    context.knobs.text(label: 'Name', initial: 'test name');
                final photoUrl = context.knobs.text(label: 'URL', initial: '');

                return Center(
                    child: ContactView(
                        user: User(
                            id: id,
                            displayName: displayName,
                            photoUrl: photoUrl)));
              }),
          Story(
              name: 'message',
              builder: (context) {
                final userId = context.knobs
                    .text(label: 'Id', initial: 'Добро пожаловать!');
                final text = context.knobs.text(
                    label: 'Text',
                    initial: 'Начните с Вашего первого сообщения...');
                final timestamp =
                    context.knobs.text(label: 'Time', initial: '0');

                return Center(
                    child: MessageView(
                        message: Message(
                            userId: userId,
                            text: text,
                            timestamp: int.parse(timestamp))));
              }),
        ],
      );
}
