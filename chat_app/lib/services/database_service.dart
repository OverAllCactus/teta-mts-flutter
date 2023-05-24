import 'package:chat_app/models/Message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {

  Future getData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('message').get();
    if(snapshot.exists){
      print(snapshot.value);

    }else{
      print('No data');
    }
  }

  Future sendMessage(text) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
  final userService = UserService();
  String? userFromService = await userService.getUser();
    final message = Message(
      userId: userFromService ?? '567567', 
      text: text, 
      timestamp: DateTime.now().microsecondsSinceEpoch.toString());

      final messageRef = ref.push();
      await messageRef.set(message.toJson());
  }
}