import 'package:chat_app/models/message/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../models/user/user.dart';

class DatabaseService {
  final _dbRef = FirebaseDatabase.instance.ref('messages');
  final _userRef = FirebaseDatabase.instance.ref('users');

  Future<void> testData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('message').get();
    if (snapshot.exists) {
      print('test value:');
      print(snapshot.value);
    } else {
      print('No data');
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

  Future<void> createUser() async {
    const uuid = Uuid();
    String userId = uuid.v4();

    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    final String displayName = 'Default Name';
    final user =
        User(id: userId ?? '567567', displayName: displayName, photoUrl: '');

    final userRef = ref.push();
    await userRef.set(user.toJson());
    // return userId;
  }
}
