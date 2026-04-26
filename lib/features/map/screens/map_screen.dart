import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/main.dart';
import '../../places/widgets/place_bottom_sheet.dart';
import '../../squad/widgets/squad_bottom_sheet.dart';
import '../../squad/providers/squad_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? userLocation;
  const MapScreen({super.key, this.userLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final Map<String, Place> _cachedPlaces = {};
  bool _isLoading = true;
  final Set<String> _selectedFilters = {};
  String _searchQuery = '';

  double _currentZoom = 14.0;
  LatLng? _liveUserLocation;
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isFollowingUser = false;
  bool _isCompassMode = false;
  Timer? _debounce;
  
  LatLng? _lastFetchCenter;
  double? _lastFetchZoom;

  String? _selectedPlaceId;
  bool _isPlacingPin = false;
  DateTime _pinTargetTime = DateTime.now().add(const Duration(minutes: 30));
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _liveUserLocation = widget.userLocation;
    
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logEvent('opened_map');
    });
    _setupSquadPulse();
    _startLocationTracking();
    _startCompassTracking();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _fabAnimController.dispose();
    super.dispose();
  }

  void _setupSquadPulse() {
    ref.read(squadProvider.notifier).setPositionPulseCallback(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _fetchPlacesForCurrentBounds({MapCamera? camera}) async {
    final currentCamera = camera ?? _mapController.camera;
    final currentCenter = currentCamera.center;
    final currentZoom = currentCamera.zoom;

    if (_lastFetchCenter != null && _lastFetchZoom != null) {
      final zoomDiff = (currentZoom - _lastFetchZoom!).abs();
      if (zoomDiff < 1.0) {
        final distanceScrolled = const Distance().as(LengthUnit.Meter, _lastFetchCenter!, currentCenter);
        final bounds = currentCamera.visibleBounds;
        final screenWidthMeters = const Distance().as(LengthUnit.Meter, bounds.southWest, bounds.southEast);
        if (distanceScrolled < (screenWidthMeters * 0.4)) {
          return;
        }
      }
    }

    setState(() => _isLoading = true);
    final bounds = currentCamera.visibleBounds;
    final latDelta = bounds.northEast.latitude - bounds.southWest.latitude;
    final lngDelta = bounds.northEast.longitude - bounds.southWest.longitude;
    final minLat = bounds.southWest.latitude - (latDelta * 0.5);
    final maxLat = bounds.northEast.latitude + (latDelta * 0.5);
    final minLng = bounds.southWest.longitude - (lngDelta * 0.5);
    final maxLng = bounds.northEast.longitude + (lngDelta * 0.5);

    _lastFetchCenter = currentCenter;
    _lastFetchZoom = currentZoom;

    final places = await ref.read(clubRepositoryProvider).getPlacesInViewport(minLat, minLng, maxLat, maxLng);
    if (mounted) {
      setState(() {
        for (final p in places) {
          if (p.hasValidLocation) {
            _cachedPlaces[p.id] = p;
          }
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      if (mounted) {
        final newLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          _liveUserLocation = newLocation;
        });

        if (_isFollowingUser) {
          _mapController.move(newLocation, _currentZoom);
        }
      }
    });
  }

  void _startCompassTracking() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted && _isCompassMode && event.heading != null) {
        final double mapRotation = 360 - event.heading!;
        _mapController.rotate(mapRotation);
      }
    });
  }

  void _onMyLocationTapped() {
    if (_liveUserLocation == null) return;

    ref.read(analyticsServiceProvider).logEvent('map_recenter_clicked');
    setState(() {
      if (!_isFollowingUser && !_isCompassMode) {
        _isFollowingUser = true;
        _mapController.move(_liveUserLocation!, 15.0);
        _mapController.rotate(0);
      } else if (_isFollowingUser && !_isCompassMode) {
        _isCompassMode = true;
      } else if (!_isFollowingUser && _isCompassMode) {
        _isFollowingUser = true;
        _mapController.move(_liveUserLocation!, 15.0);
      } else {
        _isCompassMode = false;
        _isFollowingUser = false;
        _mapController.rotate(0);
      }
    });
  }

  List<Place> get _filteredPlaces {
    return _cachedPlaces.values.where((place) {
      final matchesSearch = _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (place.eventName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      bool matchesFilter = true;
      if (_selectedFilters.isNotEmpty) {
        if (_selectedFilters.contains('club') && place.type != LocationType.club) {
          matchesFilter = false;
        }
        if (_selectedFilters.contains('event') && place.status != ClubStatus.event) {
          matchesFilter = false;
        }
        if (_selectedFilters.contains('__food__') && place.type != LocationType.food) {
          matchesFilter = false;
        }
      }

      if (_currentZoom < 10.5) {
        final isHot = place.hotnessScore >= 5 || place.isFlashPromoActive || place.status == ClubStatus.event;
        if (!isHot) {
          return false;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> _openDetails(BuildContext context, Place place) async {
    if (_isPlacingPin) return;

    ref.read(analyticsServiceProvider).logEvent('viewed_place_details', parameters: {'place_name': place.name});
    setState(() => _selectedPlaceId = place.id);
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaceBottomSheet(place: place, userLocation: _liveUserLocation ?? widget.userLocation),
    );
    if (mounted) {
      setState(() => _selectedPlaceId = null);
    }
  }

  void _showFilterSheet(BuildContext context, bool isDark) {
    if (_isPlacingPin) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSheetFilterChip('__food__', 'Food & Drinks', isDark, setSheetState),
                      _buildSheetFilterChip('club', 'Clubs', isDark, setSheetState),
                      _buildSheetFilterChip('event', 'Events', isDark, setSheetState),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ShadButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Toepassen'),
                    ),
                  )
                ],
              );
            }
          ),
        );
      }
    );
  }

  Widget _buildSheetFilterChip(String filterKey, String label, bool isDark, StateSetter setSheetState) {
    final isSelected = _selectedFilters.contains(filterKey);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setSheetState(() {
          if (selected) {
            _selectedFilters.add(filterKey);
          } else {
            _selectedFilters.remove(filterKey);
          }
        });
        setState(() {});
      },
      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
      selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
      checkmarkColor: Colors.blueAccent,
      labelStyle: TextStyle(
        color: isSelected 
            ? Colors.blueAccent 
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildAnimatedFab(Widget child, int index) {
    return AnimatedBuilder(
      animation: _fabAnimController,
      builder: (context, child) {
        final double start = index * 0.15;
        final double end = start + 0.5;
        final double t = ((_fabAnimController.value - start) / (end - start)).clamp(0.0, 1.0);
        final curvedValue = Curves.easeInBack.transform(t);
        return Transform.translate(
          offset: Offset(curvedValue * 150, 0),
          child: Opacity(
            opacity: 1.0 - t,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final squadState = ref.watch(squadProvider);
    final settings = ref.watch(settingsServiceProvider);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        final currentIsDark = currentMode == ThemeMode.dark ||
            (currentMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
                
        return Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _liveUserLocation ?? widget.userLocation ?? const LatLng(51.0543, 3.7174),
                  initialZoom: _currentZoom,
                  onMapReady: () {
                    _fetchPlacesForCurrentBounds();
                  },
                  onPositionChanged: (camera, hasGesture) {
                    if (hasGesture && _isFollowingUser) {
                      setState(() {
                        _isFollowingUser = false;
                      });
                    }
                    if (camera.zoom != _currentZoom) {
                      setState(() => _currentZoom = camera.zoom);
                    }
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      _fetchPlacesForCurrentBounds(camera: camera);
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: currentIsDark 
                        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.jouwnaam.flutter_clubapp', 
                  ),
                  MarkerLayer(markers: _buildMarkers(squadState, currentIsDark)),
                ],
              ),
              IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isPlacingPin ? 1.0 : 0.0,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Icon(Icons.push_pin, size: 48, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              if (!_isPlacingPin)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentIsDark 
                              ? const Color(0xFF18181B).withValues(alpha: 0.9) 
                              : Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          cursorColor: currentIsDark ? Colors.white : Colors.black,
                          style: TextStyle(color: currentIsDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            hintText: l10n.activitiesSearchHint,
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.tune, 
                                color: _selectedFilters.isNotEmpty 
                                    ? Colors.blueAccent 
                                    : (currentIsDark ? Colors.white70 : Colors.black87),
                              ),
                              onPressed: () => _showFilterSheet(context, currentIsDark),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isLoading && !_isPlacingPin)
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: currentIsDark ? Colors.black87 : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                bottom: _isPlacingPin ? 16 : -300, 
                left: 16,
                right: 16,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isPlacingPin ? 1.0 : 0.0,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: currentIsDark ? const Color(0xFF18181B) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Stel doeltijd in', 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: currentIsDark ? Colors.white : Colors.black)),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_pinTargetTime),
                              );
                              if (picked != null) {
                                final now = DateTime.now();
                                setState(() {
                                  _pinTargetTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                                  if (_pinTargetTime.isBefore(now)) {
                                    _pinTargetTime = _pinTargetTime.add(const Duration(days: 1));
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3), width: 2),
                              ),
                              child: Text(
                                '${_pinTargetTime.hour.toString().padLeft(2, '0')}:${_pinTargetTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blueAccent, letterSpacing: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ShadButton.ghost(
                                  onPressed: () {
                                    _fabAnimController.reverse();
                                    setState(() => _isPlacingPin = false);
                                  },
                                  child: const Text('Annuleren'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ShadButton(
                                  onPressed: () {
                                    final center = _mapController.camera.center;
                                    ref.read(squadProvider.notifier).createPin(center, _pinTargetTime);
                                    _fabAnimController.reverse();
                                    setState(() => _isPlacingPin = false);
                                  },
                                  child: const Text('Plaats Pin'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
          floatingActionButton: IgnorePointer(
            ignoring: _isPlacingPin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (squadState.isInSquad) ...[
                  _buildAnimatedFab(
                    FloatingActionButton(
                      heroTag: 'place_pin_fab',
                      onPressed: () {
                        _fabAnimController.forward();
                        setState(() {
                          _isPlacingPin = true;
                          _pinTargetTime = DateTime.now().add(const Duration(minutes: 30));
                        });
                      },
                      backgroundColor: currentIsDark ? const Color(0xFF18181B) : Colors.white,
                      child: const Icon(Icons.push_pin, color: Colors.blueAccent),
                    ),
                    0, 
                  ),
                  const SizedBox(height: 12),
                  _buildAnimatedFab(
                    GestureDetector(
                      onTapDown: (_) {
                        if (settings.hapticsEnabled) HapticFeedback.mediumImpact();
                        ref.read(squadProvider.notifier).setMute(false);
                      },
                      onTapUp: (_) {
                        if (settings.hapticsEnabled) HapticFeedback.lightImpact();
                        ref.read(squadProvider.notifier).setMute(true);
                      },
                      onTapCancel: () {
                        if (!squadState.isMuted) {
                          if (settings.hapticsEnabled) HapticFeedback.lightImpact();
                          ref.read(squadProvider.notifier).setMute(true);
                        }
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16), 
                          color: squadState.isMuted ? Colors.redAccent : Colors.green,
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
                          ],
                        ),
                        child: Icon(
                          squadState.isMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    1, 
                  ),
                  const SizedBox(height: 12),
                ],
                if (_liveUserLocation != null) ...[
                  _buildAnimatedFab(
                    FloatingActionButton(
                      heroTag: 'my_location_fab',
                      onPressed: _onMyLocationTapped,
                      backgroundColor: _isCompassMode 
                          ? Colors.blueAccent 
                          : (currentIsDark ? const Color(0xFF18181B) : Colors.white),
                      child: Icon(
                        _isCompassMode ? Icons.explore : (_isFollowingUser ? Icons.my_location : Icons.location_searching), 
                        color: _isCompassMode ? Colors.white : (currentIsDark ? Colors.white : Colors.black)
                      ),
                    ),
                    2, 
                  ),
                  const SizedBox(height: 12),
                ],
                _buildAnimatedFab(
                  FloatingActionButton(
                    heroTag: 'squad_fab',
                    onPressed: () {
                      showSquadSheet(context);
                    },
                    backgroundColor: squadState.isInSquad
                      ? Colors.blueAccent
                        : (currentIsDark ? const Color(0xFF18181B) : Colors.white),
                    child: Icon(
                      Icons.groups,
                      color: squadState.isInSquad
                          ? Colors.white
                          : (currentIsDark ? Colors.white : Colors.black),
                    ),
                  ),
                  3, 
                ),
              ]
            ),
          )
        );
      }
    );
  }

  List<Marker> _buildMarkers(SquadProviderState squadState, bool isDark) {
    final markers = <Marker>[];
    final activePlaces = _filteredPlaces.toList();
    activePlaces.sort((a, b) => a.hotnessScore.compareTo(b.hotnessScore));

    final double scale = (_currentZoom / 15.0).clamp(0.35, 1.15);
    final double baseSize = 54.0 * scale;
    final double iconSize = 26.0 * scale;

    final int discreteZoom = _currentZoom.floor();
    final bool doClustering = _currentZoom < 14.5;
    final double gridSize = doClustering ? 0.004 * math.pow(2, 14 - discreteZoom).toDouble() : 0.0;
    
    final Map<String, List<Place>> clusters = {};
    Place? selectedPlace;
    for (final place in activePlaces) {
      if (place.id == _selectedPlaceId) {
        selectedPlace = place;
        continue; 
      }
      if (doClustering) {
        final int gridX = (place.location.longitude / gridSize).round();
        final int gridY = (place.location.latitude / gridSize).round();
        final String key = '$gridX,$gridY';
        clusters.putIfAbsent(key, () => []).add(place);
      } else {
        clusters[place.id] = [place];
      }
    }

    for (final cluster in clusters.values) {
      if (cluster.length > 1) {
        double sumLat = 0, sumLng = 0;
        bool hasHot = false;
        for (final p in cluster) {
          sumLat += p.location.latitude;
          sumLng += p.location.longitude;
          if (p.hotnessScore >= 5 || p.isFlashPromoActive) hasHot = true;
        }
        final LatLng center = LatLng(sumLat / cluster.length, sumLng / cluster.length);
        final Color clusterColor = hasHot ? Colors.purpleAccent : Colors.blueAccent;
        markers.add(Marker(
          point: center,
          width: 52 * scale,
          height: 52 * scale,
          rotate: true,
          child: GestureDetector(
            onTap: () {
              _mapController.move(center, _currentZoom + 1.5);
            },
            child: Container(
              decoration: BoxDecoration(
                color: clusterColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5 * scale),
                boxShadow: [BoxShadow(color: clusterColor.withValues(alpha: 0.5), blurRadius: 8 * scale)],
              ),
              child: Center(
                child: Text(
                  '${cluster.length}', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18 * scale)
                ),
              ),
            ),
          ),
        ));
      } else {
        final place = cluster.first;
        final isFood = place.type == LocationType.food || place.name.toLowerCase().contains('food');
        final isEvent = place.status == ClubStatus.event;
        final isHot = place.hotnessScore >= 5 || place.isFlashPromoActive || isEvent;
        if (!isHot && _currentZoom < 15.5) {
          final Color dotColor = isFood ? Colors.orange.withValues(alpha: 0.6) : Colors.blueAccent.withValues(alpha: 0.6);
          markers.add(
            Marker(
              point: place.location,
              width: 12,
              height: 12,
              rotate: true,
              child: GestureDetector(
                onTap: () => _openDetails(context, place),
                child: Container(
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 1),
                  ),
                ),
              ),
            )
          );
        } else {
          final IconData pinIcon = isFood ? Icons.fastfood_rounded : (isHot ? Icons.local_fire_department : Icons.nightlife);
          final Color pinColor = isFood ? Colors.orange : (isHot ? Colors.purpleAccent : Colors.blueAccent);
          markers.add(
            Marker(
              point: place.location,
              width: baseSize, 
              height: baseSize,
              rotate: true,
              child: GestureDetector(
                onTap: () => _openDetails(context, place),
                child: Container(
                  decoration: BoxDecoration(
                    color: pinColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5 * scale),
                    boxShadow: [
                      BoxShadow(color: pinColor.withValues(alpha: 0.5), blurRadius: 8 * scale, offset: Offset(0, 3 * scale))
                    ]
                  ),
                  child: Icon(pinIcon, color: Colors.white, size: iconSize),
                ),
              ),
            )
          );
        }
      }
    }

    if (squadState.isInSquad) {
      for (final member in squadState.members) {
        markers.add(
          Marker(
            point: member.position,
            width: 160,
            height: 48,
            rotate: true,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF18181B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: member.isSpeaking ? const Color(0xFF43B581) : (member.isOnline ? Colors.green : Colors.grey), 
                    width: member.isSpeaking ? 3 : 2
                  ),
                  boxShadow: [
                    if (member.isSpeaking)
                      BoxShadow(color: const Color(0xFF43B581).withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 6)
                    else
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))
                  ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: member.isOnline ? Colors.green : Colors.grey, 
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          member.nickname.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        member.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }

      final currentMember = squadState.members.where((m) => m.isCurrentUser).firstOrNull;
      final currentUserId = currentMember?.odmemberId;

      for (final pin in squadState.pins) {
        final joinedMembers = squadState.members.where((m) => pin.joinedUserIds.contains(m.odmemberId)).toList();
        final hasJoined = currentUserId != null && pin.joinedUserIds.contains(currentUserId);
        final timeStr = '${pin.targetTime.toLocal().hour.toString().padLeft(2, '0')}:${pin.targetTime.toLocal().minute.toString().padLeft(2, '0')}';
        final double stackWidth = joinedMembers.isEmpty ? 0 : (joinedMembers.length * 32.0) - ((joinedMembers.length - 1) * 16.0);
        markers.add(Marker(
          point: pin.position,
          width: 300, 
          height: 100,
          rotate: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF18181B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? Colors.white24 : Colors.black87, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(timeStr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                    ),
                    if (joinedMembers.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      SizedBox(
                        width: stackWidth,
                        height: 32,
                        child: Stack(
                          children: List.generate(joinedMembers.length, (i) {
                            final m = joinedMembers[i];
                            return Positioned(
                              left: i * 16.0, 
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: m.isOnline ? Colors.green : Colors.grey,
                                  border: Border.all(color: isDark ? const Color(0xFF18181B) : Colors.white, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    m.nickname.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                    if (!hasJoined && currentUserId != null) ...[
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => ref.read(squadProvider.notifier).joinPin(pin.id),
                        child: const Text('Ik doe mee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueAccent)),
                      ),
                    ],
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -5),
                child: Icon(Icons.arrow_drop_down, size: 40, color: isDark ? Colors.white24 : Colors.black87),
              ),
            ],
          ),
        ));
      }
    }

    if (_liveUserLocation != null && !squadState.isInSquad) {
      markers.add(
        Marker(
          point: _liveUserLocation!,
          width: 24,
          height: 24,
          rotate: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)]
            ),
          ),
        )
      );
    }

    if (selectedPlace != null) {
      final isFood = selectedPlace.type == LocationType.food || selectedPlace.name.toLowerCase().contains('food');
      final isEvent = selectedPlace.status == ClubStatus.event;
      final isHot = selectedPlace.hotnessScore >= 5 || selectedPlace.isFlashPromoActive || isEvent;
      final IconData pinIcon = isFood ? Icons.fastfood_rounded : (isHot ? Icons.local_fire_department : Icons.nightlife);
      final Color pinColor = isFood ? Colors.orange : (isHot ? Colors.purpleAccent : Colors.blueAccent);
      final double selectedSize = 68.0 * scale;
      markers.add(
        Marker(
          point: selectedPlace.location,
          width: selectedSize, 
          height: selectedSize,
          rotate: true,
          child: Container(
            decoration: BoxDecoration(
              color: pinColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4 * scale),
              boxShadow: [
                BoxShadow(color: pinColor, blurRadius: 16 * scale, spreadRadius: 4 * scale) 
              ]
            ),
            child: Icon(pinIcon, color: Colors.white, size: 32 * scale),
          ),
        )
      );
    }
    return markers;
  }
}