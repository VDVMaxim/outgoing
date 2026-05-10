import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  AnalyticsService();

  /// Log een analytisch event naar de Supabase `app_events` tabel
  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      await _supabase.from('app_events').insert({
        'user_id': userId,
        'event_name': eventName,
        'event_data': parameters ?? {},
      });

      if (kDebugMode) {
        debugPrint('📈 Analytics Event: $eventName | $parameters');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Analytics Error ($eventName): $e');
      }
    }
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
