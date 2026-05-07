import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/models/badge.dart' as app_badge;
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class BadgeVaultWidget extends ConsumerWidget {
  final bool compact;
  final bool showLocked;

  const BadgeVaultWidget({
    super.key,
    this.compact = false,
    this.showLocked = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get all badge types to display
    final allBadges = app_badge.BadgeType.values;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) {
      return _buildCompact(allBadges.length, isDark);
    }

    return _buildFull(context, allBadges, isDark, showLocked);
  }

  Widget _buildCompact(int totalCount, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.military_tech, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            '0/$totalCount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(
    BuildContext context,
    List<app_badge.BadgeType> allBadges,
    bool isDark,
    bool showLocked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressHeader(context, allBadges.length, isDark),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.allBadges,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        _buildBadgeGrid(allBadges, isDark, showLocked),
      ],
    );
  }

  Widget _buildProgressHeader(BuildContext context, int totalCount, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.military_tech, color: Colors.amber, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.badgeVaultTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.badgesUnlockedCount(0, totalCount),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(
    List<app_badge.BadgeType> badges,
    bool isDark,
    bool showLocked,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        return _BadgeItemWidget(badgeType: badges[index], isDark: isDark);
      },
    );
  }
}

class _BadgeItemWidget extends StatelessWidget {
  final app_badge.BadgeType badgeType;
  final bool isDark;

  const _BadgeItemWidget({required this.badgeType, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(badgeType.icon),
              color: isDark ? Colors.white24 : Colors.black26,
              size: 24,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badgeType.displayName,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(_getIconData(badgeType.icon), color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                badgeType.displayName,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badgeType.description,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+${badgeType.vpReward} VP',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.settingsCancel,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'nights_stay':
        return Icons.nights_stay;
      case 'home':
        return Icons.home;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'people':
        return Icons.people;
      case 'explore':
        return Icons.explore;
      case 'trending_up':
        return Icons.trending_up;
      case 'group':
        return Icons.group;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'favorite':
        return Icons.favorite;
      case 'military_tech':
        return Icons.military_tech;
      case 'travel_explore':
        return Icons.travel_explore;
      case 'flutter_dash':
        return Icons.flutter_dash;
      case 'pub':
        return Icons.local_bar;
      default:
        return Icons.military_tech;
    }
  }
}
