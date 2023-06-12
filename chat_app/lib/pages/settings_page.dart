import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;
  bool _isAvatar = false;
  String _avatarURL = '';
  Image image = Image.asset('avatar.png');

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  _loadAvatar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? avatarURL = prefs.getString('avatarURL');
    if (avatarURL != null) {
      setState(() {
        _isAvatar = true;
        _avatarURL = avatarURL;
      });
    }
  }

  void _edit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _done() {
    setState(() {
      _isEdit = false;
    });
  }

  void pickImage() async {
    final ImagePickerWeb picker = ImagePickerWeb();

    final Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {

      Reference ref = FirebaseStorage.instance.ref().child("images").child('image.png');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            _isEdit
                ? TextButton(onPressed: _done, child: Text('Done'))
                : TextButton(onPressed: _edit, child: Text('Edit'))
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('avatar.png'),
                  backgroundColor: Colors.transparent,
                  radius: 32,
                ),
              ),
              _isEdit
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: TextField(),
                    )
                  : const Text(
                      'data',
                      style: TextStyle(fontSize: 24),
                    ),
                    
            ],
          ),
        ));
  }
}
