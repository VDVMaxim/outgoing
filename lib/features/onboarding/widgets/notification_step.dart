import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';

class NotificationStep implements OnboardingStep {
  final GlobalKey<OnboardingWizardState> wizardKey;

  NotificationStep({required this.wizardKey});

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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            AppLocalizations.of(context)!.notifStepTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.notifStepDesc,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            // We use Consumer to read the pushNotificationServiceProvider
            child: Consumer(
              builder: (context, ref, child) {
                return ShadButton(
                  onPressed: () async {
                    // Call the abstraction, not OneSignal directly
                    await ref.read(pushNotificationServiceProvider).requestPermission();
                    
                    // Go to the next screen after they answer the prompt
                    wizardKey.currentState?.goToNextPage();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.notifStepEnable,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ShadButton.ghost(
              onPressed: () {
                wizardKey.currentState?.goToNextPage();
              },
              child: Text(
                AppLocalizations.of(context)!.notifStepLater,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
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