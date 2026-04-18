import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/services/auth_service.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

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
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsAccount,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.logout,
            iconColor: Colors.orange,
            title: l10n.settingsLogout,
            onTap: () => _showLogoutDialog(context, isDark, l10n),
          ),
          const SizedBox(height: 8),
          _SettingsListTile(
            isDark: isDark,
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: l10n.settingsDelete,
            onTap: () => _showDeleteDialog(context, isDark, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) async {
    final profile = await UserProfileService.getInstance();
    if (!context.mounted) return;

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
  ) async {
    final profile = await UserProfileService.getInstance();
    if (!context.mounted) return;

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
