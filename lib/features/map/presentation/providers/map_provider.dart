import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';

class MapState {
  final bool isLoading;
  final bool hasLocationPermission;
  final Set<String> selectedFilters;
  final String searchQuery;
  final double currentZoom;
  final LatLng? liveUserLocation;
  final double currentHeading;
  final bool isFollowingUser;
  final bool isCompassMode;
  final String? selectedPlaceId;
  final bool isPlacingPin;
  final DateTime pinTargetTime;
  final Map<String, Place> cachedPlaces;

  MapState({
    this.isLoading = true,
    this.hasLocationPermission = false,
    this.selectedFilters = const {},
    this.searchQuery = '',
    this.currentZoom = 14.0,
    this.liveUserLocation,
    this.currentHeading = 0.0,
    this.isFollowingUser = false,
    this.isCompassMode = false,
    this.selectedPlaceId,
    this.isPlacingPin = false,
    required this.pinTargetTime,
    this.cachedPlaces = const {},
  });

  MapState copyWith({
    bool? isLoading,
    bool? hasLocationPermission,
    Set<String>? selectedFilters,
    String? searchQuery,
    double? currentZoom,
    LatLng? liveUserLocation,
    double? currentHeading,
    bool? isFollowingUser,
    bool? isCompassMode,
    String? selectedPlaceId,
    bool? isPlacingPin,
    DateTime? pinTargetTime,
    Map<String, Place>? cachedPlaces,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      currentZoom: currentZoom ?? this.currentZoom,
      liveUserLocation: liveUserLocation ?? this.liveUserLocation,
      currentHeading: currentHeading ?? this.currentHeading,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      isCompassMode: isCompassMode ?? this.isCompassMode,
      selectedPlaceId: selectedPlaceId != null ? (selectedPlaceId == 'clear' ? null : selectedPlaceId) : this.selectedPlaceId,
      isPlacingPin: isPlacingPin ?? this.isPlacingPin,
      pinTargetTime: pinTargetTime ?? this.pinTargetTime,
      cachedPlaces: cachedPlaces ?? this.cachedPlaces,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  Timer? _debounce;
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  LatLng? _lastFetchCenter;
  double? _lastFetchZoom;

  @override
  MapState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _locationSubscription?.cancel();
      _compassSubscription?.cancel();
      _serviceStatusSubscription?.cancel();
    });

    _startCompassTracking();
    _listenToServiceStatus();

    return MapState(
      pinTargetTime: DateTime.now().add(const Duration(minutes: 30)),
    );
  }

  void initLocation(LatLng? initialLocation) {
    if (state.liveUserLocation == null && initialLocation != null) {
      state = state.copyWith(liveUserLocation: initialLocation);
    }
  }

  Future<void> checkInitialPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (state.hasLocationPermission) state = state.copyWith(hasLocationPermission: false);
      return;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      if (!state.hasLocationPermission) {
        state = state.copyWith(hasLocationPermission: true);
        startLocationTracking();
      }
    } else {
      if (state.hasLocationPermission) state = state.copyWith(hasLocationPermission: false);
    }
  }

  void setLocationPermission(bool granted) {
    state = state.copyWith(hasLocationPermission: granted);
    if (granted) startLocationTracking();
  }

  void _listenToServiceStatus() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) {
        checkInitialPermission();
      } else {
        if (state.hasLocationPermission) {
          state = state.copyWith(hasLocationPermission: false);
        }
      }
    });
  }

  Future<void> startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    _locationSubscription?.cancel();
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      state = state.copyWith(liveUserLocation: LatLng(position.latitude, position.longitude));
    });
  }

  void _startCompassTracking() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        state = state.copyWith(currentHeading: event.heading!);
      }
    });
  }

  void fetchPlacesForCurrentBounds(MapCamera camera, {bool clearCache = false}) async {
    final currentCenter = camera.center;
    final currentZoom = camera.zoom;

    if (clearCache) {
      state = state.copyWith(cachedPlaces: {});
      _lastFetchCenter = null;
    } else if (_lastFetchCenter != null && _lastFetchZoom != null) {
      final zoomDiff = (currentZoom - _lastFetchZoom!).abs();
      if (zoomDiff < 1.0) {
        final distanceScrolled = const Distance().as(LengthUnit.Meter, _lastFetchCenter!, currentCenter);
        final bounds = camera.visibleBounds;
        final screenWidthMeters = const Distance().as(LengthUnit.Meter, bounds.southWest, bounds.southEast);
        if (distanceScrolled < (screenWidthMeters * 0.4)) return;
      }
    }

    state = state.copyWith(isLoading: true);
    final bounds = camera.visibleBounds;
    final latDelta = bounds.northEast.latitude - bounds.southWest.latitude;
    final lngDelta = bounds.northEast.longitude - bounds.southWest.longitude;
    final minLat = bounds.southWest.latitude - (latDelta * 0.5);
    final maxLat = bounds.northEast.latitude + (latDelta * 0.5);
    final minLng = bounds.southWest.longitude - (lngDelta * 0.5);
    final maxLng = bounds.northEast.longitude + (lngDelta * 0.5);

    _lastFetchCenter = currentCenter;
    _lastFetchZoom = currentZoom;

    try {
      final places = await ref.read(clubRepositoryProvider).getPlacesInViewport(minLat, minLng, maxLat, maxLng, searchQuery: state.searchQuery);
      final newCache = Map<String, Place>.from(state.cachedPlaces);
      for (final p in places) {
        if (p.hasValidLocation) newCache[p.id] = p;
      }
      state = state.copyWith(cachedPlaces: newCache, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to load places');
    }
  }

  void onCameraMove(MapCamera camera) {
    if (camera.zoom != state.currentZoom) {
      state = state.copyWith(currentZoom: camera.zoom);
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchPlacesForCurrentBounds(camera);
    });
  }

  void setFollowingUser(bool isFollowing) {
    state = state.copyWith(isFollowingUser: isFollowing);
  }

  void toggleMyLocation() {
    if (state.liveUserLocation == null) return;
    
    if (!state.isFollowingUser && !state.isCompassMode) {
      state = state.copyWith(isFollowingUser: true, isCompassMode: false);
    } else if (state.isFollowingUser && !state.isCompassMode) {
      state = state.copyWith(isCompassMode: true);
    } else if (!state.isFollowingUser && state.isCompassMode) {
      state = state.copyWith(isFollowingUser: true);
    } else {
      state = state.copyWith(isCompassMode: false, isFollowingUser: false);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _lastFetchCenter = null;
      state = state.copyWith(cachedPlaces: {});
    });
  }

  void setFilters(Set<String> filters) {
    state = state.copyWith(selectedFilters: filters);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _lastFetchCenter = null;
      state = state.copyWith(cachedPlaces: {});
    });
  }

  void selectPlace(String? placeId) {
    state = state.copyWith(selectedPlaceId: placeId ?? 'clear');
  }

  void setPlacingPin(bool isPlacing) {
    state = state.copyWith(isPlacingPin: isPlacing);
    if (isPlacing) {
      state = state.copyWith(pinTargetTime: DateTime.now().add(const Duration(minutes: 30)));
    }
  }

  void setPinTargetTime(DateTime time) {
    final now = DateTime.now();
    DateTime target = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    state = state.copyWith(pinTargetTime: target);
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(MapNotifier.new);