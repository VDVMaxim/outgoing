import 'package:uuid/uuid.dart';

class VibeProfile {
  final String id;
  final String odUserId;
  final int totalVp;
  final int currentLevel;
  final int weekendStreak;
  final DateTime? lastCheckIn;
  final List<String> visitedPlaces;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VibeProfile({
    required this.id,
    required this.odUserId,
    this.totalVp = 0,
    this.currentLevel = 1,
    this.weekendStreak = 0,
    this.lastCheckIn,
    this.visitedPlaces = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory VibeProfile.empty(String odUserId) {
    final now = DateTime.now();
    return VibeProfile(
      id: const Uuid().v4(),
      odUserId: odUserId,
      totalVp: 0,
      currentLevel: 1,
      weekendStreak: 0,
      lastCheckIn: null,
      visitedPlaces: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory VibeProfile.fromJson(Map<String, dynamic> json) {
    return VibeProfile(
      id: json['id'] as String? ?? const Uuid().v4(),
      odUserId: json['user_id'] as String,
      totalVp: json['total_vp'] as int? ?? 0,
      currentLevel: json['current_level'] as int? ?? 1,
      weekendStreak: json['weekend_streak'] as int? ?? 0,
      lastCheckIn: json['last_check_in'] != null
          ? DateTime.parse(json['last_check_in'] as String)
          : null,
      visitedPlaces:
          (json['visited_places'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': odUserId,
      'total_vp': totalVp,
      'current_level': currentLevel,
      'weekend_streak': weekendStreak,
      'last_check_in': lastCheckIn?.toIso8601String(),
      'visited_places': visitedPlaces,
    };
  }

  VibeProfile copyWith({
    String? id,
    String? odUserId,
    int? totalVp,
    int? currentLevel,
    int? weekendStreak,
    DateTime? lastCheckIn,
    List<String>? visitedPlaces,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VibeProfile(
      id: id ?? this.id,
      odUserId: odUserId ?? this.odUserId,
      totalVp: totalVp ?? this.totalVp,
      currentLevel: currentLevel ?? this.currentLevel,
      weekendStreak: weekendStreak ?? this.weekendStreak,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      visitedPlaces: visitedPlaces ?? this.visitedPlaces,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class LevelInfo {
  final int level;
  final String name;
  final int minVp;
  final int maxVp;
  final String? description;

  const LevelInfo({
    required this.level,
    required this.name,
    required this.minVp,
    required this.maxVp,
    this.description,
  });

  static const List<LevelInfo> levels = [
    LevelInfo(
      level: 1,
      name: 'Newbie',
      minVp: 0,
      maxVp: 99,
      description: 'Just getting started',
    ),
    LevelInfo(
      level: 2,
      name: 'Club Hopper',
      minVp: 100,
      maxVp: 499,
      description: 'You\'re finding your vibe',
    ),
    LevelInfo(
      level: 3,
      name: 'Vibe Master',
      minVp: 500,
      maxVp: 1499,
      description: 'You know the scene',
    ),
    LevelInfo(
      level: 4,
      name: 'Legend',
      minVp: 1500,
      maxVp: 999999,
      description: 'You\'re a nightlife icon',
    ),
  ];

  static LevelInfo getLevelInfo(int level) {
    return levels.firstWhere(
      (l) => level >= l.minVp && (l.maxVp == 999999 || level <= l.maxVp),
      orElse: () => levels.last,
    );
  }

  static int getVpForNextLevel(int currentLevel) {
    if (currentLevel >= 4) return 0;
    return levels.firstWhere((l) => l.level == currentLevel + 1).minVp;
  }

  static double getProgressInCurrentLevel(int vp, int currentLevel) {
    final current = getLevelInfo(currentLevel);
    if (currentLevel >= 4) return 1.0;
    final next = getLevelInfo(currentLevel + 1);
    final progress = (vp - current.minVp) / (next.minVp - current.minVp);
    return progress.clamp(0.0, 1.0);
  }
}
