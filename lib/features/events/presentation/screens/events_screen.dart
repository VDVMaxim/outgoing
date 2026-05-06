import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/providers/favorites_provider.dart';
import 'package:flutter_clubapp/core/services/location_service.dart';
import '../widgets/event_bottom_sheet.dart';
import '../../../../main.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _placesFuture = _loadPlaces();
  }

  Future<List<Place>> _loadPlaces() async {
    LatLng? userLocation;
    try {
      final pos = await ref.read(locationServiceProvider).getCurrentPosition();
      if (pos != null) {
        userLocation = LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {}
    return ref.read(clubRepositoryProvider).getEvents(userLocation: userLocation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventBottomSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        final isDark =
            currentMode == ThemeMode.dark ||
            (currentMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        final l10n = AppLocalizations.of(context)!;
        final textColor = isDark ? Colors.white : Colors.black87;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF09090B).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.9),
            elevation: 0,
            titleSpacing: 12,
            title: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              cursorColor: textColor,
              decoration: InputDecoration(
                hintText: l10n.eventsSearchHint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.06),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                  ),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                  color: _showFavoritesOnly
                      ? Colors.redAccent
                      : (isDark ? Colors.white : Colors.black),
                ),
                onPressed: () {
                  setState(() => _showFavoritesOnly = !_showFavoritesOnly);
                },
              ),
            ],
          ),
          body: FutureBuilder<List<Place>>(
            future: _placesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Er is een fout opgetreden',
                    style: TextStyle(color: textColor),
                  ),
                );
              }

              final allPlaces = snapshot.data ?? [];
              return ValueListenableBuilder<Set<String>>(
                valueListenable: FavoritesProvider.instance,
                builder: (context, favorites, _) {
                  List<Place> events = allPlaces.where((p) {
                    if (_showFavoritesOnly && !favorites.contains(p.id)) {
                      return false;
                    }
                    if (_searchQuery.isNotEmpty) {
                      final q = _searchQuery.toLowerCase();
                      final nameMatch = p.name.toLowerCase().contains(q);
                      final orgMatch =
                          p.organizer?.toLowerCase().contains(q) ?? false;
                      final genreMatch =
                          p.genre?.toLowerCase().contains(q) ?? false;
                      final eventMatch =
                          p.eventName?.toLowerCase().contains(q) ?? false;
                      if (!nameMatch && !orgMatch && !genreMatch && !eventMatch) {
                        return false;
                      }
                    }
                    return true;
                  }).toList();

                  events.sort((a, b) {
                    if (a.startTime == null && b.startTime == null) return 0;
                    if (a.startTime == null) return 1;
                    if (b.startTime == null) return -1;
                    return a.startTime!.compareTo(b.startTime!);
                  });

                  if (events.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.eventsEmpty,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final place = events[index];
                      final isFavorite = favorites.contains(place.id);

                      return GestureDetector(
                        onTap: () => _openDetails(context, place),
                        child: ShadCard(
                          backgroundColor: isDark
                              ? const Color(0xCC18181B)
                              : Colors.white.withValues(alpha: 0.85),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  place.eventName ?? place.genre ?? 'Event',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.redAccent
                                      : (isDark
                                            ? Colors.white54
                                            : Colors.black54),
                                  size: 24,
                                ),
                                onPressed: () {
                                  FavoritesProvider.instance.toggleFavorite(
                                    place.id,
                                  );
                                },
                              ),
                            ],
                          ),
                          description: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place.name,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              if (place.organizer != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shield,
                                      size: 14,
                                      color: place.isVereniging
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      place.organizer!,
                                      style: TextStyle(
                                        color: place.isVereniging
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (place.startTime != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${place.startTime!.hour.toString().padLeft(2, '0')}:${place.startTime!.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (place.promo != null) ...[
                                  Text(
                                    place.promo!,
                                    style: TextStyle(
                                      color: place.isFlashPromoActive
                                        ? Colors.purpleAccent
                                          : Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 16,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          place.recentLikes > 0 
                                              ? '${place.recentLikes} Vibes' 
                                              : l10n.eventsUnknownCrowd,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ShadButton.outline(
                                      size: ShadButtonSize.sm,
                                      onPressed: () =>
                                          _openDetails(context, place),
                                      child: Text(
                                        l10n.eventsDetails,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}