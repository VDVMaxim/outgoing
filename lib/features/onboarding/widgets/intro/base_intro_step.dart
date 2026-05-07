import 'package:flutter/material.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';

abstract class IntroStep implements OnboardingStep {
  IconData get icon;
  String getTitle(BuildContext context);
  String getDescription(BuildContext context);

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            getTitle(context),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            getDescription(context),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  String? validate(BuildContext context) => null;

  @override
  VoidCallback? onNextPressed;

  @override
  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}
