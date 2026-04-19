import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';

class AnalyticsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final UserProfileService _userProfileService;

  AnalyticsService(this._userProfileService);

  /// Log een analytisch event naar de Supabase `app_events` tabel
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    try {
      final userId = _userProfileService.userId;

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