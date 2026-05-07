import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_clubapp/core/models.dart';

Marker buildPlaceMarker({
  required Place place,
  required double scale,
  required double currentZoom,
  required bool isDark,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final isFood = place.type == LocationType.food || place.name.toLowerCase().contains('food');
  final isEvent = place.status == ClubStatus.event;
  final isHot = place.hotnessScore >= 5 || place.isFlashPromoActive || isEvent;

  if (isSelected) {
    final IconData pinIcon = isFood ? Icons.fastfood_rounded : (isHot ? Icons.local_fire_department : Icons.nightlife);
    final Color pinColor = isFood ? Colors.orange : (isHot ? Colors.purpleAccent : Colors.blueAccent);
    final double selectedSize = 68.0 * scale;
    return Marker(
      point: place.location,
      width: selectedSize,
      height: selectedSize,
      rotate: true,
      child: Container(
        decoration: BoxDecoration(
          color: pinColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4 * scale),
          boxShadow: [
            BoxShadow(color: pinColor, blurRadius: 16 * scale, spreadRadius: 4 * scale)
          ]
        ),
        child: Icon(pinIcon, color: Colors.white, size: 32 * scale),
      ),
    );
  }

  if (!isHot && currentZoom < 15.5) {
    final Color dotColor = isFood ? Colors.orange.withValues(alpha: 0.6) : Colors.blueAccent.withValues(alpha: 0.6);
    return Marker(
      point: place.location,
      width: 12 * scale,
      height: 12 * scale,
      rotate: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 1),
          ),
        ),
      ),
    );
  } else {
    final double baseSize = 54.0 * scale;
    final double iconSize = 26.0 * scale;
    final IconData pinIcon = isFood ? Icons.fastfood_rounded : (isHot ? Icons.local_fire_department : Icons.nightlife);
    final Color pinColor = isFood ? Colors.orange : (isHot ? Colors.purpleAccent : Colors.blueAccent);
    return Marker(
      point: place.location,
      width: baseSize,
      height: baseSize,
      rotate: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: pinColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5 * scale),
            boxShadow: [
              BoxShadow(color: pinColor.withValues(alpha: 0.5), blurRadius: 8 * scale, offset: Offset(0, 3 * scale))
            ]
          ),
          child: Icon(pinIcon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}