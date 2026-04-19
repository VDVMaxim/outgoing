import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsService._(this._prefs);

  static late SettingsService _instance;
  static SettingsService get instance => _instance;

  static Future<SettingsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = SettingsService._(prefs);
    return _instance;
  }

  bool get hapticsEnabled => _prefs.getBool('hapticsEnabled') ?? true;

  Future<void> setHapticsEnabled(bool value) async {
    await _prefs.setBool('hapticsEnabled', value);
    notifyListeners(); 
  }

  int get trackingFrequency => _prefs.getInt('trackingFrequency') ?? 2;

  Future<void> setTrackingFrequency(int value) async {
    await _prefs.setInt('trackingFrequency', value);
    notifyListeners();
  }

  int get offlineMultiplier => _prefs.getInt('offlineMultiplier') ?? 5;

  Future<void> setOfflineMultiplier(int value) async {
    await _prefs.setInt('offlineMultiplier', value);
    notifyListeners();
  }
  
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? true;
  
  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }
}