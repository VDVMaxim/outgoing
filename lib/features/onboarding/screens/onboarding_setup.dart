// lib/features/onboarding/screens/onboarding_setup.dart
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker_with_button.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';
import 'package:flutter_clubapp/features/navigation/screens/main_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';

class OnboardingSetup extends ConsumerStatefulWidget {
  const OnboardingSetup({super.key});

  @override
  ConsumerState<OnboardingSetup> createState() => _OnboardingSetupState();
}

class _OnboardingSetupState extends ConsumerState<OnboardingSetup> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _hasRegistrationCompleted = false;
  bool _isInitialized = false;
  bool _hasNickname = false;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    final profile = ref.read(userProfileServiceProvider);
    if (mounted) {
      setState(() {
        _hasNickname = profile.hasNickname;
        _isInitialized = true;

        if (profile.hasNickname) {
          _nicknameController.text = profile.nickname!;
        }
      });
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final profile = ref.read(userProfileServiceProvider);
    profile.hasCompletedOnboarding = true;
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) =>
              const MainNavigation(userLocation: null),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (route) => false,
      );
    }
  }

  void _onRegistrationComplete() {
    setState(() => _hasRegistrationCompleted = true);
  }

  void _onCompletePressed() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const AnimatedBlurBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final bool skipNickname = _hasNickname;

    final steps = skipNickname
        ? [
            _CompleteWizardStep(
              hasRegistrationCompleted: true,
              onComplete: _onCompletePressed,
            ),
          ]
        : [
            _NicknameWizardStep(
              controller: _nicknameController,
              onRegistrationComplete: _onRegistrationComplete,
            ),
            _CompleteWizardStep(
              hasRegistrationCompleted: _hasRegistrationCompleted,
              onComplete: _onCompletePressed,
            ),
          ];

    return AnimatedBlurBackground(
      child: OnboardingWizard(
        steps: steps,
        onComplete: _finishOnboarding,
        showBackButton: false,
        showProgressIndicator: false,
        swipeable: false,
        showNextButtonForStep: (currentStep, totalSteps) {
          return !skipNickname && currentStep == 0;
        },
        nextButtonText: (context, currentStep, totalSteps) {
          if (!skipNickname && currentStep == 0) return 'Next';
          return '';
        },
      ),
    );
  }
}

class _NicknameWizardStep implements OnboardingStep {
  final TextEditingController controller;
  final VoidCallback onRegistrationComplete;

  _NicknameWizardStep({
    required this.controller,
    required this.onRegistrationComplete,
  });

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    return _NicknameContent(
      controller: controller,
      onRegistrationComplete: onRegistrationComplete,
    );
  }

  @override
  String? validate() {
    final nickname = controller.text.trim();
    if (nickname.isEmpty) {
      return 'Please enter a nickname';
    }
    return null;
  }

  @override
  VoidCallback? onNextPressed;

  @override
  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}

class _NicknameContent extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final VoidCallback onRegistrationComplete;

  const _NicknameContent({
    required this.controller,
    required this.onRegistrationComplete,
  });

  @override
  ConsumerState<_NicknameContent> createState() => _NicknameContentState();
}

class _NicknameContentState extends ConsumerState<_NicknameContent> {
  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final profile = ref.read(userProfileServiceProvider);
    if (profile.hasNickname && mounted) {
      setState(() {
        widget.controller.text = profile.nickname!;
      });
      widget.onRegistrationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NicknamePickerWithButton(
      nicknameController: widget.controller,
      onStateRefresh: () {},
      showGenerateButton: true,
    );
  }
}

class _CompleteWizardStep implements OnboardingStep {
  final bool hasRegistrationCompleted;
  final VoidCallback onComplete;

  _CompleteWizardStep({
    required this.hasRegistrationCompleted,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    return _CompleteContent(
      hasRegistrationCompleted: hasRegistrationCompleted,
      onComplete: onComplete,
    );
  }

  @override
  String? validate() => null;

  @override
  VoidCallback? onNextPressed;

  @override
  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}

class _CompleteContent extends StatelessWidget {
  final bool hasRegistrationCompleted;
  final VoidCallback onComplete;

  const _CompleteContent({
    required this.hasRegistrationCompleted,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (!hasRegistrationCompleted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              l10n.onboardingSettingUp,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingAllSet,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingExploreNearby,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ShadButton(
                onPressed: onComplete,
                child: Text(
                  l10n.onboardingStartExploring,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}