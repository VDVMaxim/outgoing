import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/features/vibe/domain/models/vibe_check.dart';
import '../domain/vibe_repository.dart';

class SupabaseVibeRepository implements VibeRepository {
  final SupabaseClient _client;

  SupabaseVibeRepository(this._client);

  @override
  Future<void> submitVibeCheck({
    required String placeId,
    required bool isPositive,
  }) async {
    await _client.from('vibe_checks').insert({
      'place_id': placeId,
      'is_positive': isPositive,
      'user_id': _client.auth.currentUser?.id,
    });
  }

  @override
  Future<List<VibeCheck>> getVibeChecksForPlace(
    String placeId, {
    int limit = 10,
  }) async {
    final response = await _client
        .from('vibe_checks')
        .select()
        .eq('place_id', placeId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => VibeCheck.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
