import 'package:chat_app/data/repository/user_repository.dart';
import 'package:chat_app/models/user/db_user.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'models/user/user.dart';

final userProvider = StateProvider<User>(
    (ref) => User(id: 'id', displayName: 'displayName', photoUrl: 'photoUrl'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([PhoneAuthProvider()]);

  final getIt = GetIt.instance;
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  getIt<DatabaseService>().testData();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [PhoneAuthProvider()];
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              VerifyPhoneAction((context, _) {
                Navigator.pushReplacementNamed(context, '/phone');
              }),
            ],
          );
        },
        '/home': (context) {
          return const HomePage(title: 'title');
        },
        '/phone': (context) => PhoneInputScreen(
              actions: [
                SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SMSCodeInputScreen(
                            flowKey: flowKey,
                            actions: [
                              AuthStateChangeAction<SignedIn>((context, state) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/home');
                              })
                            ],
                          )));
                }),
              ],
            ),
      },
    );
  }
}
