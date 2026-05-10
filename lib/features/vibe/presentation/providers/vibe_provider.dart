import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/core/config/supabase_client.dart';
import 'package:flutter_clubapp/features/vibe/domain/services/vibe_points_service.dart';
import 'package:flutter_clubapp/features/vibe/domain/models/vibe_action.dart';
import 'package:flutter_clubapp/features/vibe/domain/vibe_repository.dart';
import 'package:flutter_clubapp/features/vibe/data/supabase_vibe_repository.dart';

final vibeRepositoryProvider = Provider<VibeRepository>((ref) {
  return SupabaseVibeRepository(ref.watch(supabaseClientProvider));
});

// --- DATA KLASSEN VOOR DE UI ---
class VibeDisplayData {
  final int totalVp;
  final int level;
  final String levelName;
  final int streak;
  final double progress;
  final int vpForNextLevel;
  final int? rank;

  const VibeDisplayData({
    required this.totalVp,
    required this.level,
    required this.levelName,
    required this.streak,
    required this.progress,
    required this.vpForNextLevel,
    this.rank,
  });
}

class VibeProfileState {
  final int totalVp;
  final int currentLevel;
  final int weekendStreak;
  final List<String> visitedPlaces;
  final List<VibeAction> recentActions;

  const VibeProfileState({
    this.totalVp = 0,
    this.currentLevel = 1,
    this.weekendStreak = 0,
    this.visitedPlaces = const [],
    this.recentActions = const [],
  });

  VibeProfileState copyWith({
    int? totalVp,
    int? currentLevel,
    int? weekendStreak,
    List<String>? visitedPlaces,
    List<VibeAction>? recentActions,
  }) {
    return VibeProfileState(
      totalVp: totalVp ?? this.totalVp,
      currentLevel: currentLevel ?? this.currentLevel,
      weekendStreak: weekendStreak ?? this.weekendStreak,
      visitedPlaces: visitedPlaces ?? this.visitedPlaces,
      recentActions: recentActions ?? this.recentActions,
    );
  }
}

// --- NOTIFIER ---
class VibeNotifier extends AsyncNotifier<VibeProfileState> {
  late SupabaseClient _supabase;

  @override
  Future<VibeProfileState> build() async {
    _supabase = ref.watch(supabaseClientProvider);
    return _fetchVibeProfile();
  }

  Future<VibeProfileState> _fetchVibeProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return const VibeProfileState();

    try {
      final response = await _supabase
          .from('vibe_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      final actionsResponse = await _supabase
          .from('vibe_actions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(10);

      final actions = (actionsResponse as List)
          .map((json) => VibeAction.fromJson(json))
          .toList();

      if (response != null) {
        return VibeProfileState(
          totalVp: response['total_vp'] as int? ?? 0,
          currentLevel: response['current_level'] as int? ?? 1,
          weekendStreak: response['weekend_streak'] as int? ?? 0,
          visitedPlaces: List<String>.from(response['visited_places'] ?? []),
          recentActions: actions,
        );
      } else {
        return VibeProfileState(recentActions: actions);
      }
    } catch (e) {
      // Ignored for fallback
    }

    return const VibeProfileState();
  }

  Future<void> submitVibeCheck({
    required String placeId,
    required bool isPositive,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('vibe_checks').insert({
        'place_id': placeId,
        'is_positive': isPositive,
        'user_id': userId,
      });

      ref.invalidateSelf();
    } catch (e) {
      // Ignored
    }
  }

  Future<void> updateVibe(String placeId, {required bool isPositive}) async {
    await submitVibeCheck(placeId: placeId, isPositive: isPositive);
  }

  Future<void> checkIn(String placeId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('vibe_actions').insert({
        'user_id': userId,
        'action_type': 'check_in',
        'place_id': placeId,
        'vp_earned': 10,
      });

      ref.invalidateSelf();
    } catch (e) {
      // Ignored
    }
  }
}

// --- PROVIDERS ---
final vibeProvider = AsyncNotifierProvider<VibeNotifier, VibeProfileState>(() {
  return VibeNotifier();
});

final vpDisplayProvider = Provider<VibeDisplayData?>((ref) {
  final stateAsync = ref.watch(vibeProvider);
  final state = stateAsync.value;

  if (state == null) return null;

  final levelInfo = LevelInfo.getLevelInfo(state.currentLevel);
  final nextVp = VibePointsService.getVpForNextLevel(
    state.currentLevel,
    state.totalVp,
  );
  final progress = VibePointsService.getLevelProgress(state.totalVp);

  return VibeDisplayData(
    totalVp: state.totalVp,
    level: state.currentLevel,
    levelName: levelInfo.name,
    streak: state.weekendStreak,
    progress: progress,
    vpForNextLevel: nextVp,
    rank: null,
  );
});
