import '../config/supabase_client.dart';
import '../models/vibe_check.dart';
import 'interfaces/vibe_repository.dart';

class SupabaseVibeRepository implements VibeRepository {
  @override
  Future<void> submitVibeCheck({
    required String placeId,
    required bool isPositive,
  }) async {
    final client = SupabaseClientProvider.client;
    
    await client.from('vibe_checks').insert({
      'venue_id': placeId,
      'is_positive': isPositive,
      'user_id': client.auth.currentUser?.id,
    });
  }

  @override
  Future<List<VibeCheck>> getVibeChecksForPlace(
    String placeId, {
    int limit = 10,
  }) async {
    final client = SupabaseClientProvider.client;

    final response = await client
        .from('vibe_checks')
        .select()
        .eq('venue_id', placeId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => VibeCheck.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}