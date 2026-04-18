import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/welcome_step.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/squad_mode_step.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/comfort_safety_step.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/intro/voice_matters_step.dart';
import 'package:flutter_clubapp/features/onboarding/screens/option_screen.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Stack with AnimatedBlurBackground behind wizard
    // Following flutter-building-layouts: Stack for overlapping layers
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background layer - allows gradient circles to show through
          const AnimatedBlurBackground(child: SizedBox.expand()),
          // Content layer - wizard on top
          OnboardingWizard(
            steps: [
              WelcomeStep(),
              SquadModeStep(),
              ComfortSafetyStep(),
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
              // Show "Next" on steps 0-2, "Start" on final step
              if (currentStep < totalSteps - 1) {
                return AppLocalizations.of(context)!.onboardingNext;
              }
              return AppLocalizations.of(context)!.onboardingStart;
            },
          ),
        ],
      ),
    );
  }
}
