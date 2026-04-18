import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vibe_profile.dart';
import '../models/vibe_action.dart';
import '../models/badge.dart';
import '../repositories/vibe_repository.dart';
import 'service_providers.dart'; 

class VibeState {
  final VibeProfile? profile;
  final List<VibeAction> recentActions;
  final BadgeVault? badgeVault;
  final bool isLoading;
  final int? rank;
  final String? error;

  const VibeState({
    this.profile,
    this.recentActions = const [],
    this.badgeVault,
    this.isLoading = false,
    this.rank,
    this.error,
  });

  VibeState copyWith({
    VibeProfile? profile,
    List<VibeAction>? recentActions,
    BadgeVault? badgeVault,
    bool? isLoading,
    int? rank,
    String? error,
  }) {
    return VibeState(
      profile: profile ?? this.profile,
      recentActions: recentActions ?? this.recentActions,
      isLoading: isLoading ?? this.isLoading,
      rank: rank ?? this.rank,
      error: error,
    );
  }
}

class VibeNotifier extends StateNotifier<VibeState> {
  final VibeRepository _repository;

  VibeNotifier()
      : _repository = VibeRepository(),
        super(const VibeState());

  Future<void> loadProfile() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repository.getOrCreateProfile(userId);
      final recentActions = await _repository.getRecentActions(userId);
      final rank = await _repository.getRank(userId);

      state = state.copyWith(
        profile: profile,
        recentActions: recentActions,
        rank: rank,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> checkIn(String? placeId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profile = await _repository.addVp(
        odUserId: userId,
        actionType: VibeActionType.checkIn,
        placeId: placeId,
        visitedPlaces: state.profile?.visitedPlaces ?? [],
      );

      await _repository.updateStreak(userId);

      final rank = await _repository.getRank(userId);
      final recentActions = await _repository.getRecentActions(userId);

      state = state.copyWith(
        profile: profile,
        rank: rank,
        recentActions: recentActions,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateVibe(String placeId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profile = await _repository.addVp(
        odUserId: userId,
        actionType: VibeActionType.vibeUpdate,
        placeId: placeId,
      );

      final rank = await _repository.getRank(userId);
      final recentActions = await _repository.getRecentActions(userId);

      state = state.copyWith(
        profile: profile,
        rank: rank,
        recentActions: recentActions,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> inviteSquadMember() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profile = await _repository.addVp(
        odUserId: userId,
        actionType: VibeActionType.squadInvite,
      );

      final rank = await _repository.getRank(userId);
      state = state.copyWith(profile: profile, rank: rank);
      return true;

    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}

final vibeProvider = StateNotifierProvider<VibeNotifier, VibeState>((ref) {
  return VibeNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(userProfileServiceProvider).isAuthenticated;
});

final vpDisplayProvider = Provider<VibeDisplayData?>((ref) {
  final vibeState = ref.watch(vibeProvider);
  if (vibeState.profile == null) return null;

  final profile = vibeState.profile!;
  return VibeDisplayData(
    totalVp: profile.totalVp,
    level: profile.currentLevel,
    levelName: _getLevelName(profile.currentLevel),
    streak: profile.weekendStreak,
    rank: vibeState.rank,
    progress: _getProgress(profile.totalVp, profile.currentLevel),
    vpForNextLevel: _getVpForNextLevel(profile.currentLevel),
  );
});

String _getLevelName(int level) {
  switch (level) {
    case 1:
      return 'Newbie';
    case 2:
      return 'Club Hopper';
    case 3:
      return 'Vibe Master';
    case 4:
      return 'Legend';
    default:
      return 'Newbie';
  }
}

double _getProgress(int vp, int level) {
  switch (level) {
    case 1:
      return vp / 100;
    case 2:
      return (vp - 100) / 400;
    case 3:
      return (vp - 500) / 1000;
    case 4:
      return 1.0;
    default:
      return 0.0;
  }
}

int _getVpForNextLevel(int level) {
  switch (level) {
    case 1:
      return 100;
    case 2:
      return 500;
    case 3:
      return 1500;
    case 4:
      return 0;
    default:
      return 100;
  }
}

class VibeDisplayData {
  final int totalVp;
  final int level;
  final String levelName;
  final int streak;
  final int? rank;
  final double progress;
  final int vpForNextLevel;

  const VibeDisplayData({
    required this.totalVp,
    required this.level,
    required this.levelName,
    required this.streak,
    this.rank,
    required this.progress,
    required this.vpForNextLevel,
  });
}