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
    apiKey: 'AIzaSyA2UmNoxbjcCjUpsTijUQL8BJSFgCHz5TI',
    appId: '1:65683061758:android:9a0539c1eccf7c30b99eaf',
    messagingSenderId: '65683061758',
    projectId: 'foodly-full-code-flutter',
    storageBucket: 'foodly-full-code-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5TWMA2ZPBFMAwdwsJyFYPi5zzotPQPrQ',
    appId: '1:65683061758:ios:075684f4fb6b465cb99eaf',
    messagingSenderId: '65683061758',
    projectId: 'foodly-full-code-flutter',
    storageBucket: 'foodly-full-code-flutter.appspot.com',
    androidClientId: '65683061758-3c1798541en860f40mvg7m03seo5lfs5.apps.googleusercontent.com',
    iosClientId: '65683061758-ec3sgi6vvpb5da4akjmngr2ehngbfnqv.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodlyRestaurant',
  );
}
