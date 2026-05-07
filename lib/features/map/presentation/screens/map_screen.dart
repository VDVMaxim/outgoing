import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/constants/app_constants.dart';
import 'package:flutter_clubapp/core/widgets/permission_rationale_sheet.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import '../../../places/widgets/place_bottom_sheet.dart';
import '../../../squad/widgets/squad_bottom_sheet.dart';
import '../../../squad/providers/squad_provider.dart';
import '../providers/map_provider.dart';
import '../widgets/location_fallback_view.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/pin_placement_overlay.dart';
import '../widgets/map_controls.dart';
import '../widgets/map_filter_sheet.dart';
import '../widgets/markers/place_marker.dart';
import '../widgets/markers/squad_member_marker.dart';
import '../widgets/markers/squad_pin_marker.dart';
import '../widgets/markers/user_location_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? userLocation;
  const MapScreen({super.key, this.userLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final MapController _mapController = MapController();
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logEvent('opened_map');
      ref.read(mapProvider.notifier).initLocation(widget.userLocation);
      ref.read(mapProvider.notifier).checkInitialPermission();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      ref.read(mapProvider.notifier).checkInitialPermission();
    }
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _promptForLocation() async {
    final l10n = AppLocalizations.of(context)!;
    await PermissionRationaleSheet.show(
      context: context,
      icon: Icons.location_on,
      title: l10n.onboardingLocationTitle,
      message: l10n.onboardingLocationDesc,
      primaryButtonText: l10n.onboardingLocationAllow,
      onPrimary: () async {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          ref.read(mapProvider.notifier).setLocationPermission(true);
        }
      },
      onSecondary: () {},
    );
  }

  Future<void> _openDetails(BuildContext context, Place markerPlace, MapState state) async {
    if (state.isPlacingPin) return;

    ref.read(analyticsServiceProvider).logEvent('viewed_place_details', parameters: {'place_id': markerPlace.id});
    ref.read(mapProvider.notifier).selectPlace(markerPlace.id);
    
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
    
    Place? fullPlace;
    try {
      fullPlace = await ref.read(clubRepositoryProvider).getPlaceById(markerPlace.id);
    } catch (e) {
      if (!context.mounted) return;
      ShadToaster.of(context).show(ShadToast.destructive(title: Text(AppLocalizations.of(context)!.error), description: Text(AppLocalizations.of(context)!.errorLoadingPlaceDetails)));
    }

    if (!context.mounted) return;
    Navigator.pop(context);

    if (fullPlace == null) {
      ref.read(mapProvider.notifier).selectPlace(null);
      return;
    }
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaceBottomSheet(place: fullPlace!, userLocation: state.liveUserLocation ?? widget.userLocation),
    );
    
    ref.read(mapProvider.notifier).selectPlace(null);
  }

  void _showFilterSheet(BuildContext context, bool isDark, MapState state) {
    if (state.isPlacingPin) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return MapFilterSheet(
          isDark: isDark,
          initialFilters: state.selectedFilters,
          onFiltersChanged: (newFilters) {
            ref.read(mapProvider.notifier).setFilters(newFilters);
            ref.read(mapProvider.notifier).fetchPlacesForCurrentBounds(_mapController.camera, clearCache: true);
          },
        );
      }
    );
  }

  Future<void> _handleTimePick(MapState state) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(state.pinTargetTime));
    if (picked != null) {
      final now = DateTime.now();
      ref.read(mapProvider.notifier).setPinTargetTime(DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
    }
  }

  List<Marker> _buildMarkers(MapState mapState, SquadProviderState squadState, bool isDark) {
    final markers = <Marker>[];
    final activePlaces = mapState.cachedPlaces.values.where((place) {
      if (mapState.selectedFilters.isNotEmpty) {
        if (mapState.selectedFilters.contains('club') && place.type != LocationType.club) return false;
        if (mapState.selectedFilters.contains('event') && place.status != ClubStatus.event) return false;
      }
      if (mapState.currentZoom < 10.5) {
        if (!(place.hotnessScore >= 5 || place.isFlashPromoActive || place.status == ClubStatus.event)) return false;
      }
      return true;
    }).toList();
    
    activePlaces.sort((a, b) => a.hotnessScore.compareTo(b.hotnessScore));
    final double scale = (mapState.currentZoom / 15.0).clamp(0.35, 1.15);

    Place? selectedPlace;
    for (final place in activePlaces) {
      if (place.id == mapState.selectedPlaceId) {
        selectedPlace = place;
        continue;
      }
      markers.add(buildPlaceMarker(place: place, scale: scale, currentZoom: mapState.currentZoom, isDark: isDark, isSelected: false, onTap: () => _openDetails(context, place, mapState)));
    }

    if (squadState.isInSquad) {
      for (final member in squadState.members) {
        markers.add(buildSquadMemberMarker(member: member, isDark: isDark));
      }
      final currentMember = squadState.members.where((m) => m.isCurrentUser).firstOrNull;
      for (final pin in squadState.pins) {
        markers.add(buildSquadPinMarker(context: context, pin: pin, allMembers: squadState.members, currentUserId: currentMember?.odmemberId, isDark: isDark, onJoin: () => ref.read(squadProvider.notifier).joinPin(pin.id)));
      }
    }

    if (mapState.liveUserLocation != null && !squadState.isInSquad) {
      markers.add(buildUserLocationMarker(location: mapState.liveUserLocation!, currentHeading: mapState.currentHeading, isCompassMode: mapState.isCompassMode));
    }

    if (selectedPlace != null) {
      markers.add(buildPlaceMarker(
        place: selectedPlace,
        scale: scale,
        currentZoom: mapState.currentZoom,
        isDark: isDark,
        isSelected: true,
        onTap: () => _openDetails(context, selectedPlace!, mapState), // Uitroepteken toegevoegd
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final squadState = ref.watch(squadProvider);
    final currentMode = ref.watch(themeProvider);
    final currentIsDark = currentMode == ThemeMode.dark || (currentMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    ref.listen<MapState>(mapProvider, (previous, next) {
      if (next.liveUserLocation != null && next.liveUserLocation != previous?.liveUserLocation && next.isFollowingUser) {
        _mapController.move(next.liveUserLocation!, next.currentZoom);
      }
      if (next.currentHeading != previous?.currentHeading && next.isCompassMode) {
        _mapController.rotate(360 - next.currentHeading);
      }
      if (next.isCompassMode != previous?.isCompassMode && !next.isCompassMode) {
        _mapController.rotate(0);
      }
    });

    return Scaffold(
      body: !mapState.hasLocationPermission
        ? LocationFallbackView(isDark: currentIsDark, onAllowLocation: _promptForLocation)
        : Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: mapState.liveUserLocation ?? widget.userLocation ?? AppConstants.defaultLocation,
                  initialZoom: mapState.currentZoom,
                  onMapReady: () {
                    ref.read(mapProvider.notifier).fetchPlacesForCurrentBounds(_mapController.camera);
                  },
                  onPositionChanged: (camera, hasGesture) {
                    if (hasGesture && mapState.isFollowingUser) {
                      ref.read(mapProvider.notifier).setFollowingUser(false);
                    }
                    ref.read(mapProvider.notifier).onCameraMove(camera);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: currentIsDark 
                        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.jouwnaam.flutter_clubapp', 
                  ),
                  MarkerLayer(markers: _buildMarkers(mapState, squadState, currentIsDark)),
                ],
              ),
              IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: mapState.isPlacingPin ? 1.0 : 0.0,
                  child: const Center(
                    child: Padding(padding: EdgeInsets.only(bottom: 40.0), child: Icon(Icons.push_pin, size: 48, color: Colors.blueAccent)),
                  ),
                ),
              ),
              if (!mapState.isPlacingPin)
                MapSearchBar(
                  isDark: currentIsDark,
                  hasActiveFilters: mapState.selectedFilters.isNotEmpty,
                  onSearchChanged: (val) {
                    ref.read(mapProvider.notifier).setSearchQuery(val);
                    ref.read(mapProvider.notifier).fetchPlacesForCurrentBounds(_mapController.camera, clearCache: true);
                  },
                  onFilterTap: () => _showFilterSheet(context, currentIsDark, mapState),
                ),
              if (mapState.isLoading && !mapState.isPlacingPin)
                Positioned(
                  top: 90, left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: currentIsDark ? Colors.black87 : Colors.white, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                      child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                ),
              PinPlacementOverlay(
                isPlacingPin: mapState.isPlacingPin,
                isDark: currentIsDark,
                pinTargetTime: mapState.pinTargetTime,
                onTimePick: () => _handleTimePick(mapState),
                onCancel: () {
                  _fabAnimController.reverse();
                  ref.read(mapProvider.notifier).setPlacingPin(false);
                },
                onPlacePin: () {
                  ref.read(squadProvider.notifier).createPin(_mapController.camera.center, mapState.pinTargetTime);
                  _fabAnimController.reverse();
                  ref.read(mapProvider.notifier).setPlacingPin(false);
                },
              ),
            ]
          ),
      floatingActionButton: MapControls(
        fabAnimController: _fabAnimController,
        isPlacingPin: mapState.isPlacingPin,
        hasLiveLocation: mapState.liveUserLocation != null,
        isCompassMode: mapState.isCompassMode,
        isFollowingUser: mapState.isFollowingUser,
        isDark: currentIsDark,
        onPlacePinTap: () {
          _fabAnimController.forward();
          ref.read(mapProvider.notifier).setPlacingPin(true);
        },
        onMyLocationTap: () {
          ref.read(analyticsServiceProvider).logEvent('map_recenter_clicked');
          ref.read(mapProvider.notifier).toggleMyLocation();
          if (mapState.liveUserLocation != null) {
            _mapController.move(mapState.liveUserLocation!, 15.0);
            if (!mapState.isCompassMode && !mapState.isFollowingUser) _mapController.rotate(0);
          }
        },
        onSquadTap: () => showSquadSheet(context),
      ),
    );
  }
}