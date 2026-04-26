import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/vibe_profile.dart';
import '../models/vibe_action.dart';
import '../services/vibe_points_service.dart';

class VibeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<VibeProfile?> getProfile(String odUserId) async {
    final response = await _supabase
        .from('vibe_profiles')
        .select()
        .eq('user_id', odUserId)
        .maybeSingle();

    if (response == null) return null;
    return VibeProfile.fromJson(response);
  }

  Future<VibeProfile> getOrCreateProfile(String odUserId) async {
    final existing = await getProfile(odUserId);

    if (existing != null) return existing;

    final newProfile = VibeProfile.empty(odUserId);

    await _supabase.from('vibe_profiles').insert({
      'id': newProfile.id,
      'user_id': odUserId,
      'total_vp': 0,
      'current_level': 1,
      'weekend_streak': 0,
      'visited_places': [],
    });

    return newProfile;
  }

  Future<VibeProfile> addVp({
    required String odUserId,
    required VibeActionType actionType,
    String? placeId,
    List<String> visitedPlaces = const [],
  }) async {
    final profile = await getOrCreateProfile(odUserId);

    final now = DateTime.now();
    final isEarlyBird = VibePointsService.isEarlyBird();
    final isNewPlace = placeId != null && !visitedPlaces.contains(placeId);

    final newVp = VibePointsService.calculateVp(
      actionType: actionType,
      isEarlyBird: isEarlyBird && actionType == VibeActionType.checkIn,
      isNewPlace: isNewPlace,
      currentStreak: profile.weekendStreak,
    );

    final newTotalVp = profile.totalVp + newVp;
    final newLevel = VibePointsService.calculateLevel(newTotalVp);

    final newVisitedPlaces = List<String>.from(profile.visitedPlaces);

    if (placeId != null && !newVisitedPlaces.contains(placeId)) {
      newVisitedPlaces.add(placeId);
    }

    await _supabase
        .from('vibe_profiles')
        .update({
          'total_vp': newTotalVp,
          'current_level': newLevel,
          'last_check_in': now.toIso8601String(),
          'visited_places': newVisitedPlaces,
          'updated_at': now.toIso8601String(),
        })
        .eq('user_id', odUserId);

    await _supabase.from('vibe_actions').insert({
      'id': const Uuid().v4(),
      'user_id': odUserId,
      'action_type': actionType.dbValue,
      'place_id': placeId,
      'vp_earned': newVp,
      'created_at': now.toIso8601String(),
    });

    return profile.copyWith(
      totalVp: newTotalVp,
      currentLevel: newLevel,
      lastCheckIn: now,
      visitedPlaces: newVisitedPlaces,
    );
  }

  Future<VibeProfile> updateStreak(String odUserId) async {
    final profile = await getOrCreateProfile(odUserId);
    final now = DateTime.now();

    final shouldReset = VibePointsService.shouldUpdateStreak(profile.lastCheckIn);
    
    int newStreak = shouldReset ? 1 : profile.weekendStreak;

    if (!shouldReset && profile.lastCheckIn != null) {
      final daysSince = now.difference(profile.lastCheckIn!).inDays;

      if (daysSince == 1 || daysSince == 2) {
        newStreak = profile.weekendStreak + 1;
      }
    }

    await _supabase
        .from('vibe_profiles')
        .update({
          'weekend_streak': newStreak,
          'updated_at': now.toIso8601String(),
        })
        .eq('user_id', odUserId);

    return profile.copyWith(weekendStreak: newStreak);
  }

  Future<List<VibeAction>> getRecentActions(String odUserId, {int limit = 10}) async {
    final response = await _supabase
        .from('vibe_actions')
        .select()
        .eq('user_id', odUserId)
        .order('created_at', ascending: false)
        .limit(limit);

    return response.map((json) => VibeAction.fromJson(json)).toList();
  }

  Future<List<VibeProfile>> getLeaderboard({int limit = 10}) async {
    final response = await _supabase
        .from('vibe_profiles')
        .select()
        .order('total_vp', ascending: false)
        .limit(limit);

    return response.map((json) => VibeProfile.fromJson(json)).toList();
  }

  Future<int?> getRank(String odUserId) async {
    final profile = await getProfile(odUserId);

    if (profile == null) return null;

    final response = await _supabase
        .from('vibe_profiles')
        .select('user_id')
        .order('total_vp', ascending: false);

    final index = response.indexWhere((p) => p['user_id'] == odUserId);
    return index >= 0 ? index + 1 : null;
  }
}