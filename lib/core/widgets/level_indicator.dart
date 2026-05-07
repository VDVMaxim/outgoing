// lib/core/widgets/level_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/features/vibe/providers/vibe_provider.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

export 'package:flutter_clubapp/features/vibe/providers/vibe_provider.dart' show VibeDisplayData;

class LevelIndicator extends ConsumerWidget {
  final bool showProgress;
  final bool compact;

  const LevelIndicator({
    super.key,
    this.showProgress = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawVpData = ref.watch(vpDisplayProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final vpData = rawVpData ?? VibeDisplayData(
      totalVp: 0,
      level: 1,
      levelName: AppLocalizations.of(context)!.levelNewbie,
      streak: 0,
      progress: 0.0,
      vpForNextLevel: 100,
    );

    final textColor = isDark ? Colors.white : Colors.black87;
    final progressColor = _getLevelColor(vpData.level);

    if (compact) {
      return _buildCompact(context, vpData, progressColor);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildLevelBadge(vpData.level, progressColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _translateLevelName(vpData.level, context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${vpData.totalVp} VP',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (vpData.vpForNextLevel > 0)
                    Text(
                      AppLocalizations.of(context)!.vpToNextLevel(vpData.vpForNextLevel),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (showProgress && vpData.vpForNextLevel > 0) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: vpData.progress,
              backgroundColor: isDark ? Colors.white12 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompact(BuildContext context, VibeDisplayData vpData, Color progressColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: progressColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: vpData.level == 4
              ? Colors.amber
              : progressColor.withValues(alpha: 0.5),
          width: vpData.level == 4 ? 2 : 1,
        ),
        boxShadow: vpData.level == 4
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getLevelIcon(vpData.level), size: 16, color: progressColor),
          const SizedBox(width: 4),
          Text(
            _translateLevelName(vpData.level, context),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(int level, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: level == 4
            ? const LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: level == 4 ? null : color.withValues(alpha: 0.2),
        border: Border.all(color: level == 4 ? Colors.amber : color, width: 2),
        boxShadow: level == 4
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: level == 4 ? Colors.black : color,
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getLevelIcon(int level) {
    switch (level) {
      case 1:
        return Icons.person_outline;
      case 2:
        return Icons.directions_walk;
      case 3:
        return Icons.star;
      case 4:
        return Icons.celebration;
      default:
        return Icons.person_outline;
    }
  }
  String _translateLevelName(int level, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 1:
        return l10n.levelNewbie;
      case 2:
        return l10n.levelClubHopper;
      case 3:
        return l10n.levelVibeMaster;
      case 4:
        return l10n.levelLegend;
      default:
        return l10n.levelNewbie;
    }
  }
}

class StreakIndicator extends ConsumerWidget {
  const StreakIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpData = ref.watch(vpDisplayProvider);

    if (vpData == null || vpData.streak == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context)!.weekendStreakCount(vpData.streak),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}