class SquadMember {
  final String id;
  final String squadId;
  final String userId;
  final String nickname;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;
  final String? avatarUrl;

  const SquadMember({
    required this.id,
    required this.squadId,
    required this.userId,
    required this.nickname,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    this.avatarUrl,
  });

  factory SquadMember.fromJson(Map<String, dynamic> json) {
    String? avatar;
    if (json['profiles'] != null && json['profiles'] is Map) {
      avatar = json['profiles']['avatar_url'] as String?;
    }

    return SquadMember(
      id: json['id'] as String,
      squadId: json['squad_id'] as String,
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      avatarUrl: avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'user_id': userId,
      'nickname': nickname,
      'latitude': latitude,
      'longitude': longitude,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SquadMember copyWith({
    String? id,
    String? squadId,
    String? userId,
    String? nickname,
    double? latitude,
    double? longitude,
    DateTime? updatedAt,
    String? avatarUrl,
  }) {
    return SquadMember(
      id: id ?? this.id,
      squadId: squadId ?? this.squadId,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      updatedAt: updatedAt ?? this.updatedAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
