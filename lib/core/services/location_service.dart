import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

enum LocationPermissionStatus {
  denied,
  deniedForever,
  whileInUse,
  always,
  unknown,
}

class LocationService {
  StreamSubscription<Position>? _positionSubscription;
  Function(Position)? _onPositionUpdate;

  LocationService();

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermissionStatus> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    return _mapPermission(permission);
  }

  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return _mapPermission(permission);
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case LocationPermission.always:
        return LocationPermissionStatus.always;
      default:
        return LocationPermissionStatus.unknown;
    }
  }

  Future<bool> requestLocationService() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await Geolocator.openLocationSettings();
    }
    return serviceEnabled;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }

  Future<bool> _checkAndRequestPermission() async {
    var status = await checkPermission();
    if (status == LocationPermissionStatus.unknown ||
        status == LocationPermissionStatus.denied) {
      status = await requestPermission();
    }

    return status == LocationPermissionStatus.always ||
        status == LocationPermissionStatus.whileInUse;
  }

  void startTracking({
    required int intervalSeconds,
    required Function(Position) onPositionUpdate,
  }) {
    stopTracking();
    _onPositionUpdate = onPositionUpdate;

    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      // FIX: Dit houdt Android wakker op de achtergrond!
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 2),
        // Deze notificatie is VERPLICHT voor achtergrondgebruik op Android
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Squad Mode is actief op de achtergrond",
          notificationTitle: "Club App",
          enableWakeLock: true, // Houdt de CPU wakker voor WebRTC audio!
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        pauseLocationUpdatesAutomatically: false,
        // Dit houdt iOS wakker
        activityType: ActivityType.fitness,
        allowBackgroundLocationUpdates: true, 
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
    }

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) {
            _onPositionUpdate?.call(position);
          },
          onError: (error) {
            debugPrint('Location stream error: $error');
          },
        );
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _onPositionUpdate = null;
  }

  bool get isTracking => _positionSubscription != null;

  void dispose() {
    stopTracking();
  }

  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}