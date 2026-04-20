// lib/features/onboarding/screens/onboarding_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/welcome_step.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/squad_mode_step.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/voice_matters_step.dart';
import 'package:flutter_clubapp/features/onboarding/screens/option_screen.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AnimatedBlurBackground(child: SizedBox.expand()),
          OnboardingWizard(
            steps: [
              WelcomeStep(),
              SquadModeStep(),
              VoiceMattersStep(),
            ],
            onComplete: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OptionScreen()),
              );
            },
            showBackButton: false,
            showNextButton: true,
            nextButtonText: (context, currentStep, totalSteps) {
              if (currentStep < totalSteps - 1) {
                return l10n.onboardingNext;
              }
              return l10n.onboardingStart;
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OptionScreen()),
                );
              },
              child: Text(
                l10n.onboardingSkip,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}