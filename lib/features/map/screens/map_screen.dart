import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/mock_data.dart';
import 'package:flutter_clubapp/core/repositories/repositories.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/main.dart';
import '../../clubs/widgets/club_bottom_sheet.dart';
import '../../squad/widgets/squad_bottom_sheet.dart';
import '../../squad/providers/squad_provider.dart';

class MapScreen extends StatefulWidget {
  final LatLng? userLocation;
  const MapScreen({super.key, this.userLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  List<Place> _allPlaces = [];
  bool _isLoading = true;

  final Set<String> _selectedFilters = {};
  bool get _foodModeActive => _selectedFilters.contains('__food__');

  String _searchQuery = '';
  double _currentZoom = 8.0;

  bool _pulseTrigger = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _setupSquadPulse();
  }

  void _setupSquadPulse() {
    SquadProvider.instance.setPositionPulseCallback(() {
      if (mounted) {
        setState(() {
          _pulseTrigger = false;
        });
        Future.delayed(const Duration(milliseconds: 16), () {
          if (mounted) {
            setState(() {
              _pulseTrigger = true;
            });
          }
        });
      }
    });
  }

  Future<void> _loadPlaces() async {
    final places = await clubRepository.getPlaces();
    if (mounted) {
      setState(() {
        _allPlaces = places;
        _isLoading = false;
      });
    }
  }

  List<String> get _availableTagFilters {
    final Set<String> tags = {};
    for (final p in _allPlaces) {
      if (p.type == LocationType.club) tags.addAll(p.tags);
    }
    return tags.toList()..sort();
  }

  List<Place> get _visiblePlaces {
    if (_foodModeActive) {
      return _allPlaces.where((p) => p.type == LocationType.food).toList();
    }
    return _allPlaces.where((p) {
      if (p.type != LocationType.club) return false;
      if (_selectedFilters.isNotEmpty) {
        bool match = false;
        for (final f in _selectedFilters) {
          if (p.tags.contains(f)) {
            match = true;
            break;
          }
        }
        if (!match) return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!p.name.toLowerCase().contains(q) &&
            !p.address.toLowerCase().contains(q) &&
            !(p.genre?.toLowerCase().contains(q) ?? false)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _showPlaceDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ClubBottomSheet(place: place, userLocation: widget.userLocation),
    );
  }

  void _openFilterSheet(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final textColor = isDark ? Colors.white : Colors.black;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF09090B) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.mapFilters,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (_selectedFilters.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setModalState(() => _selectedFilters.clear());
                            setState(() {});
                          },
                          child: Text(
                            l10n.mapClearAll,
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildFilterTile(
                    isDark: isDark,
                    icon: Icons.restaurant,
                    label: '🍔  ${l10n.mapFood}',
                    value: '__food__',
                    setModalState: setModalState,
                    textColor: textColor,
                  ),
                  const Divider(height: 24),

                  Text(
                    l10n.mapCategories,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTagFilters.map((tag) {
                      final isSelected = _selectedFilters.contains(tag);
                      return FilterChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (val) {
                          setModalState(() {
                            if (val) {
                              _selectedFilters.add(tag);
                              _selectedFilters.remove('__food__');
                            } else {
                              _selectedFilters.remove(tag);
                            }
                          });
                          setState(() {});
                        },
                        backgroundColor: isDark
                            ? Colors.white10
                            : Colors.grey[100],
                        selectedColor: Colors.blueAccent,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.blueAccent
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTile({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required StateSetter setModalState,
    required Color textColor,
  }) {
    final isSelected = _selectedFilters.contains(value);
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            _selectedFilters.remove(value);
          } else {
            _selectedFilters.clear();
            _selectedFilters.add(value);
          }
        });
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.15)
              : (isDark ? Colors.white10 : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.blueAccent : textColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blueAccent : textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blueAccent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09090B)
            : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        final isDark =
            currentMode == ThemeMode.dark ||
            (currentMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        final l10n = AppLocalizations.of(context)!;

        final mapUrl = isDark
            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
            : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

        final activeFilterCount = _selectedFilters.length;

        return Scaffold(
          body: Stack(
            children: [
              ListenableBuilder(
                listenable: SquadProvider.instance,
                builder: (context, _) {
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          widget.userLocation ?? const LatLng(50.8503, 4.3517),
                      initialZoom: 8.0,
                      maxZoom: 22.0,
                      onPositionChanged: (position, _) {
                        if (position.zoom != _currentZoom) {
                          setState(() => _currentZoom = position.zoom);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: mapUrl,
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.example.flutter_clubapp',
                      ),
                      MarkerLayer(markers: _buildMarkers()),
                    ],
                  );
                },
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          Expanded(child: _buildSearchBar(isDark, l10n)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                _openFilterSheet(context, isDark, l10n),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: activeFilterCount > 0
                                    ? Colors.blueAccent
                                    : (isDark
                                          ? const Color(0xFF18181B)
                                          : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: activeFilterCount > 0
                                      ? Colors.blueAccent
                                      : (isDark
                                            ? Colors.white12
                                            : Colors.black12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.tune,
                                    color: activeFilterCount > 0
                                        ? Colors.white
                                        : (isDark
                                              ? Colors.white
                                              : Colors.black),
                                  ),
                                  if (activeFilterCount > 0)
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$activeFilterCount',
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (poiCenters.containsKey(_searchQuery))
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.analytics,
                              color: Colors.blueAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.mapOpenClubs(
                                _visiblePlaces
                                    .where(
                                      (p) => p.isOpen && p.poi == _searchQuery,
                                    )
                                    .length,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListenableBuilder(
                listenable: SquadProvider.instance,
                builder: (context, _) {
                  final inSquad = SquadProvider.instance.isInSquad;
                  return FloatingActionButton(
                    heroTag: 'squad_fab',
                    onPressed: () {
                      showSquadSheet(context);
                    },
                    backgroundColor: inSquad
                        ? Colors.blueAccent
                        : (isDark ? const Color(0xFF18181B) : Colors.white),
                    elevation: 4,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.groups,
                          color: inSquad
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black),
                        ),
                        if (inSquad)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const SizedBox(width: 6, height: 6),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'location_fab',
                onPressed: () {
                  _mapController.move(
                    widget.userLocation ?? overpoortCenter,
                    17.5,
                  );
                },
                backgroundColor: isDark ? Colors.white : Colors.black,
                elevation: 4,
                child: Icon(
                  Icons.my_location,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(bool isDark, AppLocalizations l10n) {
    final searchOptions = [
      ...poiCenters.keys,
      ..._allPlaces
          .where((p) => p.type == LocationType.club)
          .map((p) => p.name),
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18181B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Autocomplete<String>(
        optionsBuilder: (val) {
          if (val.text.isEmpty) return const Iterable<String>.empty();
          return searchOptions.where(
            (o) => o.toLowerCase().contains(val.text.toLowerCase()),
          );
        },
        onSelected: (selection) {
          setState(() {
            _searchQuery = selection;
            if (poiCenters.containsKey(selection)) {
              _mapController.move(poiCenters[selection]!, 15.5);
            } else {
              final club = _allPlaces.firstWhere((p) => p.name == selection);
              _mapController.move(club.location, 18.5);
            }
          });
        },
        fieldViewBuilder: (ctx, controller, focusNode, _) => Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, color: Colors.grey, size: 20),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                cursorColor: isDark ? Colors.white : Colors.black,
                decoration: InputDecoration(
                  hintText: l10n.mapSearchHint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                onPressed: () {
                  controller.clear();
                  setState(() => _searchQuery = '');
                },
              ),
            const SizedBox(width: 8),
          ],
        ),
        optionsViewBuilder: (ctx, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            child: Container(
              width: MediaQuery.of(ctx).size.width - 88,
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (ctx, i) {
                  final option = options.elementAt(i);
                  final isPOI = poiCenters.containsKey(option);
                  return ListTile(
                    leading: Icon(
                      isPOI ? Icons.place : Icons.local_bar,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      option,
                      style: TextStyle(
                        fontWeight: isPOI ? FontWeight.bold : FontWeight.normal,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final markers = <Marker>[];

    if (widget.userLocation != null) {
      markers.add(
        Marker(
          point: widget.userLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.radio_button_checked,
            color: Colors.blueAccent,
            size: 30,
          ),
        ),
      );
    }

    if (_currentZoom < 13.0) {
      for (final entry in poiCenters.entries) {
        markers.add(
          Marker(
            point: entry.value,
            width: 120,
            height: 40,
            child: GestureDetector(
              onTap: () {
                _mapController.move(entry.value, 15.0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      for (final place in _visiblePlaces) {
        Color markerColor;
        IconData iconData;
        double opacity = 1.0;

        if (_foodModeActive) {
          markerColor = Colors.orangeAccent;
          iconData = Icons.fastfood;
        } else {
          if (place.status == ClubStatus.event || place.isFlashPromoActive) {
            markerColor = Colors.purpleAccent;
            iconData = Icons.local_fire_department;
          } else if (place.status == ClubStatus.open) {
            markerColor = Colors.white;
            iconData = Icons.nightlife;
          } else {
            markerColor = Colors.grey;
            iconData = Icons.location_off;
            opacity = 0.5;
          }
        }

        markers.add(
          Marker(
            point: place.location,
            width: 50,
            height: 50,
            child: Opacity(
              opacity: opacity,
              child: GestureDetector(
                onTap: () => _showPlaceDetails(context, place),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.black54 : Colors.white70,
                    boxShadow: markerColor != Colors.grey
                        ? [
                            BoxShadow(
                              color: markerColor.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(iconData, color: markerColor, size: 30),
                ),
              ),
            ),
          ),
        );
      }
    }

    final squadProvider = SquadProvider.instance;
    if (squadProvider.isInSquad) {
      for (final member in squadProvider.members) {
        markers.add(
          Marker(
            point: member.position,
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                final diff = DateTime.now().difference(member.lastUpdate);
                final lastSeen = member.isOnline
                    ? l10n.mapOnline
                    : '${l10n.mapLastSeen} ${_formatLastSeen(member.lastUpdate, l10n, diff)}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${member.nickname}: $lastSeen'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: member.isCurrentUser
                  ? PulseAvatar(
                      key: ValueKey('pulse_${member.id}'),
                      name: member.nickname,
                      imageUrl: member.avatarUrl,
                      size: 44,
                      isOnline: member.isOnline,
                      triggerPulse: _pulseTrigger,
                    )
                  : UserAvatar(
                      name: member.nickname,
                      imageUrl: member.avatarUrl,
                      size: 44,
                      showStatus: true,
                      isOnline: member.isOnline,
                    ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  String _formatLastSeen(
    DateTime lastUpdate,
    AppLocalizations l10n,
    Duration diff,
  ) {
    if (diff.inMinutes < 1) return l10n.mapJustNow;
    if (diff.inMinutes == 1) return l10n.mapMinuteAgo;
    if (diff.inMinutes < 60) return l10n.mapMinutesAgo(diff.inMinutes);
    if (diff.inHours == 1) return l10n.mapHourAgo;
    return l10n.mapHoursAgo(diff.inHours);
  }
}
