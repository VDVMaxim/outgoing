import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class AnimatedBlurBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBlurBackground({super.key, required this.child});

  @override
  State<AnimatedBlurBackground> createState() => _AnimatedBlurBackgroundState();
}

class _AnimatedBlurBackgroundState extends State<AnimatedBlurBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kleurt mee met light/dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        Container(color: isDark ? const Color(0xFF09090B) : Colors.grey[200]),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 + math.cos(_controller.value * 2 * math.pi) * 100 - 150,
                  top: MediaQuery.of(context).size.height / 3 + math.sin(_controller.value * 2 * math.pi) * 100 - 150,
                  child: Container(width: 300, height: 300, decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle)),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width / 2 + math.sin(_controller.value * 2 * math.pi) * 150 - 150,
                  bottom: MediaQuery.of(context).size.height / 3 + math.cos(_controller.value * 2 * math.pi) * 150 - 150,
                  child: Container(width: 300, height: 300, decoration: const BoxDecoration(color: Colors.deepPurpleAccent, shape: BoxShape.circle)),
                ),
              ],
            );
          },
        ),
        Positioned.fill(
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
        ),
        widget.child,
      ],
    );
  }
}
