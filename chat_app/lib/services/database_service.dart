import 'dart:typed_data';

import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

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
      print(userFromService);
      final message = Message(
          userId: userFromService ?? '567567',
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch);

      final messageRef = ref.push();
      await messageRef.set(message.toJson());
    }
  }

  Future updateUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final id = firebaseUser.uid;
      final displayName = firebaseUser.phoneNumber ?? 'default name';
      final photoUrl = firebaseUser.photoURL ?? '';
      final user = User(id: id, displayName: displayName, photoUrl: photoUrl);
      final userService = UserService();
      await userService.setUser(id);
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
