// File: lib/firebase_options.dart
// This file was generated manually using the values from your Firebase config files.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // Now enabled for Android
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // iOS options from your GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC59gcJegAANdteHJJSUOzuNQCTLxz2ee4',
    appId: '1:908392991184:ios:a530f3ad43eae885b611d5',
    messagingSenderId: '908392991184',
    projectId: 'serenity-f5259',
    storageBucket: 'serenity-f5259.appspot.com',
    iosBundleId: 'com.serenityportugal.serenity',
  );

  // Android options from your google-services.json
  // Using the configuration for 'com.serenityportugal.serenity'
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJ4rB_OjCoCWSFTaKP_fjRCxUNSkFcpF4',
    appId: '1:908392991184:android:87973b1f8a68330eb611d5',
    messagingSenderId: '908392991184',
    projectId: 'serenity-f5259',
    storageBucket: 'serenity-f5259.appspot.com',
  );
}
