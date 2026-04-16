import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/main.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/services/auth_service.dart';
import 'package:flutter_clubapp/core/config/app_config.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/auth/screens/login_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/faq_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/language_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/push_notifications_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/web_view_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                Theme.of(context).brightness == Brightness.dark);
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
              FutureBuilder<UserProfileService?>(
                future: UserProfileService.getInstance().then((s) => s),
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  if (profile == null) {
                    return const SizedBox.shrink();
                  }
                  return _AccountSection(
                    isDark: isDark,
                    l10n: l10n,
                    profile: profile,
                  );
                },
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

              const SizedBox(height: 24),

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
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@clubapp.be',
      queryParameters: {'subject': 'Bug Report / Feedback - Club App'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _shareApp(BuildContext context) {
    Share.share('Check out Club App - https://clubapp.be', subject: 'Club App');
  }
}

class _AccountSection extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final UserProfileService profile;

  const _AccountSection({
    required this.isDark,
    required this.l10n,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      isDark,
      Column(
        children: [
          ListTile(
            leading: UserAvatar(name: profile.nickname ?? '', size: 48),
            title: Text(
              profile.displayName ?? profile.nickname ?? l10n.settingsAnonymous,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              profile.isAuthenticated
                  ? (profile.email ?? '')
                  : l10n.settingsAnonymous,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: profile.isAuthenticated
                ? IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.grey[600]),
                    onPressed: () {},
                  )
                : null,
          ),
          if (profile.isAuthenticated) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ShadButton.secondary(
                      onPressed: () => _showLogoutDialog(context),
                      child: Text(l10n.settingsLogout),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadButton.destructive(
                      onPressed: () => _showDeleteDialog(context),
                      child: Text(l10n.settingsDelete),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ShadButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        onSuccess: () {
                          Navigator.pop(context);
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
                child: Text(l10n.settingsLogin),
              ),
            ),
          ],
        ],
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        title: Text(
          l10n.settingsLogout,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          l10n.settingsLogoutConfirm,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.settingsCancel),
          ),
          ShadButton(
            onPressed: () async {
              Navigator.pop(c);
              await AuthService().signOut();
              await profile.syncNicknameFromProfile();
            },
            child: Text(l10n.settingsYes),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        title: Text(
          l10n.settingsDeleteAccountConfirm,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          l10n.settingsDeleteAccountWarning,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.settingsCancel),
          ),
          ShadButton.destructive(
            onPressed: () async {
              Navigator.pop(c);
              final result = await AuthService().deleteAccount();
              if (context.mounted) {
                if (result.status == AuthResultStatus.success) {
                  profile.clearProfile();
                  profile.resetOnboarding();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/onboarding', (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.errorMessage ?? 'Error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.settingsDelete),
          ),
        ],
      ),
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
