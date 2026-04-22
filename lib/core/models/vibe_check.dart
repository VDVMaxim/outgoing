class VibeCheck {
  final String id;
  final String venueId;
  final bool isPositive;
  final String? userId;
  final DateTime createdAt;

  const VibeCheck({
    required this.id,
    required this.venueId,
    required this.isPositive,
    this.userId,
    required this.createdAt,
  });

  factory VibeCheck.fromJson(Map<String, dynamic> json) {
    return VibeCheck(
      id: json['id'] as String,
      venueId: json['venue_id'] as String,
      isPositive: json['is_positive'] as bool? ?? true,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_id': venueId,
      'is_positive': isPositive,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  VibeCheck copyWith({
    String? id,
    String? venueId,
    bool? isPositive,
    String? userId,
    DateTime? createdAt,
  }) {
    return VibeCheck(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      isPositive: isPositive ?? this.isPositive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}