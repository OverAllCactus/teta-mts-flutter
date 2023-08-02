import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isEdit = false;
  bool _isAvatar = false;
  String _avatarURL = '';
  Image image = Image.asset('avatar.png');
  final getIt = GetIt.instance;

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: GoogleFonts.oswald().copyWith(color: Colors.blue),
          ),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
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
                  : Text(
                      ref.watch(userProvider).displayName,
                      style: TextStyle(fontSize: 24),
                    ),
              GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ));
  }
}
