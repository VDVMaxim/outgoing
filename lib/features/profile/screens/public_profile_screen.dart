import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/providers/follow_provider.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicProfileScreen({super.key, required this.userId});

  Future<void> _toggleFollow(BuildContext context, WidgetRef ref, bool isFollowing) async {
    final currentUserId = ref.read(userProfileServiceProvider).authUserId;
    if (currentUserId == null) return;

    if (isFollowing) {
      await ref.read(followControllerProvider.notifier).unfollowUser(userId, currentUserId);
    } else {
      await ref.read(followControllerProvider.notifier).followUser(userId, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStatsProvider(userId));
    final isMyProfile = ref.read(userProfileServiceProvider).authUserId == userId;
    final isProcessing = ref.watch(followControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: profileAsync.when(
          data: (profile) => Text(
            profile?.nickname ?? AppLocalizations.of(context)!.navProfile,
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
          ),
          loading: () => const Text(''),
          error: (_, _) => Text(AppLocalizations.of(context)!.error),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(AppLocalizations.of(context)!.errorLoadingProfile)),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(AppLocalizations.of(context)!.userNotFound, style: const TextStyle(color: Colors.grey)));
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  UserAvatar(name: profile.nickname, imageUrl: profile.avatarUrl, size: 80),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(AppLocalizations.of(context)!.followers, profile.followerCount.toString(), isDark),
                        _buildStatColumn(AppLocalizations.of(context)!.following, profile.followingCount.toString(), isDark),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                Text(
                  profile.bio!,
                  style: TextStyle(
                    fontSize: 15, 
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (!isMyProfile)
                SizedBox(
                  width: double.infinity,
                  child: profile.isFollowing
                      ? ShadButton.outline(
                          onPressed: isProcessing ? null : () => _toggleFollow(context, ref, true),
                          child: isProcessing 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(AppLocalizations.of(context)!.unfollow),
                        )
                      : ShadButton(
                          onPressed: isProcessing ? null : () => _toggleFollow(context, ref, false),
                          child: isProcessing 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(AppLocalizations.of(context)!.follow),
                        ),
                ),
            ],
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