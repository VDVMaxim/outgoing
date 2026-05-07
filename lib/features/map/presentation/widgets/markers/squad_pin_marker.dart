import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import '../../../../squad/providers/squad_provider.dart';

Marker buildSquadPinMarker({
  required BuildContext context,
  required SquadPin pin,
  required List<SquadMemberDisplay> allMembers, // Aangepast naar SquadMemberDisplay
  required String? currentUserId,
  required bool isDark,
  required VoidCallback onJoin,
}) {
  final joinedMembers = allMembers.where((m) => pin.joinedUserIds.contains(m.odmemberId)).toList();
  final hasJoined = currentUserId != null && pin.joinedUserIds.contains(currentUserId);
  final timeStr = '${pin.targetTime.toLocal().hour.toString().padLeft(2, '0')}:${pin.targetTime.toLocal().minute.toString().padLeft(2, '0')}';
  final double stackWidth = joinedMembers.isEmpty ? 0 : (joinedMembers.length * 32.0) - ((joinedMembers.length - 1) * 16.0);

  return Marker(
    point: pin.position,
    width: 300,
    height: 100,
    rotate: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white24 : Colors.black87, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(timeStr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
              ),
              if (joinedMembers.isNotEmpty) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: stackWidth,
                  height: 32,
                  child: Stack(
                    children: List.generate(joinedMembers.length, (i) {
                      final m = joinedMembers[i];
                      return Positioned(
                        left: i * 16.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: m.isOnline ? Colors.green : Colors.grey,
                            border: Border.all(color: isDark ? const Color(0xFF18181B) : Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              m.nickname.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
              if (!hasJoined && currentUserId != null) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onJoin,
                  child: Text(AppLocalizations.of(context)!.imIn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueAccent)),
                ),
              ],
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -5),
          child: Icon(Icons.arrow_drop_down, size: 40, color: isDark ? Colors.white24 : Colors.black87),
        ),
      ],
    ),
  );
}