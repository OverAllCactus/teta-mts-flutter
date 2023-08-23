import 'package:chat_app/view/shimmer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/user/user.dart';
import '../pages/profile_page.dart';
import '../services/database_service.dart';

class ContactView extends ConsumerStatefulWidget {
  const ContactView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends ConsumerState<ContactView> {
  final getIt = GetIt.instance;
  User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute());
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: StreamBuilder(
          stream: getIt<DatabaseService>().getUserById(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (snapshot.data!.photoUrl.isNotEmpty)
                          ? Image.network(snapshot.data!.photoUrl).image
                          : Image.asset('assets/avatar.png').image,
                      backgroundColor: Colors.transparent,
                      radius: 32,
                    ),
                    title: Text(snapshot.data!.displayName),
                  ),
                ],
              );
            } else {
              return const ShimmerView();
            }
          },
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProfilePage(userId: widget.userId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
