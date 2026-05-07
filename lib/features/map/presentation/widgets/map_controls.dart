import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import '../../../squad/providers/squad_provider.dart';

class MapControls extends ConsumerWidget {
  final AnimationController fabAnimController;
  final bool isPlacingPin;
  final bool hasLiveLocation;
  final bool isCompassMode;
  final bool isFollowingUser;
  final bool isDark;
  final VoidCallback onPlacePinTap;
  final VoidCallback onMyLocationTap;
  final VoidCallback onSquadTap;

  const MapControls({
    super.key,
    required this.fabAnimController,
    required this.isPlacingPin,
    required this.hasLiveLocation,
    required this.isCompassMode,
    required this.isFollowingUser,
    required this.isDark,
    required this.onPlacePinTap,
    required this.onMyLocationTap,
    required this.onSquadTap,
  });

  Widget _buildAnimatedFab(Widget child, int index) {
    return AnimatedBuilder(
      animation: fabAnimController,
      builder: (context, child) {
        final double start = index * 0.15;
        final double end = start + 0.5;
        final double t = ((fabAnimController.value - start) / (end - start)).clamp(0.0, 1.0);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final squadState = ref.watch(squadProvider);
    final settings = ref.watch(settingsProvider);

    return IgnorePointer(
      ignoring: isPlacingPin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (squadState.isInSquad) ...[
            _buildAnimatedFab(
              FloatingActionButton(
                heroTag: 'place_pin_fab',
                onPressed: onPlacePinTap,
                backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
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
          if (hasLiveLocation) ...[
            _buildAnimatedFab(
              FloatingActionButton(
                heroTag: 'my_location_fab',
                onPressed: onMyLocationTap,
                backgroundColor: isCompassMode
                    ? Colors.blueAccent
                    : (isDark ? const Color(0xFF18181B) : Colors.white),
                child: Icon(
                    isCompassMode ? Icons.explore : (isFollowingUser ? Icons.my_location : Icons.location_searching),
                    color: isCompassMode ? Colors.white : (isDark ? Colors.white : Colors.black)),
              ),
              2,
            ),
            const SizedBox(height: 12),
          ],
          _buildAnimatedFab(
            FloatingActionButton(
              heroTag: 'squad_fab',
              onPressed: onSquadTap,
              backgroundColor: squadState.isInSquad
                  ? Colors.blueAccent
                  : (isDark ? const Color(0xFF18181B) : Colors.white),
              child: Icon(
                Icons.groups,
                color: squadState.isInSquad
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
            3,
          ),
        ],
      ),
    );
  }
}