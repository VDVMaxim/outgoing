import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/main.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart'; // Gefixt
import 'package:flutter_clubapp/core/config/app_config.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/core/widgets/vp_display.dart';
import 'package:flutter_clubapp/core/widgets/level_indicator.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/features/auth/screens/login_screen.dart';
import 'package:flutter_clubapp/features/auth/screens/register_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/account_settings_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/faq_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/language_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/push_notifications_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/web_view_screen.dart';
import 'package:flutter_clubapp/features/vibe_system/presentation/screens/vibe_screens.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                Theme.of(context).brightness == Brightness.dark);
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF09090B).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.9),
            elevation: 0,
            title: Text(
               l10n.settingsTitle,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(l10n.settingsAccount),
              _AccountSection(
                isDark: isDark,
                l10n: l10n,
                isAuthenticated: authState.isAuthenticated,
                nickname: authState.nickname,
                email: authState.email,
                displayName: authState.displayName,
                onRefresh: () {
                  ref.read(authProvider.notifier).refresh();
                },
              ),

              const SizedBox(height: 24),

              if (authState.isAuthenticated) ...[
                _buildSectionHeader('Vibe Points & Badges'),
                _buildCard(
                  isDark,
                  Column(
                    children: [
                       const Padding(
                        padding: EdgeInsets.all(12),
                        child: VpDisplay(showStreak: true, showRank: true),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: LevelIndicator(),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.military_tech,
                          color: Colors.amber,
                        ),
                        title: const Text('Badge Vault'),
                        subtitle: const Text('View your collected badges'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BadgeVaultScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.leaderboard,
                          color: Colors.blueAccent,
                        ),
                        title: const Text('Leaderboard'),
                        subtitle: const Text('Squads & Cities rankings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LeaderboardScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.emoji_events,
                          color: Colors.purple,
                        ),
                        title: const Text('Challenges'),
                        subtitle: const Text('Complete Squad challenges'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChallengesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              _buildSectionHeader(l10n.settingsPreferences),
              _buildCard(
                isDark,
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        l10n.settingsDarkMode,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: ShadSwitch(
                        value: isDark,
                        onChanged: (val) {
                          themeNotifier.value = val
                              ? ThemeMode.dark
                              : ThemeMode.light;
                        },
                      ),
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.language,
                      iconColor: Colors.purple,
                      title: l10n.settingsLanguage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.notifications_outlined,
                      iconColor: Colors.blueAccent,
                      title: 'Push Notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PushNotificationsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader(l10n.settingsHelpSupport),
              _buildCard(
                isDark,
                Column(
                  children: [
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.help_outline,
                      iconColor: Colors.blueAccent,
                      title: 'FAQ',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FaqScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader(l10n.settingsFeedback),
              _buildCard(
                isDark,
                Column(
                  children: [
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.bug_report,
                      iconColor: Colors.orange,
                      title: l10n.settingsReportBug,
                      onTap: () => _launchEmail(context),
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.star_outline,
                      iconColor: Colors.amber,
                      title: l10n.settingsRateApp,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('App store link coming soon'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.share_outlined,
                      iconColor: Colors.green,
                      title: l10n.settingsShareApp,
                      onTap: () => _shareApp(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader(l10n.settingsAbout),
              _buildCard(
                isDark,
                Column(
                  children: [
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.info_outline,
                      iconColor: Colors.grey,
                      title: 'Version ${AppConfig.appVersion}',
                      showArrow: false,
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.description_outlined,
                      iconColor: Colors.grey,
                      title: l10n.settingsTerms,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewScreen(
                              title: l10n.settingsTerms,
                              url: AppConfig.termsOfServiceUrl,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    _SettingsListTile(
                      isDark: isDark,
                      icon: Icons.privacy_tip_outlined,
                      iconColor: Colors.grey,
                      title: l10n.settingsPrivacy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewScreen(
                              title: l10n.settingsPrivacy,
                              url: AppConfig.privacyPolicyUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(bool isDark, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'info@clubapp.be',
      queryParameters: {
        'subject': Uri.encodeComponent('Bug Report / Feedback - Club App'),
      },
    );
    try {
      final canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No email app found. Please email us at info@clubapp.be',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  void _shareApp(BuildContext context) {
    Share.share('Check out Club App - https://clubapp.be', subject: 'Club App');
  }
}

class _AccountSection extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final bool isAuthenticated;
  final String? nickname;
  final String? email;
  final String? displayName;
  final VoidCallback? onRefresh;

  const _AccountSection({
    required this.isDark,
    required this.l10n,
    required this.isAuthenticated,
    this.nickname,
    this.email,
    this.displayName,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      isDark,
      Column(
        children: [
          if (isAuthenticated)
            _buildAuthenticatedView(context)
          else
            _buildGuestView(context),
          if (nickname != null) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    nickname!,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
        );
        onRefresh?.call();
      },
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(name: nickname ?? '', size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName ?? nickname ?? l10n.settingsAnonymous,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      email!,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    final profile = UserProfileService.instance;
    final guestNickname = profile.nickname ?? 'Guest';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              UserAvatar(name: guestNickname, size: 64),
              const SizedBox(height: 8),
              Text(
                guestNickname,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sign in to sync your data',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ShadButton.secondary(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          onSuccess: () {
                            Navigator.pop(context);
                            onRefresh?.call();
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                      ),
                    );
                    onRefresh?.call();
                  },
                  child: Text(l10n.settingsLogin),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShadButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          onSuccess: () {
                            Navigator.pop(context);
                            onRefresh?.call();
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                      ),
                    );
                    onRefresh?.call();
                  },
                  child: Text(l10n.loginRegister),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(bool isDark, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final bool showArrow;

  const _SettingsListTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      trailing: showArrow
          ? Icon(Icons.chevron_right, color: Colors.grey[600])
          : null,
      onTap: onTap,
    );
  }
}