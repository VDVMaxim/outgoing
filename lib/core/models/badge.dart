import 'package:uuid/uuid.dart';

enum BadgeType {
  lastManStanding,
  localHero,
  earlyBird,
  matchmaker,
  nomad,
  trendsetter,
  noManLeftBehind,
  safetyFirst,
  loyaltyGuardian,
  vibeVeteran,
  explorer,
  socialButterfly,
}

extension BadgeTypeExtension on BadgeType {
  String get displayName {
    switch (this) {
      case BadgeType.lastManStanding:
        return 'Last Man Standing';
      case BadgeType.localHero:
        return 'Local Hero';
      case BadgeType.earlyBird:
        return 'Early Bird';
      case BadgeType.matchmaker:
        return 'Matchmaker';
      case BadgeType.nomad:
        return 'Nomad';
      case BadgeType.trendsetter:
        return 'Trendsetter';
      case BadgeType.noManLeftBehind:
        return 'No Man Left Behind';
      case BadgeType.safetyFirst:
        return 'Safety First';
      case BadgeType.loyaltyGuardian:
        return 'Loyalty Guardian';
      case BadgeType.vibeVeteran:
        return 'Vibe Veteran';
      case BadgeType.explorer:
        return 'Explorer';
      case BadgeType.socialButterfly:
        return 'Social Butterfly';
    }
  }

  String get description {
    switch (this) {
      case BadgeType.lastManStanding:
        return 'Check in after 05:00';
      case BadgeType.localHero:
        return '5x at the same venue in a month';
      case BadgeType.earlyBird:
        return 'First to check in before 23:30';
      case BadgeType.matchmaker:
        return 'Your Squad PIN used 8+ times';
      case BadgeType.nomad:
        return 'Complete a Pub Crawl';
      case BadgeType.trendsetter:
        return 'First to discover a trending venue';
      case BadgeType.noManLeftBehind:
        return 'Stay with your squad until 03:00';
      case BadgeType.safetyFirst:
        return '10x use "I\'m home safe"';
      case BadgeType.loyaltyGuardian:
        return '3 weekend streak';
      case BadgeType.vibeVeteran:
        return 'Reach Legend status';
      case BadgeType.explorer:
        return 'Visit 10 different venues';
      case BadgeType.socialButterfly:
        return 'Invite 5 friends to Squad';
    }
  }

  String get icon {
    switch (this) {
      case BadgeType.lastManStanding:
        return 'nights_stay';
      case BadgeType.localHero:
        return 'home';
      case BadgeType.earlyBird:
        return 'wb_sunny';
      case BadgeType.matchmaker:
        return 'people';
      case BadgeType.nomad:
        return 'explore';
      case BadgeType.trendsetter:
        return 'trending_up';
      case BadgeType.noManLeftBehind:
        return 'group';
      case BadgeType.safetyFirst:
        return 'health_and_safety';
      case BadgeType.loyaltyGuardian:
        return 'favorite';
      case BadgeType.vibeVeteran:
        return 'military_tech';
      case BadgeType.explorer:
        return 'travel_explore';
      case BadgeType.socialButterfly:
        return 'flutter_dash';
    }
  }

  int get vpReward {
    switch (this) {
      case BadgeType.lastManStanding:
        return 50;
      case BadgeType.localHero:
        return 30;
      case BadgeType.earlyBird:
        return 20;
      case BadgeType.matchmaker:
        return 40;
      case BadgeType.nomad:
        return 50;
      case BadgeType.trendsetter:
        return 30;
      case BadgeType.noManLeftBehind:
        return 40;
      case BadgeType.safetyFirst:
        return 25;
      case BadgeType.loyaltyGuardian:
        return 35;
      case BadgeType.vibeVeteran:
        return 100;
      case BadgeType.explorer:
        return 40;
      case BadgeType.socialButterfly:
        return 30;
    }
  }

  BadgeCategory get category {
    switch (this) {
      case BadgeType.lastManStanding:
      case BadgeType.localHero:
      case BadgeType.earlyBird:
      case BadgeType.explorer:
        return BadgeCategory.explorer;
      case BadgeType.matchmaker:
      case BadgeType.nomad:
      case BadgeType.trendsetter:
      case BadgeType.noManLeftBehind:
      case BadgeType.socialButterfly:
        return BadgeCategory.social;
      case BadgeType.safetyFirst:
      case BadgeType.loyaltyGuardian:
        return BadgeCategory.safety;
      case BadgeType.vibeVeteran:
        return BadgeCategory.achievement;
    }
  }

  static BadgeType? fromString(String value) {
    try {
      return BadgeType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum BadgeCategory { explorer, social, safety, achievement }

extension BadgeCategoryExtension on BadgeCategory {
  String get displayName {
    switch (this) {
      case BadgeCategory.explorer:
        return 'Explorer';
      case BadgeCategory.social:
        return 'Social';
      case BadgeCategory.safety:
        return 'Safety';
      case BadgeCategory.achievement:
        return 'Achievement';
    }
  }
}

class Badge {
  final String id;
  final BadgeType type;
  final DateTime? unlockedAt;
  final int xpEarned;

  const Badge({
    required this.id,
    required this.type,
    this.unlockedAt,
    this.xpEarned = 0,
  });

  factory Badge.unlocked(BadgeType type) {
    return Badge(
      id: const Uuid().v4(),
      type: type,
      unlockedAt: DateTime.now(),
      xpEarned: type.vpReward,
    );
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String? ?? const Uuid().v4(),
      type:
          BadgeTypeExtension.fromString(json['badge_type'] as String) ??
          BadgeType.lastManStanding,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'] as String)
          : null,
      xpEarned: json['xp_earned'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge_type': type.name,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'xp_earned': xpEarned,
    };
  }

  bool get isUnlocked => unlockedAt != null;
}

class BadgeVault {
  final List<Badge> badges;
  final BadgeType? featuredBadge;

  const BadgeVault({this.badges = const [], this.featuredBadge});

  List<Badge> get unlockedBadges => badges.where((b) => b.isUnlocked).toList();

  List<Badge> get lockedBadges => badges.where((b) => !b.isUnlocked).toList();

  int get totalBadges => badges.length;
  int get unlockedCount => unlockedBadges.length;

  double get completionPercentage {
    if (badges.isEmpty) return 0.0;
    return unlockedCount / totalBadges;
  }

  bool hasBadge(BadgeType type) {
    return unlockedBadges.any((b) => b.type == type);
  }

  Badge? getBadge(BadgeType type) {
    try {
      return badges.firstWhere((b) => b.type == type);
    } catch (_) {
      return null;
    }
  }

  BadgeVault unlockBadge(BadgeType type) {
    if (hasBadge(type)) return this;

    final newBadge = Badge.unlocked(type);
    return BadgeVault(badges: [...badges, newBadge], featuredBadge: type);
  }

  BadgeVault copyWith({List<Badge>? badges, BadgeType? featuredBadge}) {
    return BadgeVault(
      badges: badges ?? this.badges,
      featuredBadge: featuredBadge,
    );
  }
}
