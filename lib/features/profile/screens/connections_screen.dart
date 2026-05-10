import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/follow_provider.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/user_profile_provider.dart';

import 'package:flutter_clubapp/features/profile/domain/models/user_profile.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/profile/screens/public_profile_screen.dart';

class ConnectionsScreen extends ConsumerStatefulWidget {
  final String userId;
  final String username;
  final int initialTabIndex;

  const ConnectionsScreen({
    super.key,
    required this.userId,
    required this.username,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends ConsumerState<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _unfollow(String targetUserId) async {
    final currentUserId = ref.read(userProfileProvider).authUserId;
    if (currentUserId == null) return;
    await ref
        .read(followControllerProvider.notifier)
        .unfollowUser(targetUserId, currentUserId);
  }

  Future<void> _removeFollower(String followerId) async {
    final currentUserId = ref.read(userProfileProvider).authUserId;
    if (currentUserId == null) return;
    await ref
        .read(followControllerProvider.notifier)
        .removeFollower(followerId, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final followersAsync = ref.watch(followersProvider(widget.userId));
    final followingAsync = ref.watch(followingProvider(widget.userId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.followers),
            Tab(text: AppLocalizations.of(context)!.following),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          followersAsync.when(
            data: (users) => _buildUserList(users, true, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
              child: Text(AppLocalizations.of(context)!.errorLoadingFollowers),
            ),
          ),
          followingAsync.when(
            data: (users) => _buildUserList(users, false, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
              child: Text(AppLocalizations.of(context)!.errorLoadingFollowing),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(
    List<UserProfile> users,
    bool isFollowersTab,
    bool isDark,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          isFollowersTab
              ? AppLocalizations.of(context)!.noFollowers
              : AppLocalizations.of(context)!.followingNone,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    final currentUserId = ref.read(userProfileProvider).authUserId;
    final isMyProfile = widget.userId == currentUserId;
    final isProcessing = ref.watch(followControllerProvider).isLoading;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PublicProfileScreen(userId: user.id),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: UserAvatar(
            name: user.nickname,
            imageUrl: user.avatarUrl,
            size: 40,
          ),
          title: Text(
            user.nickname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          trailing: isMyProfile
              ? OutlinedButton(
                  onPressed: isProcessing
                      ? null
                      : () {
                          isFollowersTab
                              ? _removeFollower(user.id)
                              : _unfollow(user.id);
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isFollowersTab
                        ? AppLocalizations.of(context)!.remove
                        : AppLocalizations.of(context)!.unfollow,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
