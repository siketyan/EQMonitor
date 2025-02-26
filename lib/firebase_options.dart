// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
        return macos;
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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8GRAlx3f8P6Xpy3g2drzrzvqM7SjH26U',
    appId: '1:179553945248:web:50b6c84239bb1f786fabc5',
    messagingSenderId: '179553945248',
    projectId: 'eqmonitor-main',
    authDomain: 'eqmonitor-main.firebaseapp.com',
    storageBucket: 'eqmonitor-main.appspot.com',
    measurementId: 'G-GHEHD2C9H0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkDpYc8eF_zrLEWPufW0O2A1TvA-gBMa0',
    appId: '1:179553945248:android:11ffcfb483c098ad6fabc5',
    messagingSenderId: '179553945248',
    projectId: 'eqmonitor-main',
    storageBucket: 'eqmonitor-main.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARNQCNBeDoGYCzW8iQK_puUgx8IEu33tc',
    appId: '1:179553945248:ios:a738f33a18702c7f6fabc5',
    messagingSenderId: '179553945248',
    projectId: 'eqmonitor-main',
    storageBucket: 'eqmonitor-main.appspot.com',
    androidClientId:
        '179553945248-gnhkjhr4feqsv308rf3dlcber84o647i.apps.googleusercontent.com',
    iosClientId:
        '179553945248-hog16qgussjvd0ddqqe973c32n64atm1.apps.googleusercontent.com',
    iosBundleId: 'net.yumnumm.eqmonitor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARNQCNBeDoGYCzW8iQK_puUgx8IEu33tc',
    appId: '1:179553945248:ios:a738f33a18702c7f6fabc5',
    messagingSenderId: '179553945248',
    projectId: 'eqmonitor-main',
    storageBucket: 'eqmonitor-main.appspot.com',
    androidClientId:
        '179553945248-gnhkjhr4feqsv308rf3dlcber84o647i.apps.googleusercontent.com',
    iosClientId:
        '179553945248-hog16qgussjvd0ddqqe973c32n64atm1.apps.googleusercontent.com',
    iosBundleId: 'net.yumnumm.eqmonitor',
  );
}
