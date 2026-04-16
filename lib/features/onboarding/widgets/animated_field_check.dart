import 'package:flutter/material.dart';

class AnimatedFieldCheck extends StatefulWidget {
  final bool isValid;

  const AnimatedFieldCheck({super.key, required this.isValid});

  @override
  State<AnimatedFieldCheck> createState() => _AnimatedFieldCheckState();
}

class _AnimatedFieldCheckState extends State<AnimatedFieldCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    if (widget.isValid) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedFieldCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isValid && !oldWidget.isValid) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isValid) {
      return const SizedBox(width: 24, height: 24);
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      ),
    );
  }
}
