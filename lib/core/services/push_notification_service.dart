import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_clubapp/core/constants/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  void initialize() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Env.oneSignalAppId);
  }

  Future<bool> requestPermission() async {
    return await OneSignal.Notifications.requestPermission(true);
  }

  void login(String userId) {
    OneSignal.login(userId);
  }

  void logout() {
    OneSignal.logout();
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});
