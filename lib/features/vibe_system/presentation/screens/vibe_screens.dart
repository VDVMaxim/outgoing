import 'package:flutter/material.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/core/widgets/badge_vault.dart';
import 'package:flutter_clubapp/core/widgets/level_indicator.dart';
import 'package:flutter_clubapp/core/widgets/vp_display.dart';

class BadgeVaultScreen extends StatelessWidget {
  const BadgeVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Badge Vault',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VpDisplay(showStreak: true, showRank: true),
                const SizedBox(height: 16),
                const LevelIndicator(),
                const SizedBox(height: 24),
                const BadgeVaultWidget(compact: false, showLocked: true),
                const SizedBox(height: 24),
                _buildQuickStats(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatRow(Icons.explore, 'Explorer Badges', '0/4', isDark),
          _buildStatRow(Icons.people, 'Social Badges', '0/5', isDark),
          _buildStatRow(
            Icons.health_and_safety,
            'Safety Badges',
            '0/2',
            isDark,
          ),
          _buildStatRow(Icons.military_tech, 'Achievements', '0/2', isDark),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Leaderboard',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
            tabs: const [
              Tab(text: 'Squads'),
              Tab(text: 'Cities'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSquadLeaderboard(isDark),
            _buildCityLeaderboard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadLeaderboard(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final isCurrentUser = index == 2;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.amber.withValues(alpha: 0.2)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(12),
            border: isCurrentUser
                ? Border.all(color: Colors.amber, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index == 0
                          ? '👑 Squad Alpha'
                          : index == 1
                          ? '🔥 The Night Owls'
                          : index == 2
                          ? '⭐ Your Squad'
                          : 'Squad ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      '${(10 - index) * 1500} VP',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bolt, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${(10 - index) * 1500}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCityLeaderboard(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  index == 0
                      ? '🏆 Amsterdam'
                      : index == 1
                      ? '🔥 Utrecht'
                      : index == 2
                      ? '📍 Rotterdam'
                      : 'City ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.people, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 4),
              Text(
                '${(10 - index) * 50}',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Squad Challenges',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildChallengeCard(
                'The Pub Crawl',
                'Check in at 3 different venues with your Squad in one night',
                Icons.local_bar,
                0,
                3,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildChallengeCard(
                'No Man Left Behind',
                'Stay within 50m of your Squad until 03:00',
                Icons.group,
                0,
                1,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildChallengeCard(
                'Trendsetters',
                'Be the first Squad to check in at a trending venue',
                Icons.trending_up,
                0,
                1,
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(
    String title,
    String description,
    IconData icon,
    int current,
    int required,
    bool isDark,
  ) {
    final progress = current / required;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      description,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.purple,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                current < required ? 'In Progress' : 'Completed!',
                style: TextStyle(
                  color: current >= required ? Colors.green : Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$current/$required locations',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    title == 'The Pub Crawl'
                        ? '+100 VP'
                        : title == 'No Man Left Behind'
                        ? '+75 VP'
                        : '+50 VP',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
