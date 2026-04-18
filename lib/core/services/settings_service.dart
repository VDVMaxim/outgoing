import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_clubapp/core/utils/nickname_generator.dart';

class SettingsService {
  static SettingsService? _instance;
  static SharedPreferences? _prefs;

  static const String _keyTrackingFrequency = 'tracking_frequency';
  static const String _keyOfflineMultiplier = 'offline_multiplier';

  static const int defaultTrackingFrequency = 5;
  static const int defaultOfflineMultiplier = 4;

  SettingsService._();

  static Future<SettingsService> getInstance() async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = SettingsService._();
    }
    return _instance!;
  }

  int get trackingFrequency {
    return _prefs?.getInt(_keyTrackingFrequency) ?? defaultTrackingFrequency;
  }

  set trackingFrequency(int value) {
    _prefs?.setInt(_keyTrackingFrequency, value);
  }

  int get offlineMultiplier {
    return _prefs?.getInt(_keyOfflineMultiplier) ?? defaultOfflineMultiplier;
  }

  set offlineMultiplier(int value) {
    _prefs?.setInt(_keyOfflineMultiplier, value);
  }

  int get offlineThresholdSeconds {
    return trackingFrequency * offlineMultiplier;
  }

  String generateRandomNickname() {
    return NicknameGenerator.generate();
  }
}
