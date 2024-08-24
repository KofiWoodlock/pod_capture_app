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
        return windows;
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
 // Make sure to hide apiKey and appID
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6SLNUD1WjjZHUx4tYhfrtidtuBYBJawI',
    appId: '1:449894180065:web:d3d0c951cf34580ef0c3a0',
    messagingSenderId: '449894180065',
    projectId: 'testproject-kfw01',
    authDomain: 'testproject-kfw01.firebaseapp.com',
    storageBucket: 'testproject-kfw01.appspot.com',
    measurementId: 'G-QSE3X8RQRE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDl1eDSn4T-zEH0uC822BxUUk_5tkVDE8s', 
    appId: '1:449894180065:android:9136c2b28ab05593f0c3a0',
    messagingSenderId: '449894180065',
    projectId: 'testproject-kfw01',
    storageBucket: 'testproject-kfw01.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXrATETt4fAJltS9eONagm3AYXA4I5w8A',
    appId: '1:449894180065:ios:51b349005cbcc0ecf0c3a0',
    messagingSenderId: '449894180065',
    projectId: 'testproject-kfw01',
    storageBucket: 'testproject-kfw01.appspot.com',
    iosBundleId: 'com.testapp.testapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXrATETt4fAJltS9eONagm3AYXA4I5w8A',
    appId: '1:449894180065:ios:51b349005cbcc0ecf0c3a0',
    messagingSenderId: '449894180065',
    projectId: 'testproject-kfw01',
    storageBucket: 'testproject-kfw01.appspot.com',
    iosBundleId: 'com.testapp.testapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6SLNUD1WjjZHUx4tYhfrtidtuBYBJawI',
    appId: '1:449894180065:web:8bc5c79f75917c1ef0c3a0',
    messagingSenderId: '449894180065',
    projectId: 'testproject-kfw01',
    authDomain: 'testproject-kfw01.firebaseapp.com',
    storageBucket: 'testproject-kfw01.appspot.com',
    measurementId: 'G-23ST130WYN',
  );
}
