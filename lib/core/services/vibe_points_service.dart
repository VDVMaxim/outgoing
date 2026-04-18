import '../models/vibe_action.dart';

class VibePointsService {
  static const Map<VibeActionType, int> baseVpRewards = {
    VibeActionType.checkIn: 10,
    VibeActionType.vibeUpdate: 20,
    VibeActionType.squadInvite: 50,
    VibeActionType.earlyBird: 30,
    VibeActionType.explorer: 40,
  };

  static const int earlyBirdCutoffHour = 23;
  static const int earlyBirdCutoffMinute = 30;

  static int calculateVp({
    required VibeActionType actionType,
    required bool isEarlyBird,
    required bool isNewPlace,
    required int currentStreak,
  }) {
    int vp = baseVpRewards[actionType] ?? 10;

    switch (actionType) {
      case VibeActionType.checkIn:
        if (isEarlyBird) {
          vp += baseVpRewards[VibeActionType.earlyBird]!;
        }
        if (isNewPlace) {
          vp += baseVpRewards[VibeActionType.explorer]!;
        }
        break;
      case VibeActionType.vibeUpdate:
        break;
      case VibeActionType.squadInvite:
      case VibeActionType.earlyBird:
      case VibeActionType.explorer:
        break;
    }

    if (currentStreak >= 3) {
      final multiplier = 1.0 + ((currentStreak - 2) * 0.1);
      vp = (vp * multiplier).round();
    }

    return vp;
  }

  static bool isEarlyBird() {
    final now = DateTime.now();
    final cutoff = DateTime(
      now.year,
      now.month,
      now.day,
      earlyBirdCutoffHour,
      earlyBirdCutoffMinute,
    );
    return now.isBefore(cutoff);
  }

  static int calculateLevel(int totalVp) {
    if (totalVp >= 1500) return 4;
    if (totalVp >= 500) return 3;
    if (totalVp >= 100) return 2;
    return 1;
  }

  static int getVpForNextLevel(int currentLevel, int totalVp) {
    switch (currentLevel) {
      case 1:
        return 100 - totalVp;
      case 2:
        return 500 - totalVp;
      case 3:
        return 1500 - totalVp;
      case 4:
        return 0;
      default:
        return 0;
    }
  }

  static double getLevelProgress(int totalVp) {
    final level = calculateLevel(totalVp);
    final levelInfo = LevelInfo.getLevelInfo(level);

    if (level >= 4) return 1.0;

    final nextLevelInfo = LevelInfo.levels.firstWhere(
      (l) => l.level == level + 1,
      orElse: () => levelInfo,
    );

    final progress =
        (totalVp - levelInfo.minVp) / (nextLevelInfo.minVp - levelInfo.minVp);
    return progress.clamp(0.0, 1.0);
  }

  static bool shouldUpdateStreak(DateTime? lastCheckIn) {
    if (lastCheckIn == null) return true;

    final now = DateTime.now();
    final lastCheck = lastCheckIn;

    if (now.difference(lastCheck).inDays > 7) {
      return true;
    }

    final lastCheckDay = lastCheck.weekday;
    final nowDay = now.weekday;

    if (lastCheckDay == DateTime.friday || lastCheckDay == DateTime.saturday) {
      if (nowDay == DateTime.friday || nowDay == DateTime.saturday) {
        return false;
      }
      if (nowDay == DateTime.sunday && now.difference(lastCheck).inDays <= 2) {
        return false;
      }
    }

    return true;
  }

  static int calculateStreak(DateTime? lastCheckIn, int currentStreak) {
    if (lastCheckIn == null) return 1;

    final now = DateTime.now();
    final daysSinceLastCheck = now.difference(lastCheckIn).inDays;

    if (daysSinceLastCheck <= 1) {
      return currentStreak;
    } else if (daysSinceLastCheck <= 7) {
      return currentStreak;
    } else {
      return 1;
    }
  }
}

class LevelInfo {
  final int level;
  final String name;
  final int minVp;
  final int maxVp;

  const LevelInfo({
    required this.level,
    required this.name,
    required this.minVp,
    required this.maxVp,
  });

  static const List<LevelInfo> levels = [
    LevelInfo(level: 1, name: 'Newbie', minVp: 0, maxVp: 99),
    LevelInfo(level: 2, name: 'Club Hopper', minVp: 100, maxVp: 499),
    LevelInfo(level: 3, name: 'Vibe Master', minVp: 500, maxVp: 1499),
    LevelInfo(level: 4, name: 'Legend', minVp: 1500, maxVp: 999999),
  ];

  static LevelInfo getLevelInfo(int level) {
    return levels.firstWhere(
      (l) => level >= l.minVp && (l.maxVp == 999999 || level <= l.maxVp),
      orElse: () => levels.last,
    );
  }
}
