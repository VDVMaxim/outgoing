import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart'; // Gefixt
import 'package:flutter_clubapp/core/providers/vibe_provider.dart';
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

  Future<void> _launchEmergency() async {
    final Uri url = Uri.parse('tel:112');
    if (!await launchUrl(url)) {
      debugPrint('Kan 112 niet bellen');
    }
  }

  Future<void> _launchTaxi() async {
    final Uri url = Uri.parse('https://m.uber.com/ul/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Kan taxi app niet openen');
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF09090B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

            Text(
              place.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              place.address,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            if (place.eventName != null) ...[
              const SizedBox(height: 8),
              Text(
                place.eventName!,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 12),

            if (place.tags.isNotEmpty || place.facilities.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...place.tags.map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  ...place.facilities.map(
                    (f) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.greenAccent.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 12,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                             f,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            if (place.type == LocationType.club && place.isOpen) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Vibe: ${place.crowdLevel ?? "Ongekend"}'),
                          if (place.lastVibeUpdate != null)
                            Text(
                              '${DateTime.now().difference(place.lastVibeUpdate!).inMinutes} mins geleden bevestigd',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                     ),
                    ShadButton(
                      size: ShadButtonSize.sm,
                      onPressed: () => _openVibeCheck(context),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (place.promo != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: place.isFlashPromoActive
                      ? Colors.purpleAccent.withValues(alpha: 0.1)
                      : Colors.amberAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                     Icon(
                      Icons.local_fire_department,
                      color: place.isFlashPromoActive
                          ? Colors.purpleAccent
                          : Colors.amberAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        place.promo!,
                        style: TextStyle(
                          color: place.isFlashPromoActive
                              ? Colors.purpleAccent
                              : Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            if (isAuthenticated) ...[
              _CheckInButton(place: place),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                Expanded(
                  child: ShadButton.secondary(
                    onPressed: _launchMaps,
                    child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions),
                        SizedBox(width: 8),
                        Text('Route'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShadButton(
                    backgroundColor: Colors.red[900],
                    onPressed: _launchEmergency,
                    child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 8),
                        Text('112', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                 const SizedBox(width: 12),
                Expanded(
                  child: ShadButton.secondary(
                    onPressed: _launchTaxi,
                    child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_taxi),
                        SizedBox(width: 8),
                        Text('Taxi'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.purple.withValues(alpha: 0.3),
                  Colors.blue.withValues(alpha: 0.3),
                 ]
              : [
                  Colors.purple.withValues(alpha: 0.1),
                  Colors.blue.withValues(alpha: 0.1),
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
          final vibeNotifier = ref.read(vibeProvider.notifier);
          await vibeNotifier.checkIn(place.id);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('+10 VP! Check-in bevestigd'),
                  ],
                ),
                backgroundColor: Colors.purple.shade800,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 8),
            Text('Check In (+10 VP)'),
          ],
        ),
      ),
    );
  }
}