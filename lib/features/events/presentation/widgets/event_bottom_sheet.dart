import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/providers/vibe_provider.dart';
import 'package:flutter_clubapp/core/providers/navigation_provider.dart';

class EventBottomSheet extends ConsumerWidget {
  final Place place;
  final LatLng? userLocation;

  const EventBottomSheet({super.key, required this.place, this.userLocation});

  Future<void> _launchMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.location.latitude},${place.location.longitude}',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Cannot open Maps');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    final title = place.eventName ?? place.name;

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
              // Drag handle
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

              // Event title
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Minimap
              if (place.hasValidLocation) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: place.location,
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.clubapp.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: place.location,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black54 : Colors.white70,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.zoom_out_map),
                              color: isDark ? Colors.white : Colors.black,
                              onPressed: () {
                                Navigator.pop(context);                                  
                                Future.microtask(() {
                                  ref.read(mapFocusProvider.notifier).state = place;
                                  ref.read(navIndexProvider.notifier).state = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Start time
              if (place.startTime != null)
                _InfoRow(
                  icon: Icons.schedule_rounded,
                  iconColor: Colors.blueAccent,
                  label: l10n.eventStartsAt,
                  value: _formatDateTime(place.startTime!),
                  isDark: isDark,
                ),

              // Organizer
              if (place.organizer != null && place.organizer!.isNotEmpty)
                _InfoRow(
                  icon: place.isVereniging
                      ? Icons.verified_rounded
                      : Icons.person_outline_rounded,
                  iconColor:
                      place.isVereniging ? Colors.green : Colors.grey,
                  label: l10n.eventHostedBy,
                  value: place.organizer!,
                  isDark: isDark,
                ),

              // Venue & Address
              if (place.eventName != null)
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.redAccent,
                  label: place.name,
                  value: place.address ?? '',
                  isDark: isDark,
                ),
              if (place.eventName == null && place.address != null)
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.redAccent,
                  label: place.address!,
                  value: '',
                  isDark: isDark,
                ),

              // Promo banner
              if (place.isFlashPromoActive) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withValues(alpha: 0.15),
                        Colors.orange.withValues(alpha: 0.10),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_rounded,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          place.promo!,
                          style: TextStyle(
                            color: isDark ? Colors.amber[200] : Colors.amber[900],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Check-in button (auth only)
              if (authState.isAuthenticated) ...[
                _EventCheckInButton(place: place, l10n: l10n),
                const SizedBox(height: 12),
              ],

              // Route button
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
                        Text(l10n.eventRoute),
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

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return DateFormat('EEE d MMM · HH:mm').format(local);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCheckInButton extends ConsumerWidget {
  final Place place;
  final AppLocalizations l10n;
  const _EventCheckInButton({required this.place, required this.l10n});

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('+10 VP! Check-in bevestigd'),
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
            Text(l10n.eventCheckIn),
          ],
        ),
      ),
    );
  }
}
