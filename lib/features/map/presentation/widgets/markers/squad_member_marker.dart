import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../squad/providers/squad_provider.dart';

Marker buildSquadMemberMarker({
  required SquadMemberDisplay member, // Aangepast naar SquadMemberDisplay
  required bool isDark,
}) {
  return Marker(
    point: member.position,
    width: 160,
    height: 48,
    rotate: true,
    child: Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: member.isSpeaking ? const Color(0xFF43B581) : (member.isOnline ? Colors.green : Colors.grey),
            width: member.isSpeaking ? 3 : 2
          ),
          boxShadow: [
            if (member.isSpeaking)
              BoxShadow(color: const Color(0xFF43B581).withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 6)
            else
              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: member.isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  member.nickname.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                member.nickname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}