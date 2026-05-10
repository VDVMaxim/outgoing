import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class PinPlacementOverlay extends StatelessWidget {
  final bool isPlacingPin;
  final bool isDark;
  final DateTime pinTargetTime;
  final VoidCallback onTimePick;
  final VoidCallback onCancel;
  final VoidCallback onPlacePin;

  const PinPlacementOverlay({
    super.key,
    required this.isPlacingPin,
    required this.isDark,
    required this.pinTargetTime,
    required this.onTimePick,
    required this.onCancel,
    required this.onPlacePin,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      bottom: isPlacingPin ? 16 : -300,
      left: 16,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isPlacingPin ? 1.0 : 0.0,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF18181B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.setTargetTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onTimePick,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '${pinTargetTime.hour.toString().padLeft(2, '0')}:${pinTargetTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ShadButton.ghost(
                        onPressed: onCancel,
                        child: Text(AppLocalizations.of(context)!.mapCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShadButton(
                        onPressed: onPlacePin,
                        child: Text(AppLocalizations.of(context)!.placePin),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
