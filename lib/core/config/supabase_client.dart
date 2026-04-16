import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseClientProvider {
  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw StateError(
        'SupabaseClient not initialized. Call SupabaseClientProvider.initialize() first.',
      );
    }
    return _client!;
  }

  static Future<void> initialize() async {
    if (_client != null) return;

    final url = await SupabaseConfig.getUrl();
    final anonKey = await SupabaseConfig.getAnonKey();

    if (url == null || anonKey == null) {
      throw StateError(
        'Supabase credentials not found. Please configure SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    _client = Supabase.instance.client;
  }

  static bool get isInitialized => _client != null;

  static void reset() {
    _client = null;
  }
}
