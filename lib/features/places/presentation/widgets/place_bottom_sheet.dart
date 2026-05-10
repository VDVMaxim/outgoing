import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/places/domain/models/place.dart';

import 'package:flutter_clubapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_clubapp/features/vibe/presentation/providers/vibe_provider.dart';

import 'vibe_check_dialog.dart';

class ClubBottomSheet extends ConsumerWidget {
  final Place place;
  final LatLng? userLocation;

  const ClubBottomSheet({super.key, required this.place, this.userLocation});

  Future<void> _launchMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.location.latitude},${place.location.longitude}',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Kan Maps niet openen');
    }
  }

  void _openVibeCheck(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (userLocation == null) {
      ShadSonner.of(context).show(
        ShadToast.raw(
          variant: ShadToastVariant.destructive,
          title: const Icon(Icons.location_off, color: Colors.white),
          description: Text(l10n.toastLocationUnknown),
        ),
      );
      return;
    }

    const Distance distance = Distance();
    final double dist = distance(userLocation!, place.location);

    if (dist > 50) {
      ShadSonner.of(context).show(
        ShadToast.raw(
          variant: ShadToastVariant.destructive,
          title: const Icon(Icons.location_searching, color: Colors.white),
          description: Text(l10n.toastTooFarAway(dist.round())),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => VibeCheckDialog(place: place),
    );
  }

  Widget _buildOpeningHours(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    if (place.openingHours.isNotEmpty) {
      final days = [
        l10n.daySun,
        l10n.dayMon,
        l10n.dayTue,
        l10n.dayWed,
        l10n.dayThu,
        l10n.dayFri,
        l10n.daySat,
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.placeOpeningHours,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...place.openingHours.map(
            (oh) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    days[oh.dayOfWeek],
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Text(
                    '${oh.openTime} - ${oh.closeTime}',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (place.openingHoursRaw != null &&
        place.openingHoursRaw!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.placeOpeningHours,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            place.openingHoursRaw!,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      );
    }
    return Text(
      l10n.placeNoOpeningHours,
      style: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF09090B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
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
              Text(
                place.name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (place.address != null)
                Text(
                  place.address!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              const SizedBox(height: 16),
              _buildOpeningHours(context, isDark),
              const SizedBox(height: 20),
              if (place.type == LocationType.club && place.isOpen) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          place.recentLikes > 0
                              ? '🔥 ${place.recentLikes} Vibes'
                              : AppLocalizations.of(context)!.placeNoVibes,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ShadButton(
                        size: ShadButtonSize.sm,
                        onPressed: () => _openVibeCheck(context),
                        child: Text(AppLocalizations.of(context)!.placeUpdate),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (authState.isAuthenticated) ...[
                _CheckInButton(place: place),
                const SizedBox(height: 16),
              ],
              if (place.hasValidLocation)
                SizedBox(
                  width: double.infinity,
                  child: ShadButton.secondary(
                    onPressed: _launchMaps,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.directions),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.placeRoute),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckInButton extends ConsumerWidget {
  final Place place;
  const _CheckInButton({required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.3),
            Colors.blue.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: ShadButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          await ref.read(vibeProvider.notifier).checkIn(place.id);
          if (context.mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.checkInSuccess),
                backgroundColor: Colors.purple,
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, color: Colors.amber),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.placeCheckIn),
          ],
        ),
      ),
    );
  }
}
