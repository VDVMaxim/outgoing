class VibeCheck {
  final String id;
  final String venueId;
  final String crowdLevel;
  final int energy;
  final String? userId;
  final DateTime createdAt;

  const VibeCheck({
    required this.id,
    required this.venueId,
    required this.crowdLevel,
    required this.energy,
    this.userId,
    required this.createdAt,
  });

  factory VibeCheck.fromJson(Map<String, dynamic> json) {
    return VibeCheck(
      id: json['id'] as String,
      venueId: json['venue_id'] as String,
      crowdLevel: json['crowd_level'] as String,
      energy: json['energy'] as int,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_id': venueId,
      'crowd_level': crowdLevel,
      'energy': energy,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  VibeCheck copyWith({
    String? id,
    String? venueId,
    String? crowdLevel,
    int? energy,
    String? userId,
    DateTime? createdAt,
  }) {
    return VibeCheck(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      energy: energy ?? this.energy,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}