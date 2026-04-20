import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatefulWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showStatus;
  final bool isOnline;
  final bool showPulse;
  final VoidCallback? onPulseTrigger;
  final bool isSpeaking; // FIX: Voor de Discord Walkie-Talkie ring

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 44,
    this.showStatus = false,
    this.isOnline = true,
    this.showPulse = false,
    this.onPulseTrigger,
    this.isSpeaking = false,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _pulseOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void triggerPulse() {
    _pulseController.reset();
    _pulseController.forward();
  }

  String get initials {
    if (widget.name.isEmpty) return '?';

    final parts = widget.name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.name.substring(0, min(2, widget.name.length)).toUpperCase();
  }

  Color get backgroundColor {
    final hash = widget.name.hashCode.abs();
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.70, 0.45).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size + 16,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  // FIX: Exacte Discord-stijl groene ring!
                  border: Border.all(
                    color: widget.isSpeaking ? const Color(0xFF43B581) : Colors.transparent, 
                    width: 3
                  ),
                  boxShadow: widget.isSpeaking
                      ? [
                          BoxShadow(
                            color: const Color(0xFF43B581).withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                  image: widget.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.imageUrl == null
                    ? Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.size * 0.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
              if (widget.showStatus)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: widget.size * 0.36,
                    height: widget.size * 0.36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isOnline
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: widget.isOnline
                        ? _OnlinePulsingDot(size: widget.size * 0.36)
                        : null,
                  ),
                ),
            ],
          ),
          if (widget.showPulse)
            Positioned(
              bottom: 0,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Opacity(
                      opacity: _pulseOpacityAnimation.value,
                      child: Container(
                        width: widget.size * 0.4,
                        height: widget.size * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _OnlinePulsingDot extends StatefulWidget {
  final double size;

  const _OnlinePulsingDot({required this.size});

  @override
  State<_OnlinePulsingDot> createState() => _OnlinePulsingDotState();
}

class _OnlinePulsingDotState extends State<_OnlinePulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF4CAF50),
            ),
          ),
        );
      },
    );
  }
}