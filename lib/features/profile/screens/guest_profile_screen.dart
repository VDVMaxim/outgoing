import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/user_profile_provider.dart';

import '../../auth/screens/login_screen.dart';
import '../../auth/screens/register_screen.dart';

class GuestProfileScreen extends ConsumerWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeProvider);
    final isDark =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? Colors.white : Colors.black87;

    final nickname = ref.watch(userProfileProvider).nickname ?? 'Anoniem';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 100,
                color: isDark ? Colors.white54 : Colors.black38,
              ),
              const SizedBox(height: 24),
              Text(
                'Welkom, $nickname!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.guestSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(l10n.guestLogin),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ShadButton.outline(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(l10n.guestRegister),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
