import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SupabaseConfig {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _urlKey = 'SUPABASE_URL';
  static const _anonKeyKey = 'SUPABASE_ANON_KEY';

  static Future<String?> getUrl() async {
    return _storage.read(key: _urlKey);
  }

  static Future<String?> getAnonKey() async {
    return _storage.read(key: _anonKeyKey);
  }

  static Future<void> setUrl(String url) async {
    await _storage.write(key: _urlKey, value: url);
  }

  static Future<void> setAnonKey(String key) async {
    await _storage.write(key: _anonKeyKey, value: key);
  }

  static Future<void> clear() async {
    await _storage.delete(key: _urlKey);
    await _storage.delete(key: _anonKeyKey);
  }

  static Future<bool> hasCredentials() async {
    final url = await getUrl();
    final anonKey = await getAnonKey();
    return url != null &&
        url.isNotEmpty &&
        anonKey != null &&
        anonKey.isNotEmpty;
  }
}
