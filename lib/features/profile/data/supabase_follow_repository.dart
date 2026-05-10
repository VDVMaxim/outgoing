import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/features/profile/domain/models/user_profile.dart';
import 'package:flutter_clubapp/features/profile/domain/repositories/follow_repository.dart';

class SupabaseFollowRepository implements FollowRepository {
  final _supabase = Supabase.instance.client;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<void> followUser(String followingId) async {
    final followerId = _currentUserId;
    if (followerId == null || followerId == followingId) return;

    await _supabase.from('user_followers').insert({
      'follower_id': followerId,
      'following_id': followingId,
    });
  }

  @override
  Future<void> unfollowUser(String followingId) async {
    final followerId = _currentUserId;
    if (followerId == null) return;

    await _supabase
        .from('user_followers')
        .delete()
        .eq('follower_id', followerId)
        .eq('following_id', followingId);
  }

  @override
  Future<void> removeFollower(String followerId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return;

    await _supabase
        .from('user_followers')
        .delete()
        .eq('follower_id', followerId)
        .eq('following_id', currentUserId);
  }

  @override
  Future<bool> isFollowing(String userId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || currentUserId == userId) return false;

    final response = await _supabase
        .from('user_followers')
        .select()
        .eq('follower_id', currentUserId)
        .eq('following_id', userId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<UserProfile?> getProfileWithStats(String userId) async {
    final currentUserId = _currentUserId;

    final profileResponse = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (profileResponse == null) return null;

    final followersCount = await _supabase
        .from('user_followers')
        .count()
        .eq('following_id', userId);

    final followingCount = await _supabase
        .from('user_followers')
        .count()
        .eq('follower_id', userId);

    bool followingStatus = false;
    if (currentUserId != null && currentUserId != userId) {
      followingStatus = await isFollowing(userId);
    }

    return UserProfile.fromJson({
      ...profileResponse,
      'follower_count': followersCount,
      'following_count': followingCount,
      'is_following': followingStatus,
    });
  }

  @override
  Future<List<UserProfile>> getFollowers(String userId) async {
    try {
      final response = await _supabase
          .from('user_followers')
          .select('profiles!follower_id(*)')
          .eq('following_id', userId);

      return (response as List).map((data) {
        return UserProfile.fromJson(data['profiles']);
      }).toList();
    } catch (e, stack) {
      debugPrint('Fout bij getFollowers: $e\n$stack');
      return [];
    }
  }

  @override
  Future<List<UserProfile>> getFollowing(String userId) async {
    try {
      final response = await _supabase
          .from('user_followers')
          .select('profiles!following_id(*)')
          .eq('follower_id', userId);

      return (response as List).map((data) {
        return UserProfile.fromJson(data['profiles']);
      }).toList();
    } catch (e, stack) {
      debugPrint('Fout bij getFollowing: $e\n$stack');
      return [];
    }
  }
}
