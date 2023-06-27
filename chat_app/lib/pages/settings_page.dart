import 'package:chat_app/pages/credits_page.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: getIt<DatabaseService>().pickImage,
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreditsPage()));
                },
                child: const Text(
                  'Powered on Flutter',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ));
  }
}
