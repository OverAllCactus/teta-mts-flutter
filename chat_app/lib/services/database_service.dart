import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
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

  Future<void> sendMessage(id, text) async {
    if (text != '') {
      DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
      final userService = UserService();
      String? userFromService = await userService.getUser();
      print(userFromService);
      final message = Message(
          userId: id ?? '567567',
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

  Future<bool> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      print('I am connected to a wifi network.');
      return true;
    } else {
      print('no wifi connection');
      return false;
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
}
