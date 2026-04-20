import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // VOOR DE HAPTICS
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
import '../../clubs/widgets/club_bottom_sheet.dart';
import '../../squad/widgets/squad_bottom_sheet.dart';
import '../../squad/providers/squad_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? userLocation;
  const MapScreen({super.key, this.userLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  List<Place> _allPlaces = [];
  bool _isLoading = true;

  final Set<String> _selectedFilters = {};
  String _searchQuery = '';

  double _currentZoom = 14.0;
  LatLng? _liveUserLocation;
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  
  bool _isFollowingUser = false; 
  bool _isCompassMode = false;

  @override
  void initState() {
    super.initState();
    _liveUserLocation = widget.userLocation;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logEvent('opened_map');
    });

    _loadPlaces();
    _setupSquadPulse();
    _startLocationTracking();
    _startCompassTracking();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  void _setupSquadPulse() {
    ref.read(squadProvider.notifier).setPositionPulseCallback(() {
      if (mounted) setState(() {}); 
    });
  }

  Future<void> _loadPlaces() async {
    final places = await ref.read(clubRepositoryProvider).getPlaces();
    if (mounted) {
      setState(() {
        _allPlaces = places;
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
    return _allPlaces.where((place) {
      final matchesSearch = _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (place.eventName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      bool matchesFilter = true;
      if (_selectedFilters.isNotEmpty) {
        if (_selectedFilters.contains('club') && !place.type.toString().contains('club')) {
          matchesFilter = false;
        }
        if (_selectedFilters.contains('event') && !place.status.toString().contains('event')) {
          matchesFilter = false;
        }
        if (_selectedFilters.contains('__food__') && !place.type.toString().contains('food')) {
          matchesFilter = false;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openDetails(BuildContext context, Place place) {
    ref.read(analyticsServiceProvider).logEvent('viewed_venue_details', parameters: {'venue_name': place.name});
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClubBottomSheet(place: place, userLocation: _liveUserLocation ?? widget.userLocation),
    );
  }

  void _showFilterSheet(BuildContext context, bool isDark) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture && _isFollowingUser) {
                      setState(() {
                        _isFollowingUser = false;
                      });
                    }
                    if (position.zoom != _currentZoom) {
                      setState(() => _currentZoom = position.zoom);
                    }
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
            ]
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (squadState.isInSquad) ...[
                GestureDetector(
                  // FIX: HAPTICS OP DE KNOP!
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
                const SizedBox(height: 12),
              ],
              if (_liveUserLocation != null) ...[
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
                const SizedBox(height: 12),
              ],
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
            ]
          )
        );
      }
    );
  }

  List<Marker> _buildMarkers(SquadProviderState squadState, bool isDark) {
    final markers = <Marker>[];
    final activePlaces = _filteredPlaces;

    if (_currentZoom < 14.5) {
      final poiGroups = <String, List<Place>>{};
      for (final p in activePlaces) {
        final poi = p.poi ?? 'Andere';
        poiGroups.putIfAbsent(poi, () => []).add(p);
      }

      for (final entry in poiGroups.entries) {
        final poiName = entry.key;
        final places = entry.value;

        double sumLat = 0, sumLng = 0;
        for (var p in places) {
          sumLat += p.location.latitude;
          sumLng += p.location.longitude;
        }
        final centerPoint = LatLng(sumLat / places.length, sumLng / places.length);
        markers.add(
          Marker(
            point: centerPoint,
            width: 140, 
            height: 48,
            rotate: true, 
            child: GestureDetector(
              onTap: () {
                _mapController.move(centerPoint, 15.5);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF18181B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))
                  ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      poiName, 
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${places.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        );
      }
    } 
    else {
      final double scale = (_currentZoom / 16.0).clamp(0.6, 1.1);
      final double baseSize = 54.0 * scale;
      final double iconSize = 26.0 * scale;
      for (final place in activePlaces) {
        final isFood = place.type.toString().contains('food') || place.name.toLowerCase().contains('food');
        final isEvent = place.status.toString().contains('event');

        final IconData pinIcon = isFood 
            ? Icons.fastfood_rounded 
            : (isEvent ? Icons.local_fire_department : Icons.nightlife);
        final Color pinColor = isFood 
            ? Colors.orange 
            : (isEvent ? Colors.purpleAccent : Colors.blueAccent);
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
                    BoxShadow(
                      color: pinColor.withValues(alpha: 0.5),
                      blurRadius: 8 * scale,
                      offset: Offset(0, 3 * scale),
                    )
                  ]
                ),
                child: Icon(
                  pinIcon, 
                  color: Colors.white, 
                  size: iconSize,
                ),
              ),
            ),
          )
        );
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
                  // FIX: Discord Green rand als je praat!
                  border: Border.all(
                    color: member.isSpeaking 
                        ? const Color(0xFF43B581) 
                        : (member.isOnline ? Colors.green : Colors.grey), 
                    width: member.isSpeaking ? 3 : 2
                  ),
                  boxShadow: [
                    if (member.isSpeaking)
                      BoxShadow(
                        color: const Color(0xFF43B581).withValues(alpha: 0.6), // <-- Aangepast
                        blurRadius: 15,
                        spreadRadius: 6,
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2), // <-- Aangepast
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
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
                          style: const TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        member.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
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
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            ),
          ),
        )
      );
    }

    return markers;
  }
}