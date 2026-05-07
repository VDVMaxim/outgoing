import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';

class LocationStep implements OnboardingStep {
  final bool isLoading;
  final Function(bool) setLoading;
  final Function(LatLng?) setUserLocation;
  final VoidCallback finishOnboarding;

  LocationStep({
    required this.isLoading,
    required this.setLoading,
    required this.setUserLocation,
    required this.finishOnboarding,
  });

  Future<void> _requestLocationPermission(BuildContext context) async {
    setLoading(true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        final position = await Geolocator.getCurrentPosition();
        setUserLocation(LatLng(position.latitude, position.longitude));
      } catch (e) {
        setUserLocation(null);
      }
    } else {
      setUserLocation(null);
    }

    setLoading(false);
    finishOnboarding();
  }

  void _skipLocation() {
    setUserLocation(null);
    finishOnboarding();
  }

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              onPressed: isLoading
                  ? null
                  : () => _requestLocationPermission(context),
              child: isLoading
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
              onPressed: isLoading ? null : _skipLocation,
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

  @override
  String? validate(BuildContext context) => null;

  @override
  VoidCallback? onNextPressed;

  @override
  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}
