import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vibe_provider.dart';

class VpDisplay extends ConsumerWidget {
  final bool showStreak;
  final bool showRank;
  final double? fontSize;

  const VpDisplay({
    super.key,
    this.showStreak = true,
    this.showRank = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpData = ref.watch(vpDisplayProvider);

    if (vpData == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt, color: Colors.amber, size: fontSize ?? 20),
        const SizedBox(width: 4),
        Text(
          '${vpData.totalVp} VP',
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        if (showStreak && vpData.streak > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  '${vpData.streak}x',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (showRank && vpData.rank != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${vpData.rank}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class VpDisplayCompact extends ConsumerWidget {
  const VpDisplayCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpData = ref.watch(vpDisplayProvider);

    if (vpData == null) return const SizedBox.shrink();

    return Text(
      '${vpData.totalVp}',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.amber,
      ),
    );
  }
}
