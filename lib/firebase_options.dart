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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCenXlQwXXVShjjAPxPQ6DMPaaCk66VrxU',
    appId: '1:1078940649167:web:ac0999b217590c0bd259ba',
    messagingSenderId: '1078940649167',
    projectId: 'kit721-assignment4',
    authDomain: 'kit721-assignment4.firebaseapp.com',
    storageBucket: 'kit721-assignment4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpI_NOiHZEIdh6tdtzBFtKNwLZSYs_7qE',
    appId: '1:1078940649167:android:a87ee60b3e8efdd0d259ba',
    messagingSenderId: '1078940649167',
    projectId: 'kit721-assignment4',
    storageBucket: 'kit721-assignment4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2Gl_KRNuAa4uHsO-eQpMuSZwvuD9lYc8',
    appId: '1:1078940649167:ios:7c92ca70a401a95ed259ba',
    messagingSenderId: '1078940649167',
    projectId: 'kit721-assignment4',
    storageBucket: 'kit721-assignment4.appspot.com',
    iosClientId: '1078940649167-19oo7i1rqg57ruqjm6qpqkb86o1gr0ee.apps.googleusercontent.com',
    iosBundleId: 'au.utas.edu.ywang150.kit721Assignment4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2Gl_KRNuAa4uHsO-eQpMuSZwvuD9lYc8',
    appId: '1:1078940649167:ios:7c92ca70a401a95ed259ba',
    messagingSenderId: '1078940649167',
    projectId: 'kit721-assignment4',
    storageBucket: 'kit721-assignment4.appspot.com',
    iosClientId: '1078940649167-19oo7i1rqg57ruqjm6qpqkb86o1gr0ee.apps.googleusercontent.com',
    iosBundleId: 'au.utas.edu.ywang150.kit721Assignment4',
  );
}
