import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/config/app_config.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/navigation/screens/main_navigation.dart';

class OnboardingSetup extends StatefulWidget {
  const OnboardingSetup({super.key});

  @override
  State<OnboardingSetup> createState() => _OnboardingSetupState();
}

class _OnboardingSetupState extends State<OnboardingSetup> {
  static const int _totalSteps = 3;
  int _currentStep = 0;
  bool _isLoading = false;

  final PageController _pageController = PageController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _hasCompletedRegistration = false;

  @override
  void initState() {
    super.initState();
    _loadExistingNickname();
  }

  Future<void> _loadExistingNickname() async {
    final profile = await UserProfileService.getInstance();
    if (profile.isAuthenticated && profile.hasNickname) {
      if (mounted) {
        setState(() {
          _nicknameController.text = profile.nickname!;
        });
        _pageController.jumpToPage(1);
      }
    } else if (profile.hasNickname && mounted) {
      setState(() {
        _nicknameController.text = profile.nickname!;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      final nickname = _nicknameController.text.trim();
      if (nickname.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a nickname')),
        );
        return;
      }
      _saveNickname(nickname);
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
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

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    await _finishOnboarding(
      hasLocation:
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always,
    );
  }

  Future<void> _finishOnboarding({
    bool skipLocation = false,
    bool hasLocation = false,
  }) async {
    LatLng? userLocation;

    if (hasLocation && !skipLocation) {
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

  void _onRegistrationComplete() {
    setState(() {
      _hasCompletedRegistration = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: _previousStep,
              )
            : null,
        title: Text(
          'Setup',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNicknameStep(isDark),
            _buildLocationStep(isDark),
            _buildCompleteStep(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNicknameStep(bool isDark) {
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
            'What\'s your name?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a nickname so your squad mates know who you are.',
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
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: 'Your nickname...',
                border: InputBorder.none,
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
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _generateRandomNickname,
            child: const Text(
              'Generate random nickname',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ShadButton(
              onPressed: _isLoading ? null : _nextStep,
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLocationStep(bool isDark) {
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
            'Discover the Vibe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppConfig.locationPermissionMessage,
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
              onPressed: _isLoading ? null : _requestLocationPermission,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'Allow Location',
                      style: TextStyle(
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
              onPressed: _isLoading
                  ? null
                  : () => _finishOnboarding(skipLocation: true),
              child: const Text(
                'Maybe Later',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteStep(bool isDark) {
    if (!_hasCompletedRegistration) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Setting up your account...',
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
            'You\'re all set!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Let\'s explore what\'s happening nearby.',
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
                onPressed: () => _finishOnboarding(hasLocation: true),
                child: const Text(
                  'Start Exploring',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
