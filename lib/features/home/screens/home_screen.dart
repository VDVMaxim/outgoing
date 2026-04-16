import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/repositories/repositories.dart';
import '../../clubs/widgets/club_bottom_sheet.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = clubRepository.getPlaces();
  }

  void _openDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClubBottomSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark || (currentMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        final l10n = AppLocalizations.of(context)!;
        final textColor = isDark ? Colors.white : Colors.black87;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
          body: SafeArea(
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
                
                final featured = allPlaces.where((p) => p.status == ClubStatus.event || p.promo != null).take(3).toList();
                final trending = allPlaces.where((p) => p.crowdLevel == 'Sfeervol' || p.crowdLevel == 'Druk').take(3).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShadAlert(
                        icon: const Icon(Icons.warning_amber, color: Colors.amberAccent),
                        title: Text(l10n.homeAlertTitle,
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        description: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(l10n.homeAlertDesc,
                              style: TextStyle(color: textColor)),
                        ),
                        decoration: ShadDecoration(
                          border: ShadBorder.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
                          color: Colors.amberAccent.withValues(alpha: 0.1),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(l10n.homeHighlightsTitle,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: featured.length,
                          separatorBuilder: (_, i) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final place = featured[index];
                            return GestureDetector(
                              onTap: () => _openDetails(context, place),
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF18181B) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(place.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor), overflow: TextOverflow.ellipsis)),
                                        if (place.isFlashPromoActive) const Icon(Icons.local_fire_department, color: Colors.purpleAccent, size: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(place.eventName ?? place.genre ?? '', style: const TextStyle(color: Colors.blueAccent)),
                                    const Spacer(),
                                    if (place.promo != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                        child: Text(place.promo!, style: const TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),
                      Text(l10n.homeTrendingTitle,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 12),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trending.length,
                        separatorBuilder: (_, i) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final place = trending[index];
                          return ListTile(
                            onTap: () => _openDetails(context, place),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            tileColor: isDark ? const Color(0xFF18181B) : Colors.grey[50],
                            title: Text(place.name, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Text('Vibe: ${place.crowdLevel}', style: const TextStyle(color: Colors.grey)),
                            trailing: Icon(Icons.chevron_right, color: textColor),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}