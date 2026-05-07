import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import 'service_providers.dart';

final profileStatsProvider = FutureProvider.family<UserProfile?, String>((ref, userId) async {
  final service = ref.read(followServiceProvider);
  return service.getProfileWithStats(userId);
});

final followersProvider = FutureProvider.family<List<UserProfile>, String>((ref, userId) async {
  final service = ref.read(followServiceProvider);
  return service.getFollowers(userId);
});

final followingProvider = FutureProvider.family<List<UserProfile>, String>((ref, userId) async {
  final service = ref.read(followServiceProvider);
  return service.getFollowing(userId);
});

class FollowController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  FollowController(this._ref) : super(const AsyncData(null));

  Future<void> followUser(String targetUserId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followServiceProvider).followUser(targetUserId);
      _invalidateCaches(targetUserId, currentUserId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> unfollowUser(String targetUserId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followServiceProvider).unfollowUser(targetUserId);
      _invalidateCaches(targetUserId, currentUserId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeFollower(String followerId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followServiceProvider).removeFollower(followerId);
      _invalidateCaches(currentUserId, followerId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _invalidateCaches(String userA, String userB) {
    _ref.invalidate(profileStatsProvider(userA));
    _ref.invalidate(followersProvider(userA));
    _ref.invalidate(followingProvider(userA));

    _ref.invalidate(profileStatsProvider(userB));
    _ref.invalidate(followersProvider(userB));
    _ref.invalidate(followingProvider(userB));

    _ref.read(authProvider.notifier).refresh();
  }
}

final followControllerProvider = StateNotifierProvider<FollowController, AsyncValue<void>>((ref) {
  return FollowController(ref);
});