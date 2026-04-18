import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/features/onboarding/screens/onboarding_setup.dart';
import 'package:flutter_clubapp/features/auth/screens/register_screen.dart';
import 'package:flutter_clubapp/features/auth/screens/login_screen.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.groups,
                  size: 80,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.optionScreenTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _OptionCard(
                  icon: Icons.face,
                  title: l10n.optionScreenAnonymous,
                  description: l10n.optionScreenAnonymousDesc,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingSetup(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _OptionCard(
                  icon: Icons.person_add,
                  title: l10n.optionScreenCreateAccount,
                  description: l10n.optionScreenCreateAccountDesc,
                  isDark: isDark,
                  isPrimary: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          onSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OnboardingSetup(),
                              ),
                            );
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          onSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OnboardingSetup(),
                              ),
                            );
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '${l10n.accountFormAlreadyHave} ',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.accountFormLogin,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;
  final bool isPrimary;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.blueAccent.withValues(alpha: 0.1)
              : (isDark ? Colors.white10 : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? Colors.blueAccent
                : (isDark ? Colors.white10 : Colors.grey[300]!),
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.blueAccent.withValues(alpha: 0.2)
                    : (isDark ? Colors.white10 : Colors.grey[200]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isPrimary
                    ? Colors.blueAccent
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
