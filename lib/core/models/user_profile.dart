class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String nickname;
  final String? avatarUrl;
  final String? bio;
  
  final int followerCount;
  final int followingCount;
  final bool isFollowing;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.nickname,
    this.avatarUrl,
    this.bio,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      followerCount: json['follower_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'nickname': nickname,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? nickname,
    String? avatarUrl,
    String? bio,
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}