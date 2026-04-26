import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/settings/screens/settings_screen.dart';
import 'package:flutter_clubapp/features/settings/screens/associations_settings_screen.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          l10n.settingsAccount,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.edit,
            iconColor: Colors.blueAccent,
            title: l10n.settingsChangeNickname,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditNicknameScreen(
                    initialNickname: ref.read(authProvider).nickname ??
                        ref.read(userProfileServiceProvider).nickname,
                    isAuthenticated: true,
                    onSaved: () {
                      ref.read(authProvider.notifier).refresh();
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.shield_outlined,
            iconColor: Colors.purpleAccent,
            title: 'Mijn Verenigingen',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AssociationsSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.logout,
            iconColor: Colors.orange,
            title: l10n.settingsLogout,
            onTap: () => _showLogoutDialog(context, isDark, l10n, ref),
          ),
          const SizedBox(height: 12),
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: l10n.settingsDeleteAccount,
            onTap: () => _showDeleteDialog(context, isDark, l10n, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    WidgetRef ref,
  ) async {
    final profile = ref.read(userProfileServiceProvider);
    final authService = ref.read(authServiceProvider);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        title: Text(l10n.settingsLogoutConfirm, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.settingsCancel),
          ),
          ShadButton(
            onPressed: () async {
              Navigator.pop(c);
              await authService.signOut();
              await profile.syncNicknameFromProfile();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(l10n.settingsYes),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    WidgetRef ref,
  ) async {
    final authService = ref.read(authServiceProvider);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
        title: Text(l10n.settingsDeleteAccountConfirm, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Text(l10n.settingsDeleteAccountWarning, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.settingsCancel),
          ),
          ShadButton.destructive(
            onPressed: () async {
              Navigator.pop(c);
              await authService.deleteAccount();
              if (context.mounted) {
                Navigator.pop(context);
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

  const _SettingsListTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }
}