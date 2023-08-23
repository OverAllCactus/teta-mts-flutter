import 'dart:io';

import 'package:chat_app/models/message/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/chat/chat.dart';
import '../models/user/user.dart';

class DatabaseService {
  final Reference _imageRef = FirebaseStorage.instance.ref().child("images");

  Future<void> testData() async {
    try {
      final checkRef = FirebaseDatabase.instance.ref();
      final snapshot = await checkRef.child('message').get();
      if (snapshot.exists) {
        // if(true){
        print('test value:');
        print(snapshot.value);
      } else {
        print('No data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(String profileId, String chatId, String text) async {
    if (text != '') {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("messages/" + chatId);
      final message = Message(
          userId: profileId,
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch);

      final messageRef = ref.push();
      await messageRef.set(message.toJson());
    }
  }

  Future<String> changeAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    var imageFile = File(image!.path);
    final imageRef = _imageRef.child(image.name);
    try {
      await imageRef.putFile(imageFile);
      final avatarURL = await imageRef.getDownloadURL();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarURL', avatarURL);
      return (avatarURL);
    } catch (e) {
      return ('');
    }
  }

  Future<void> addContact(String id, String contactId) async {
    if (id.isNotEmpty && contactId.isNotEmpty) {
      DatabaseReference contactRef =
          FirebaseDatabase.instance.ref("user_contacts/" + id);
      final ref = contactRef.push();
      await ref.set(contactId);
    }
  }

  Stream<List<String>> getContacts(String profileId) {
    final DatabaseReference contactsRef =
        FirebaseDatabase.instance.ref("user_contacts/" + profileId);
    return contactsRef.onValue.map((e) {
      List<String> contactList = <String>[];
      final firebaseContacts =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseContacts.forEach((key, value) {
        contactList.add(value.toString());
      });
      return contactList;
    });
  }

  Stream<User> getUserById(String id) {
    final Query userRef =
        FirebaseDatabase.instance.ref('users').orderByChild("id").equalTo(id);
    User user = User(id: '', displayName: 'no data', photoUrl: '');
    return userRef.onValue.map((e) {
      final firebaseUsers =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseUsers.forEach((key, value) {
        User currentUser = User.fromJson(Map<String, dynamic>.from(value));
        user = currentUser;
      });
      return user;
    });
  }

  Future<void> createChat(String profileId, String title) async {
    if (profileId.isNotEmpty) {
      const uuid = Uuid();
      String chatId = uuid.v4();
      DatabaseReference chatRef =
          FirebaseDatabase.instance.ref("chats/" + chatId);
      final cref = chatRef.push();
      await cref
          .set((Chat(title: title, lastMessage: "", timestamp: DateTime.now().millisecondsSinceEpoch)).toJson());

      DatabaseReference userChatsRef =
          FirebaseDatabase.instance.ref("user_chats/" + profileId);
      final ref = userChatsRef.push();
      await ref.set(chatId);
    }
  }

  Stream<List<String>> getChats(String profileId) {
    final DatabaseReference userChatsRef =
        FirebaseDatabase.instance.ref("user_chats/" + profileId);
    return userChatsRef.onValue.map((e) {
      List<String> chatList = <String>[];
      final firebaseChats =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseChats.forEach((key, value) {
        chatList.add(value.toString());
      });
      return chatList;
    });
  }

  Stream<Chat> getChatById(String id) {
    final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref('chats/' + id);
    Chat chat = Chat(title: 'no data', lastMessage: '', timestamp: 0);
    return chatRef.onValue.map((e) {
      final firebaseChats =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseChats.forEach((key, value) {
        Chat currentChat = Chat.fromJson(Map<String, dynamic>.from(value));
        chat = currentChat;
      });
      return chat;
    });
  }

  Stream<List<Message>> getMessagesByChatId(String id) {
    final DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref('messages/' + id);
    return messagesRef.onValue.map((e) {
      List<Message> messageList = [];
      final firebaseMessages =
          Map<dynamic, dynamic>.from(e.snapshot.value as Map<dynamic, dynamic>);
      firebaseMessages.forEach((key, value) {
        final currentUser = Map<String, dynamic>.from(value);
        messageList.add(Message.fromJson(currentUser));
      });
      messageList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return messageList;
    });
  }
}