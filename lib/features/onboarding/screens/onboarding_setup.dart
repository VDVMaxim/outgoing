import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/core/widgets/permission_rationale_sheet.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker_with_button.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';
import 'package:flutter_clubapp/features/navigation/screens/main_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OnboardingSetup extends StatefulWidget {
  const OnboardingSetup({super.key});

  @override
  State<OnboardingSetup> createState() => _OnboardingSetupState();
}

class _OnboardingSetupState extends State<OnboardingSetup> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;
  bool _hasRegistrationCompleted = false;
  bool _isInitialized = false;
  bool _isAuthenticated = false;
  bool _hasNickname = false;

  @override
  void initState() {
    super.initState();
    _LocationWizardStep._hasShownSheetGlobal = false;
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    final profile = await UserProfileService.getInstance();
    if (mounted) {
      setState(() {
        _isAuthenticated = profile.isAuthenticated;
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

  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isLoading = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    LatLng? userLocation;
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position pos = await Geolocator.getCurrentPosition();
        userLocation = LatLng(pos.latitude, pos.longitude);
      } catch (e) {
        userLocation = null;
      }
    }

    final profile = await UserProfileService.getInstance();
    profile.hasCompletedOnboarding = true;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) =>
              MainNavigation(userLocation: userLocation),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _onRegistrationComplete() {
    setState(() => _hasRegistrationCompleted = true);
  }

  void _onCompletePressed() {
    _finishOnboarding();
  }

  void _onSkipLocation() async {
    final profile = await UserProfileService.getInstance();
    profile.hasCompletedOnboarding = true;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) =>
              const MainNavigation(userLocation: null),
          transitionsBuilder: (context, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
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

    final bool skipNickname = _isAuthenticated && _hasNickname;

    final steps = skipNickname
        ? [
            _LocationWizardStep(
              isLoading: _isLoading,
              setLoading: _setLoading,
              finishOnboarding: _finishOnboarding,
              onSkip: _onSkipLocation,
            ),
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
            _LocationWizardStep(
              isLoading: _isLoading,
              setLoading: _setLoading,
              finishOnboarding: _finishOnboarding,
              onSkip: _onSkipLocation,
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

class _NicknameContent extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onRegistrationComplete;

  const _NicknameContent({
    required this.controller,
    required this.onRegistrationComplete,
  });

  @override
  State<_NicknameContent> createState() => _NicknameContentState();
}

class _NicknameContentState extends State<_NicknameContent> {
  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final profile = await UserProfileService.getInstance();
    if (profile.isAuthenticated && profile.hasNickname && mounted) {
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

class _LocationWizardStep implements OnboardingStep {
  final bool isLoading;
  final Function(bool) setLoading;
  final VoidCallback finishOnboarding;
  final VoidCallback onSkip;

  static bool _hasShownSheetGlobal = false;

  _LocationWizardStep({
    required this.isLoading,
    required this.setLoading,
    required this.finishOnboarding,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    if (!_hasShownSheetGlobal) {
      _hasShownSheetGlobal = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _showLocationSheet(context);
        }
      });
    }

    return const SizedBox.shrink();
  }

  void _showLocationSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    await PermissionRationaleSheet.show(
      context: context,
      icon: Icons.location_on,
      title: l10n.onboardingLocationTitle,
      message: l10n.onboardingLocationDesc,
      primaryButtonText: l10n.onboardingLocationAllow,
      onPrimary: () async {
        setLoading(true);
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
        setLoading(false);
        finishOnboarding();
      },
      onSecondary: onSkip,
    );
    onSkip();
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