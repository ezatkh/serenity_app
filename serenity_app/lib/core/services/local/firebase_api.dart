import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Get the initial token
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');
    // TODO: Send this token to your backend

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      // TODO: Send this new token to your backend
    });
  }
}
