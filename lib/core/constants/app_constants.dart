// lib/core/constants/app_constants.dart
import 'package:latlong2/latlong.dart';

abstract class AppConstants {
  // Location Fallbacks
  static const LatLng defaultLocation = LatLng(51.0543, 3.7174); // Gent
  
  // Vibe Check Rules
  static const double maxVibeCheckDistanceMeters = 50.0;
  static const int vibeCheckCooldownMinutes = 15;
  
  // Squad Rules
  static const int maxSquadMembers = 10;
  static const int defaultTrackingFrequencySeconds = 5;
  static const int defaultOfflineMultiplier = 4;
}