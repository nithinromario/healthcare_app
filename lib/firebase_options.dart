import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCN8JKHpcFJA8edsAuCA1Ozjyjz8m5q_fE',
    appId: '1:686514065387:web:3243b4a3821e3c31c113ae',
    messagingSenderId: '686514065387',
    projectId: 'healthcare-app-3f499',
    authDomain: 'healthcare-app-3f499.firebaseapp.com',
    storageBucket: 'healthcare-app-3f499.appspot.com',
    measurementId: 'G-measurement-id', // Add this for web analytics
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCN8JKHpcFJA8edsAuCA1Ozjyjz8m5q_fE',
    appId: '1:686514065387:android:3243b4a3821e3c31c113ae',
    messagingSenderId: '686514065387',
    projectId: 'healthcare-app-3f499',
    storageBucket: 'healthcare-app-3f499.firebasestorage.app',
  );
}
