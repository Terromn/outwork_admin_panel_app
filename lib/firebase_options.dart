// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwx7_Clxus0i_TIVYYLZpWFAbTQcBJ90M',
    appId: '1:296052478452:android:f781ae7163f06a199029a1',
    messagingSenderId: '296052478452',
    projectId: 'outwork-f8f3f',
    databaseURL: 'https://outwork-f8f3f-default-rtdb.firebaseio.com',
    storageBucket: 'outwork-f8f3f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD94aJc93nxzPtS8-pYaWgdy4jZW-BLSNM',
    appId: '1:296052478452:ios:630517b78ce75cf69029a1',
    messagingSenderId: '296052478452',
    projectId: 'outwork-f8f3f',
    databaseURL: 'https://outwork-f8f3f-default-rtdb.firebaseio.com',
    storageBucket: 'outwork-f8f3f.appspot.com',
    iosBundleId: 'com.example.outworkFinalAdminPanelApp',
  );
}
