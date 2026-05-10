import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_clubapp/core/providers/shared_prefs_provider.dart';

class SettingsState {
  final bool hapticsEnabled;
  final int trackingFrequency;
  final int offlineMultiplier;

  const SettingsState({
    required this.hapticsEnabled,
    required this.trackingFrequency,
    required this.offlineMultiplier,
  });

  SettingsState copyWith({
    bool? hapticsEnabled,
    int? trackingFrequency,
    int? offlineMultiplier,
  }) {
    return SettingsState(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      trackingFrequency: trackingFrequency ?? this.trackingFrequency,
      offlineMultiplier: offlineMultiplier ?? this.offlineMultiplier,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      hapticsEnabled: _prefs.getBool('hapticsEnabled') ?? true,
      trackingFrequency: _prefs.getInt('trackingFrequency') ?? 2,
      offlineMultiplier: _prefs.getInt('offlineMultiplier') ?? 5,
    );
  }

  Future<void> setHapticsEnabled(bool value) async {
    await _prefs.setBool('hapticsEnabled', value);
    state = state.copyWith(hapticsEnabled: value);
  }

  Future<void> setTrackingFrequency(int value) async {
    await _prefs.setInt('trackingFrequency', value);
    state = state.copyWith(trackingFrequency: value);
  }

  Future<void> setOfflineMultiplier(int value) async {
    await _prefs.setInt('offlineMultiplier', value);
    state = state.copyWith(offlineMultiplier: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

// --- Theme & Locale Providers ---

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final isDark = prefs.getBool('isDarkMode') ?? true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('isDarkMode', isDark);
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  () => ThemeNotifier(),
);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    return null;
  }

  void setLocale(Locale? locale) {
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  () => LocaleNotifier(),
);

// --- Legacy Wrapper voor UI Compatibiliteit in Fase 2 ---
class SettingsService {
  final Ref _ref;
  SettingsService(this._ref);

  SettingsState get _state => _ref.read(settingsProvider);
  SettingsNotifier get _notifier => _ref.read(settingsProvider.notifier);

  bool get hapticsEnabled => _state.hapticsEnabled;
  Future<void> setHapticsEnabled(bool value) =>
      _notifier.setHapticsEnabled(value);

  int get trackingFrequency => _state.trackingFrequency;
  Future<void> setTrackingFrequency(int value) =>
      _notifier.setTrackingFrequency(value);

  int get offlineMultiplier => _state.offlineMultiplier;
  Future<void> setOfflineMultiplier(int value) =>
      _notifier.setOfflineMultiplier(value);
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref);
});
