import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/providers/vibe_provider.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/services/location_service.dart';
import 'package:flutter_clubapp/core/widgets/badge_vault.dart';
import '../../places/widgets/place_bottom_sheet.dart';
import '../../../main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

Widget _buildVibeSection(WidgetRef ref, bool isDark, Color textColor) {
  final vibeState = ref.watch(vibeProvider);
  final profile = vibeState.profile;
  final isLoggedIn = ref.read(authProvider).isAuthenticated;

  if (!isLoggedIn || profile == null) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Log in to earn Vibe Points!',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.5)),
        ],
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [
                Colors.purple.withValues(alpha: 0.3),
                Colors.blue.withValues(alpha: 0.3),
              ]
            : [
                Colors.purple.withValues(alpha: 0.15),
                Colors.blue.withValues(alpha: 0.15),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.totalVp} VP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Level ${profile.currentLevel} • ${profile.weekendStreak}🔥 streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.5)),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(
          height: 80,
          child: BadgeVaultWidget(compact: true, showLocked: false),
        ),
      ],
    ),
  );
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Place>> _placesFuture;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchData();
  }

  void _fetchData() {
    _placesFuture = _loadPlaces();
  }

  Future<List<Place>> _loadPlaces() async {
    LatLng? userLocation;
    try {
      final pos = await LocationService.instance.getCurrentPosition();
      if (pos != null) {
        userLocation = LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {}
    return ref.read(clubRepositoryProvider).getDiscoverPlaces(userLocation: userLocation);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaceBottomSheet(place: place),
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
        final authState = ref.watch(authProvider);
        final nickname = authState.nickname;

        return SafeArea(
          child: FutureBuilder<List<Place>>(
            future: _placesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Fout bij het laden van data'));
              }

              final allPlaces = snapshot.data ?? [];
              
              final featured = allPlaces
                  .where((p) => p.status == ClubStatus.event || p.promo != null)
                  .take(5)
                  .toList();
                  
              final trendingList = allPlaces.where((p) => p.hotnessScore > 0).toList();
              trendingList.sort((a, b) => b.hotnessScore.compareTo(a.hotnessScore));
              final trending = trendingList.take(3).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    Text(
                      nickname != null ? 'Welcome, $nickname!' : 'Welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover what\'s happening tonight',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildVibeSection(ref, isDark, textColor),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.homeHighlightsTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        if (featured.isNotEmpty)
                          Text(
                            '${_currentPage + 1}/${featured.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 200,
                      child: featured.isEmpty
                          ? Center(
                              child: Text(
                                'No events or promotions right now',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black54,
                                ),
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: featured.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final place = featured[index];
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (_pageController.position.haveDimensions) {
                                      value = _pageController.page! - index;
                                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                                    }
                                    return Center(
                                      child: Transform.scale(
                                        scale: value,
                                        child: _HighlightCard(
                                          place: place,
                                          isDark: isDark,
                                          textColor: textColor,
                                          onTap: () =>
                                              _openDetails(context, place),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 8),

                    if (featured.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(featured.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.blueAccent
                                  : (isDark ? Colors.white24 : Colors.black26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                    const SizedBox(height: 32),
                    Text(
                      l10n.homeTrendingTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    trending.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No trending places right now',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: trending.length,
                            separatorBuilder: (_, i) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final place = trending[index];
                              return ListTile(
                                onTap: () => _openDetails(context, place),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tileColor: isDark
                                    ? const Color(0xFF18181B)
                                    : Colors.white.withValues(alpha: 0.5),
                                title: Text(
                                  place.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                subtitle: Text(
                                  place.recentLikes > 0 ? '🔥 ${place.recentLikes} Vibes' : 'Nieuw',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: textColor,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final Place place;
  final bool isDark;
  final Color textColor;
  final VoidCallback onTap;

  const _HighlightCard({
    required this.place,
    required this.isDark,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xCC18181B)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      place.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (place.isFlashPromoActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'HOT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                place.eventName ?? place.genre ?? 'Event',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
              ),
              const Spacer(),
              if (place.promo != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    place.promo!,
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (place.poi != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.poi!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}