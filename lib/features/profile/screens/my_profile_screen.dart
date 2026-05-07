import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/providers/follow_provider.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/settings/screens/settings_screen.dart';
import 'package:flutter_clubapp/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter_clubapp/features/profile/screens/connections_screen.dart';
import 'search_users_screen.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  void _navigateToConnections(BuildContext context, WidgetRef ref, int initialTab, String userId, String nickname) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileService = ref.watch(userProfileServiceProvider);
    final userId = ref.watch(authProvider).userId ?? profileService.authUserId;

    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profileStatsAsync = ref.watch(profileStatsProvider(userId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          profileService.nickname ?? AppLocalizations.of(context)!.navProfile,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchUsersScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileStatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(AppLocalizations.of(context)!.errorLoadingProfile)),
        data: (profileStats) {
          final nickname = profileStats?.nickname ?? profileService.nickname ?? AppLocalizations.of(context)!.eventsUnknownCrowd;
          final bio = profileStats?.bio ?? profileService.bio;
          final followers = profileStats?.followerCount ?? 0;
          final following = profileStats?.followingCount ?? 0;

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(profileStatsProvider(userId)),
            child: ListView(
              padding: const EdgeInsets.all(24),
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
                            onTap: () => _navigateToConnections(context, ref, 0, userId, nickname),
                            child: _buildStatColumn(AppLocalizations.of(context)!.followers, followers.toString(), isDark),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToConnections(context, ref, 1, userId, nickname),
                            child: _buildStatColumn(AppLocalizations.of(context)!.following, following.toString(), isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (profileService.firstName != null)
                  Text(
                    '${profileService.firstName} ${profileService.lastName ?? ''}',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white : Colors.black
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
          );
        },
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
}