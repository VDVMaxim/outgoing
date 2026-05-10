import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/features/profile/domain/models/user_profile.dart';
import 'package:flutter_clubapp/features/profile/domain/repositories/follow_repository.dart';
import 'package:flutter_clubapp/features/profile/data/supabase_follow_repository.dart';

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  return SupabaseFollowRepository();
});

final profileStatsProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) async {
  final service = ref.read(followRepositoryProvider);
  return service.getProfileWithStats(userId);
});

final followersProvider = FutureProvider.family<List<UserProfile>, String>((
  ref,
  userId,
) async {
  final service = ref.read(followRepositoryProvider);
  return service.getFollowers(userId);
});

final followingProvider = FutureProvider.family<List<UserProfile>, String>((
  ref,
  userId,
) async {
  final service = ref.read(followRepositoryProvider);
  return service.getFollowing(userId);
});

class FollowController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  FollowController(this._ref) : super(const AsyncData(null));

  Future<void> followUser(String targetUserId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followRepositoryProvider).followUser(targetUserId);
      _invalidateCaches(targetUserId, currentUserId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> unfollowUser(String targetUserId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followRepositoryProvider).unfollowUser(targetUserId);
      _invalidateCaches(targetUserId, currentUserId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeFollower(String followerId, String currentUserId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(followRepositoryProvider).removeFollower(followerId);
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

    _ref.invalidate(followingProvider(userB));

    // Notice: we can't refresh authProvider.notifier if it's not a StateNotifier/AsyncNotifier
    // unless defined as such. Let's assume authProvider has a refresh. If not, it will fail build.
  }
}

final followControllerProvider =
    StateNotifierProvider<FollowController, AsyncValue<void>>((ref) {
      return FollowController(ref);
    });
