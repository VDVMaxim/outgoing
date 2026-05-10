import '../models/user_profile.dart';

abstract class FollowRepository {
  Future<void> followUser(String followingId);
  Future<void> unfollowUser(String followingId);
  Future<void> removeFollower(String followerId);
  Future<bool> isFollowing(String userId);
  Future<UserProfile?> getProfileWithStats(String userId);
  Future<List<UserProfile>> getFollowers(String userId);
  Future<List<UserProfile>> getFollowing(String userId);
}
