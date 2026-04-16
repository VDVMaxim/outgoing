import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class SettingsService {
  static SettingsService? _instance;
  static SharedPreferences? _prefs;

  static const String _keyTrackingFrequency = 'tracking_frequency';
  static const String _keyOfflineMultiplier = 'offline_multiplier';

  static const int defaultTrackingFrequency = 5;
  static const int defaultOfflineMultiplier = 4;

  static final List<String> _nicknameAdjectives = [
    'Swift',
    'Mystic',
    'Cosmic',
    'Shadow',
    'Electric',
    'Silent',
    'Golden',
    'Silver',
    'Neon',
    'Phantom',
    'Thunder',
    'Crystal',
    'Midnight',
    'Starlight',
    'Wild',
    'Gentle',
    'Brave',
    'Lucky',
    'Lucky',
    'Happy',
  ];

  static final List<String> _nicknameNouns = [
    'Ghoul',
    'Wolf',
    'Phantom',
    'Raven',
    'Storm',
    'Phoenix',
    'Dragon',
    'Hawk',
    'Tiger',
    'Panther',
    'Ninja',
    'Knight',
    'Wizard',
    'Sorcerer',
    'Mage',
    'Spirit',
    'Ghost',
    'Specter',
    'Wraith',
    'Demon',
  ];

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
    final random = Random();
    final adjective =
        _nicknameAdjectives[random.nextInt(_nicknameAdjectives.length)];
    final noun = _nicknameNouns[random.nextInt(_nicknameNouns.length)];
    final number = (1000 + random.nextInt(9000)).toString();
    return '$adjective $noun #$number';
  }

  static int get hash => 42;
}
