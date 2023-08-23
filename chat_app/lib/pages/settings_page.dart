import 'package:chat_app/main.dart';
import 'package:chat_app/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../services/database_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isEdit = false;
  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _edit() {
    setState(() {
      _controller.text = ref.read(profileProvider).displayName;
      _isEdit = true;
    });
  }

  void _done() {
    if (_controller.text.isNotEmpty) {
      User updatedUser = User(
          id: ref.read(profileProvider).id,
          displayName: _controller.text,
          photoUrl: ref.read(profileProvider).photoUrl);
      ref.read(profileProvider.notifier).update((state) => updatedUser);
    }
    setState(() {
      _isEdit = false;
    });
  }

  void _changeAvatar() async {
    String newAvatarUrl = await getIt<DatabaseService>().changeAvatar();
    if (newAvatarUrl.isNotEmpty) {
      User updatedUser = User(
          id: ref.read(profileProvider).id,
          displayName: ref.read(profileProvider).displayName,
          photoUrl: newAvatarUrl);
      ref.read(profileProvider.notifier).update((state) => updatedUser);
    }
  }

  void _copyProfile() {
    Clipboard.setData(ClipboardData(text: ref.read(profileProvider).id));
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
            TextButton(onPressed: _copyProfile, child: const Text('Share'))
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _changeAvatar,
                child: CircleAvatar(
                  backgroundImage: (ref
                          .read(profileProvider)
                          .photoUrl
                          .isNotEmpty)
                      ? Image.network(ref.read(profileProvider).photoUrl).image
                      : Image.asset('assets/avatar.png').image,
                  backgroundColor: Colors.transparent,
                  radius: 32,
                ),
              ),
              _isEdit
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 16.0),
                        decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0)),
                      ),
                    )
                  : Text(
                      ref.watch(profileProvider).displayName,
                      style: const TextStyle(fontSize: 24),
                    ),
              _isEdit
                  ? TextButton(onPressed: _done, child: const Text('Done'))
                  : TextButton(onPressed: _edit, child: const Text('Edit')),
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
