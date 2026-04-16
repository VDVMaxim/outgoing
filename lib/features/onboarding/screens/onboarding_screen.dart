import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:geolocator/geolocator.dart';
import '../../navigation/screens/main_navigation.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isAccountFlow;

  const OnboardingScreen({super.key, this.isAccountFlow = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isLoading = false;
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingNickname();
  }

  Future<void> _loadExistingNickname() async {
    final profile = await UserProfileService.getInstance();
    if (profile.hasNickname && mounted) {
      setState(() {
        _nicknameController.text = profile.nickname!;
      });
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentStep == 0) {
      final nickname = _nicknameController.text.trim();
      if (nickname.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.onboardingNicknameHint)));
        return;
      }
      _saveNickname(nickname);
    }

    if (_currentStep < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _saveNickname(String nickname) async {
    final profile = await UserProfileService.getInstance();
    profile.nickname = nickname;
  }

  void _generateRandomNickname() async {
    final profile = await UserProfileService.getInstance();
    setState(() {
      _nicknameController.text = profile.generateRandomNickname();
    });
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
        // Fallback or error handling
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

  void _skipLocation() async {
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
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [_buildNicknameStep(isDark), _buildLocationStep(isDark)],
        ),
      ),
    );
  }

  Widget _buildNicknameStep(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
              Icons.person,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboardingNicknameTitle,
            style: ShadTheme.of(context).textTheme.h1.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingNicknameDesc,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Center(
            child: UserAvatar(
              name: _nicknameController.text.isEmpty
                  ? '?'
                  : _nicknameController.text,
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: l10n.onboardingNicknameHint,
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _generateRandomNickname,
            child: Text(
              l10n.onboardingNicknameGenerate,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ShadButton(
              onPressed: _isLoading ? null : _nextStep,
              child: Text(
                l10n.onboardingNext,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLocationStep(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
              Icons.location_on,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboardingLocationTitle,
            style: ShadTheme.of(context).textTheme.h1.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingLocationDesc,
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
            child: ShadButton(
              onPressed: _isLoading ? null : _finishOnboarding,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      l10n.onboardingLocationAllow,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ShadButton.ghost(
              onPressed: _isLoading ? null : _skipLocation,
              child: Text(
                l10n.onboardingLocationSkip,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
