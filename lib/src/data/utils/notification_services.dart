import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  final _firebaseMessaging = FirebaseMessaging.instance;

  initialMessaging() async {
    try {
      await _firebaseMessaging.requestPermission();
      await _firebaseMessaging.getToken();
    } catch (e) {
      throw Exception(e);
    }
  }
}
