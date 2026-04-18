import 'package:flutter/material.dart';
import 'package:flutter_clubapp/features/onboarding/screens/onboarding_setup.dart';

class OnboardingScreen extends StatelessWidget {
  final bool isAccountFlow;

  const OnboardingScreen({super.key, this.isAccountFlow = false});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSetup();
  }
}
