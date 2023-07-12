import 'dart:typed_data';

import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user/user.dart';

class DatabaseService {
  final _dbRef = FirebaseDatabase.instance.ref('messages');
  final _userRef = FirebaseDatabase.instance.ref('users');
  final _chatsmockRef = FirebaseDatabase.instance.ref('chatsmock');
  Future<void> testData() async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('message').get();
      if (snapshot.exists) {
        print('test value:');
        print(snapshot.value);
      } else {
        print('No data');
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Message>> get messages => _dbRef.onValue.map((e) {
        List<Message> messageList = [];
        var child = e.snapshot.children;
        child.forEach((element) {
          var map = element.value as Map<String, dynamic>;
          Message message = Message.fromJson(map);
          messageList.add(message);
        });
        return messageList;
      });

  Future<void> sendMessage(text) async {
    if (text != '') {
      DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
      final userService = UserService();
      String? userFromService = await userService.getUser();
      final message = Message(
          userId: userFromService ?? '567567',
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch);

      final messageRef = ref.push();
      await messageRef.set(message.toJson());
    }
  }

  Stream<List<User>> get users => _userRef.onValue.map((e) {
        List<User> userList = [];
        var child = e.snapshot.children;
        child.forEach((element) {
          var map = element.value as Map<String, dynamic>;
          User user = User.fromJson(map);
          userList.add(user);
        });
        print(userList.length);
        return userList;
      });

  Stream<List<User>> get chatsmock => _chatsmockRef.onValue.map((e) {
        List<User> userList = [];
        var child = e.snapshot.children;
        child.forEach((element) {
          var map = element.value as Map<String, dynamic>;
          User user = User.fromJson(map);
          userList.add(user);
        });
        print(userList.length);
        return userList;
      });

  Future<void> createUser() async {
    const uuid = Uuid();
    String userId = uuid.v4();

    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    final String displayName = 'Default Name';
    final user =
        User(id: userId ?? '567567', displayName: displayName, photoUrl: '');

    final userRef = ref.push();
    await userRef.set(user.toJson());
  }

  Future<void> pickImage() async {
    final ImagePickerWeb picker = ImagePickerWeb();
    final Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child("images").child('image.png');
      await ref.putData(image);
      final downloadURL = await ref.getDownloadURL();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarURL', downloadURL);
      print(downloadURL);
      Image imageb = Image.network(downloadURL);
      print(imageb.hashCode);
    } else {
      print("no image!");
    }
  }
}
