import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../models/user/db_user.dart';
import '../models/user/user.dart';
import 'isar_service.dart';

class DatabaseService {

  final _dbRef = FirebaseDatabase.instance.ref('messages');
  final _userRef = FirebaseDatabase.instance.ref('users');
  final _chatsmockRef = FirebaseDatabase.instance.ref('chatsmock');

  Future<void> testData() async {
    try {
      final _checkRef = FirebaseDatabase.instance.ref();
      final snapshot = await _checkRef.child('message').get();
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
        final firebaseMessages = Map<dynamic, dynamic>.from(
            e.snapshot.value as Map<dynamic, dynamic>);
        firebaseMessages.forEach((key, value) {
          final currentUser = Map<String, dynamic>.from(value);
          messageList.add(Message.fromJson(currentUser));
        });
        messageList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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

  Stream<List<User>> get users {
    return _userRef.onValue.map((e) {
      List<User> userList = <User>[];
      IsarService isarService = IsarService();
      final firebaseUsers =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseUsers.forEach((key, value) {
        User currentUser = User.fromJson(Map<String, dynamic>.from(value));
        userList.add(currentUser);
        DbUser dbUser = DbUser();
        dbUser.userId = currentUser.id;
        dbUser.displayName = currentUser.displayName;
        dbUser.photoUrl = currentUser.photoUrl;
        isarService.saveUser(dbUser);
      });
      return userList;
    });
  }

  Stream<List<User>> get chatsmock => _chatsmockRef.onValue.map((e) {
        List<User> userList = [];
        final firebaseUsers = Map<dynamic, dynamic>.from(
            e.snapshot.value as Map<dynamic, dynamic>);
        firebaseUsers.forEach((key, value) {
          final currentUser = Map<String, dynamic>.from(value);
          userList.add(User.fromJson(currentUser));
        });
        return userList;
      });
}
