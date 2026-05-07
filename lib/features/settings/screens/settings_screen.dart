import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/config/app_config.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker_with_button.dart';
import 'package:flutter_clubapp/core/services/auth_service.dart';
import 'package:flutter_clubapp/features/settings/screens/faq_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/language_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/push_notifications_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/web_view_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);
    final authNotifier = ref.read(authProvider.notifier);

    await authService.signOut();
    authNotifier.refresh();
    
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteAccountConfirm),
        content: Text(l10n.settingsDeleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.settingsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.settingsDeleteAccount, 
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authService = ref.read(authServiceProvider);
      final authNotifier = ref.read(authProvider.notifier);

      final result = await authService.deleteAccount();
      
      if (result.status == AuthResultStatus.success) {
        authNotifier.refresh();
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? l10n.errorDeleteAccount),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);
    final l10n = AppLocalizations.of(context)!;
    final isAuth = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
          if (isAuth) ...[
            _buildSectionHeader(l10n.settingsAccount),
            _buildCard(
              isDark,
              Column(
                children: [
                  _SettingsListTile(
                    isDark: isDark,
                    icon: Icons.logout,
                    iconColor: Colors.orange,
                    title: l10n.settingsLogout,
                    showArrow: false,
                    onTap: () => _logout(context, ref),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  _SettingsListTile(
                    isDark: isDark,
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    title: l10n.settingsDeleteAccount,
                    showArrow: false,
                    textColor: Colors.red,
                    onTap: () => _deleteAccount(context, ref),
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
                    key: const ValueKey('darkmode_switch'),
                    value: isDark,
                    onChanged: (val) {
                      ref.read(themeProvider.notifier).setDarkMode(val);
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                ListTile(
                  leading: const Icon(
                    Icons.vibration,
                    color: Colors.orangeAccent,
                  ),
                  title: Text(
                    l10n.settingsHaptics,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: ShadSwitch(
                    key: const ValueKey('haptics_switch'),
                    value: ref.watch(settingsProvider).hapticsEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).setHapticsEnabled(val);
                      if (val) HapticFeedback.mediumImpact();
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
                  title: l10n.settingsPushNotifs,
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
                      SnackBar(
                        content: Text(l10n.settingsRateAppSoon),
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
                  title: l10n.settingsVersion(AppConfig.appVersion),
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
    final l10n = AppLocalizations.of(context)!;
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
            SnackBar(
              content: Text(
                l10n.errorNoEmailApp,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorEmailGeneric)),
        );
      }
    }
  }

  void _shareApp(BuildContext context) {
    Share.share('Check out Club App - https://clubapp.be', subject: 'Club App');
  }
}

class _SettingsListTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final bool showArrow;
  final Color? textColor;

  const _SettingsListTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
    this.showArrow = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? (isDark ? Colors.white : Colors.black)),
      ),
      trailing: showArrow
          ? Icon(Icons.chevron_right, color: Colors.grey[600])
          : null,
      onTap: onTap,
    );
  }
}

class EditNicknameScreen extends ConsumerStatefulWidget {
  final String? initialNickname;
  final bool isAuthenticated;
  final VoidCallback onSaved;

  const EditNicknameScreen({
    super.key,
    this.initialNickname,
    required this.isAuthenticated,
    required this.onSaved,
  });

  @override
  ConsumerState<EditNicknameScreen> createState() => _EditNicknameScreenState();
}

class _EditNicknameScreenState extends ConsumerState<EditNicknameScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty && newName.length >= 3) {
      final profile = ref.read(userProfileServiceProvider);
      profile.nickname = newName;
      if (widget.isAuthenticated) {
        await profile.syncNicknameToProfile();
      }
      widget.onSaved();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsChangeNickname,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NicknamePickerWithButton(
                nicknameController: _controller,
                onStateRefresh: () => setState(() {}),
                showGenerateButton: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ShadButton(
                  onPressed: _controller.text.trim().length >= 3 ? _handleSave : null,
                  child: Text(
                    l10n.settingsSave,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}