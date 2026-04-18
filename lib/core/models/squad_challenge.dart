import 'package:uuid/uuid.dart';

enum SquadChallengeType { pubCrawl, noManLeftBehind, trendsetters }

extension SquadChallengeTypeExtension on SquadChallengeType {
  String get displayName {
    switch (this) {
      case SquadChallengeType.pubCrawl:
        return 'The Pub Crawl';
      case SquadChallengeType.noManLeftBehind:
        return 'No Man Left Behind';
      case SquadChallengeType.trendsetters:
        return 'Trendsetters';
    }
  }

  String get description {
    switch (this) {
      case SquadChallengeType.pubCrawl:
        return 'Check in at 3 different venues with your Squad in one night';
      case SquadChallengeType.noManLeftBehind:
        return 'Stay within 50m of your Squad until 03:00';
      case SquadChallengeType.trendsetters:
        return 'Be the first Squad to check in at a trending venue';
    }
  }

  String get icon {
    switch (this) {
      case SquadChallengeType.pubCrawl:
        return 'pub';
      case SquadChallengeType.noManLeftBehind:
        return 'group';
      case SquadChallengeType.trendsetters:
        return 'trending_up';
    }
  }

  int get vpReward {
    switch (this) {
      case SquadChallengeType.pubCrawl:
        return 100;
      case SquadChallengeType.noManLeftBehind:
        return 75;
      case SquadChallengeType.trendsetters:
        return 50;
    }
  }

  int get requiredLocations {
    switch (this) {
      case SquadChallengeType.pubCrawl:
        return 3;
      case SquadChallengeType.noManLeftBehind:
      case SquadChallengeType.trendsetters:
        return 1;
    }
  }

  static SquadChallengeType? fromString(String value) {
    try {
      return SquadChallengeType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum ChallengeStatus { available, inProgress, completed, failed }

class SquadChallenge {
  final String id;
  final String squadId;
  final SquadChallengeType type;
  final DateTime startedAt;
  final DateTime? completedAt;
  final ChallengeStatus status;
  final List<String> checkInLocations;
  final int currentProgress;

  const SquadChallenge({
    required this.id,
    required this.squadId,
    required this.type,
    required this.startedAt,
    this.completedAt,
    this.status = ChallengeStatus.available,
    this.checkInLocations = const [],
    this.currentProgress = 0,
  });

  factory SquadChallenge.startNew(String squadId, SquadChallengeType type) {
    return SquadChallenge(
      id: const Uuid().v4(),
      squadId: squadId,
      type: type,
      startedAt: DateTime.now(),
      status: ChallengeStatus.inProgress,
    );
  }

  factory SquadChallenge.fromJson(Map<String, dynamic> json) {
    return SquadChallenge(
      id: json['id'] as String? ?? const Uuid().v4(),
      squadId: json['squad_id'] as String,
      type:
          SquadChallengeTypeExtension.fromString(
            json['challenge_type'] as String,
          ) ??
          SquadChallengeType.pubCrawl,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      status: ChallengeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChallengeStatus.available,
      ),
      checkInLocations:
          (json['check_in_locations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      currentProgress: json['current_progress'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'challenge_type': type.name,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'status': status.name,
      'check_in_locations': checkInLocations,
      'current_progress': currentProgress,
    };
  }

  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isFailed => status == ChallengeStatus.failed;
  bool get isInProgress => status == ChallengeStatus.inProgress;
  bool get isAvailable => status == ChallengeStatus.available;

  int get requiredProgress {
    switch (type) {
      case SquadChallengeType.pubCrawl:
        return 3;
      case SquadChallengeType.noManLeftBehind:
      case SquadChallengeType.trendsetters:
        return 1;
    }
  }

  double get progressPercentage {
    if (requiredProgress == 0) return 0.0;
    return currentProgress / requiredProgress;
  }

  SquadChallenge addCheckIn(String locationId) {
    if (isCompleted || isFailed) return this;

    final newLocations = [...checkInLocations, locationId];
    final newProgress = newLocations.length;

    final newStatus = newProgress >= requiredProgress
        ? ChallengeStatus.completed
        : ChallengeStatus.inProgress;

    return SquadChallenge(
      id: id,
      squadId: squadId,
      type: type,
      startedAt: startedAt,
      completedAt: newStatus == ChallengeStatus.completed
          ? DateTime.now()
          : null,
      status: newStatus,
      checkInLocations: newLocations,
      currentProgress: newProgress,
    );
  }

  SquadChallenge fail() {
    return SquadChallenge(
      id: id,
      squadId: squadId,
      type: type,
      startedAt: startedAt,
      completedAt: DateTime.now(),
      status: ChallengeStatus.failed,
      checkInLocations: checkInLocations,
      currentProgress: currentProgress,
    );
  }
}

class ActiveChallenges {
  final List<SquadChallenge> challenges;

  const ActiveChallenges({this.challenges = const []});

  List<SquadChallenge> get available =>
      challenges.where((c) => c.isAvailable).toList();

  List<SquadChallenge> get inProgress =>
      challenges.where((c) => c.isInProgress).toList();

  List<SquadChallenge> get completed =>
      challenges.where((c) => c.isCompleted).toList();

  SquadChallenge? getChallenge(SquadChallengeType type) {
    try {
      return challenges.firstWhere((c) => c.type == type);
    } catch (_) {
      return null;
    }
  }

  bool hasActiveChallenge(SquadChallengeType type) {
    return inProgress.any((c) => c.type == type);
  }

  ActiveChallenges addChallenge(SquadChallenge challenge) {
    return ActiveChallenges(challenges: [...challenges, challenge]);
  }

  ActiveChallenges updateChallenge(SquadChallenge updated) {
    return ActiveChallenges(
      challenges: challenges.map((c) {
        return c.id == updated.id ? updated : c;
      }).toList(),
    );
  }

  int get totalVpEarned {
    return completed.fold(0, (sum, c) => sum + c.type.vpReward);
  }
}
