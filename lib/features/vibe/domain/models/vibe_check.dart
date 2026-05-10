class VibeCheck {
  final String id;
  final String placeId;
  final bool isPositive;
  final String? userId;
  final DateTime createdAt;

  const VibeCheck({
    required this.id,
    required this.placeId,
    required this.isPositive,
    this.userId,
    required this.createdAt,
  });

  factory VibeCheck.fromJson(Map<String, dynamic> json) {
    return VibeCheck(
      id: json['id'] as String,
      placeId: json['place_id'] as String,
      isPositive: json['is_positive'] as bool? ?? true,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'is_positive': isPositive,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  VibeCheck copyWith({
    String? id,
    String? placeId,
    bool? isPositive,
    String? userId,
    DateTime? createdAt,
  }) {
    return VibeCheck(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      isPositive: isPositive ?? this.isPositive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
