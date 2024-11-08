// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnAwMzAoU3CnHpwceBDhykooDHt_vUHac',
    appId: '1:576333136806:web:f06c0936736f7c037c4567',
    messagingSenderId: '576333136806',
    projectId: 'chat-app-16547',
    authDomain: 'chat-app-16547.firebaseapp.com',
    databaseURL: 'https://chat-app-16547-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'chat-app-16547.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2V_5lehzJtQKVFzLiqfvXm8cJqsPCf38',
    appId: '1:576333136806:android:a2fdfc8ec08063137c4567',
    messagingSenderId: '576333136806',
    projectId: 'chat-app-16547',
    databaseURL: 'https://chat-app-16547-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'chat-app-16547.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANbY5K__H6Fx4SH6h2vaos2Cvi2Qzj_JE',
    appId: '1:576333136806:ios:846c320a70ccd4a77c4567',
    messagingSenderId: '576333136806',
    projectId: 'chat-app-16547',
    databaseURL: 'https://chat-app-16547-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'chat-app-16547.appspot.com',
    iosClientId: '576333136806-4lb7gm2rqcojr4cprt36qj3smn40hs3c.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
