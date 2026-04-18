import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBlurBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBlurBackground({super.key, required this.child});

  @override
  State<AnimatedBlurBackground> createState() => _AnimatedBlurBackgroundState();
}

class _AnimatedBlurBackgroundState extends State<AnimatedBlurBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Background color
        Container(color: isDark ? const Color(0xFF09090B) : Colors.white),

        // Animated gradient circles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value * 2 * math.pi;

            return Stack(
              children: [
                // Purple circle - top right area
                Positioned(
                  left: size.width * 0.5 + math.sin(t) * 100 - 150,
                  top: size.height * 0.1 + math.cos(t * 0.8) * 80,
                  child: _GradientCircle(
                    size: 350,
                    colors: [
                      Colors.purple.withValues(alpha: 0.5),
                      Colors.purple.withValues(alpha: 0.2),
                      Colors.purple.withValues(alpha: 0.0),
                    ],
                  ),
                ),

                // Blue circle - bottom left area
                Positioned(
                  right: size.width * 0.4 + math.cos(t + 1) * 120 - 150,
                  bottom: size.height * 0.2 + math.sin(t * 0.9) * 100,
                  child: _GradientCircle(
                    size: 300,
                    colors: [
                      Colors.blue.withValues(alpha: 0.5),
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.0),
                    ],
                  ),
                ),

                // Pink circle - center left
                Positioned(
                  left: size.width * 0.1 + math.sin(t + 2) * 60,
                  top: size.height * 0.4 + math.cos(t * 1.2) * 70,
                  child: _GradientCircle(
                    size: 250,
                    colors: [
                      Colors.pink.withValues(alpha: 0.4),
                      Colors.pink.withValues(alpha: 0.15),
                      Colors.pink.withValues(alpha: 0.0),
                    ],
                  ),
                ),

                // Cyan circle - bottom right
                Positioned(
                  right: size.width * 0.2 + math.cos(t + 3) * 80,
                  bottom: size.height * 0.5 + math.sin(t * 0.7) * 60,
                  child: _GradientCircle(
                    size: 200,
                    colors: [
                      Colors.cyan.withValues(alpha: 0.4),
                      Colors.cyan.withValues(alpha: 0.15),
                      Colors.cyan.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        // Content on top
        widget.child,
      ],
    );
  }
}

class _GradientCircle extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _GradientCircle({required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors, stops: const [0.0, 0.5, 1.0]),
      ),
    );
  }
}
