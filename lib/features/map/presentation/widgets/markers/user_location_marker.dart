import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker buildUserLocationMarker({
  required LatLng location,
  required double currentHeading,
  required bool isCompassMode,
}) {
  final double coneSize = 140.0;
  final double rotationAngle = isCompassMode ? 0.0 : (currentHeading * math.pi / 180.0);

  return Marker(
    point: location,
    width: coneSize,
    height: coneSize,
    rotate: true,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: rotationAngle,
          child: CustomPaint(
            size: Size(coneSize, coneSize),
            painter: _ViewConePainter(),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)
            ]
          ),
        ),
      ],
    ),
  );
}

class _ViewConePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blueAccent.withValues(alpha: 0.4),
          Colors.blueAccent.withValues(alpha: 0.0),
        ],
        stops: const [0.2, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final sweepAngle = math.pi / 2;
    final startAngle = -math.pi / 2 - (sweepAngle / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}