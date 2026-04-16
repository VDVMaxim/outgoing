import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/onboarding/screens/success_screen.dart';
import 'package:flutter_clubapp/features/onboarding/screens/onboarding_screen.dart';

class CreatingScreen extends StatefulWidget {
  final String firstName;
  final bool isAccount;
  final VoidCallback? onSuccess;

  const CreatingScreen({
    super.key,
    required this.firstName,
    this.isAccount = false,
    this.onSuccess,
  });

  @override
  State<CreatingScreen> createState() => _CreatingScreenState();
}

class _CreatingScreenState extends State<CreatingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSuccess();
  }

  Future<void> _navigateToSuccess() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (widget.isAccount) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              firstName: widget.firstName,
              onSuccess: widget.onSuccess,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(isAccountFlow: false),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.creatingTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
