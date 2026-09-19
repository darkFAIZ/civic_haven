import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:web:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'civic-haven-demo',
    authDomain: 'civic-haven-demo.firebaseapp.com',
    storageBucket: 'civic-haven-demo.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:android:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'civic-haven-demo',
    storageBucket: 'civic-haven-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:ios:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'civic-haven-demo',
    storageBucket: 'civic-haven-demo.appspot.com',
    iosBundleId: 'com.example.civicHaven',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:macos:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'civic-haven-demo',
    storageBucket: 'civic-haven-demo.appspot.com',
    iosBundleId: 'com.example.civicHaven',
  );
}
