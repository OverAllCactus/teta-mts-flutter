import 'package:chat_app/main.dart';
import 'package:chat_app/view/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/database_service.dart';
import '../view/shimmer_view.dart';

class ContactsListPage extends ConsumerStatefulWidget {
  const ContactsListPage({super.key});

  @override
  ConsumerState<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends ConsumerState<ContactsListPage> {
  bool _searchIsOpened = false;
  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;

  void _openSearch() {
    setState(() {
      _searchIsOpened = true;
    });
  }

  void _addContact() {
    String newUser = _controller.text;
    if (newUser.isNotEmpty) {
      getIt<DatabaseService>().addContact(ref.read(profileProvider).id, newUser);
    }
    _controller.text = '';
    setState(() {
      _searchIsOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _searchIsOpened
              ? TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'User ID',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)),
                )
              : Text(
                  'Contacts',
                  style: GoogleFonts.oswald().copyWith(color: Colors.blue),
                ),
          actions: [
            _searchIsOpened
                ? TextButton(onPressed: _addContact, child: const Text('Add'))
                : TextButton(onPressed: _openSearch, child: const Text('New')),
          ],
        ),
        body: StreamBuilder(
          stream: getIt<DatabaseService>().getContacts(ref.read(profileProvider).id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Text('Contacts list is empty!');
              } else {
                return Consumer(
                  builder: ((context, ref, child) {
                    return ListView.builder(
                      reverse: false,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ContactView(userId: snapshot.data![index]);
                      },
                    );
                  }),
                );
              }
            } else {
              return const ShimmerView();
            }
          },
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
