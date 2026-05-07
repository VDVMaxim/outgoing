import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/providers/follow_provider.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/core/widgets/level_indicator.dart';
import 'package:flutter_clubapp/features/settings/screens/settings_screen.dart';
import 'package:flutter_clubapp/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter_clubapp/features/auth/screens/register_screen.dart';
import 'package:flutter_clubapp/features/auth/screens/login_screen.dart';
import 'package:flutter_clubapp/features/vibe_system/presentation/screens/vibe_screens.dart';
import 'package:flutter_clubapp/features/vibe/providers/vibe_provider.dart';
import 'package:flutter_clubapp/features/associations/providers/association_provider.dart';
import 'package:flutter_clubapp/features/settings/screens/associations_settings_screen.dart';
import 'package:flutter_clubapp/features/profile/screens/connections_screen.dart';
import 'search_users_screen.dart';

class ProfileTabScreen extends ConsumerStatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  ConsumerState<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends ConsumerState<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(associationProvider.notifier).loadData();
    });
  }

  void _navigateToConnections(int initialTab, String userId, String nickname) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConnectionsScreen(
          userId: userId,
          username: nickname,
          initialTabIndex: initialTab,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final authState = ref.watch(authProvider);
    final isAuth = authState.isAuthenticated;
    final profileService = ref.watch(userProfileServiceProvider);

    final userId = authState.userId ?? profileService.authUserId;
    final profileStatsAsync = userId != null ? ref.watch(profileStatsProvider(userId)) : null;

    // Fallback is nu NIET 'Guest' maar de lokaal bewaarde anonieme nickname
    final nickname = isAuth 
        ? (profileStatsAsync?.valueOrNull?.nickname ?? profileService.nickname ?? AppLocalizations.of(context)!.eventsUnknownCrowd) 
        : (profileService.nickname ?? AppLocalizations.of(context)!.settingsAnonymous);
        
    final bio = isAuth ? (profileStatsAsync?.valueOrNull?.bio ?? profileService.bio) : null;
    final followers = profileStatsAsync?.valueOrNull?.followerCount ?? 0;
    final following = profileStatsAsync?.valueOrNull?.followingCount ?? 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nickname,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          if (isAuth)
            IconButton(
              icon: Icon(Icons.search, color: textColor),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchUsersScreen()));
              },
            ),
          IconButton(
            icon: Icon(Icons.settings, color: textColor),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isAuth 
          ? RefreshIndicator(
              onRefresh: () async {
                if (userId != null) ref.invalidate(profileStatsProvider(userId));
                await ref.read(associationProvider.notifier).loadData();
              },
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  UserAvatar(name: nickname, imageUrl: profileService.avatarUrl, size: 80),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (userId != null) _navigateToConnections(0, userId, nickname);
                                          },
                                          child: _buildStatColumn(AppLocalizations.of(context)!.followers, followers.toString(), isDark),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (userId != null) _navigateToConnections(1, userId, nickname);
                                          },
                                          child: _buildStatColumn(AppLocalizations.of(context)!.following, following.toString(), isDark),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (profileService.firstName != null && profileService.firstName!.isNotEmpty)
                                Text(
                                  '${profileService.firstName} ${profileService.lastName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold, 
                                    color: textColor
                                  ),
                                ),
                              if (bio != null && bio.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  bio,
                                  style: TextStyle(
                                    fontSize: 15, 
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ShadButton.outline(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                                  },
                                  child: Text(AppLocalizations.of(context)!.editProfile),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            indicatorColor: Colors.blueAccent,
                            labelColor: Colors.blueAccent,
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.achievements),
                              Tab(text: AppLocalizations.of(context)!.activity),
                              Tab(text: AppLocalizations.of(context)!.circles),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _buildAchievementsTab(isDark),
                      _buildActivityTab(isDark, ref),
                      _buildAssociationsTab(isDark, ref),
                    ],
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    UserAvatar(name: nickname, size: 80),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.star_rounded, size: 48, color: Colors.amber),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.guestWelcomeMessage(nickname),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ShadButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                          },
                          child: Text(AppLocalizations.of(context)!.guestRegister),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ShadButton.secondary(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          },
                          child: Text(AppLocalizations.of(context)!.guestLogin),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatColumn(String label, String count, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : Colors.black
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14, 
            color: isDark ? Colors.white54 : Colors.black54
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const LevelIndicator(),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          isDark: isDark,
          icon: Icons.military_tech,
          iconColor: Colors.amber,
          title: AppLocalizations.of(context)!.badgeVault,
          subtitle: AppLocalizations.of(context)!.badgeVaultSubtitle,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgeVaultScreen())),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          isDark: isDark,
          icon: Icons.leaderboard,
          iconColor: Colors.blueAccent,
          title: AppLocalizations.of(context)!.leaderboard,
          subtitle: AppLocalizations.of(context)!.leaderboardSubtitle,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          isDark: isDark,
          icon: Icons.emoji_events,
          iconColor: Colors.purple,
          title: AppLocalizations.of(context)!.challenges,
          subtitle: AppLocalizations.of(context)!.challengesSubtitle,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen())),
        ),
      ],
    );
  }

  Widget _buildActivityTab(bool isDark, WidgetRef ref) {
    final vibeState = ref.watch(vibeProvider);
    final recentActions = vibeState.value?.recentActions ?? []; 

    if (recentActions.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noRecentActivity,
          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: recentActions.length,
      separatorBuilder: (context, index) => Divider(color: isDark ? Colors.white10 : Colors.black12),
      itemBuilder: (context, index) {
        final action = recentActions[index];
        
        IconData icon = Icons.star;
        Color color = Colors.purple;
        String title = 'Activiteit';

        String actionTypeStr = action.actionType.toString();

        if (actionTypeStr.contains('check_in') || actionTypeStr.contains('checkIn')) {
          icon = Icons.location_on;
          color = Colors.green;
          title = AppLocalizations.of(context)!.checkedIn;
        } else if (actionTypeStr.contains('vibe_update') || actionTypeStr.contains('vibeUpdate')) {
          icon = Icons.local_fire_department;
          color = Colors.orange;
          title = AppLocalizations.of(context)!.vibeUpdatedTitle;
        }

        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          trailing: Text(
            '+${action.vpEarned} VP',
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildAssociationsTab(bool isDark, WidgetRef ref) {
    final assocState = ref.watch(associationProvider);
    final memberships = assocState.value?.userAssociations ?? []; 

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (memberships.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.noAssociations,
                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          )
        else
          ...memberships.map((membership) {
            final assoc = membership.association;
            if (assoc == null) return const SizedBox.shrink();
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    image: assoc.logoUrl != null ? DecorationImage(image: NetworkImage(assoc.logoUrl!), fit: BoxFit.cover) : null,
                  ),
                ),
                title: Text(assoc.name, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                subtitle: Text(membership.role == 'pending' ? AppLocalizations.of(context)!.assocPending : AppLocalizations.of(context)!.assocActive, style: const TextStyle(fontSize: 12)),
              ),
            );
          }),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ShadButton.outline(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AssociationsSettingsScreen()));
            },
            child: Text(AppLocalizations.of(context)!.searchAssociations),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF09090B) : Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}