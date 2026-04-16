import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/services/app_startup.dart';
import 'onboarding_carousel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;

  _SplashPhase _phase = _SplashPhase.verifying;
  AppStartupFailureKind? _failureKind;

  static const Color _darkBg = Color(0xFF09090B);
  static const Color _darkBgDeep = Color(0xFF0C0C0F);

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _entranceFade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _entranceSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic),
    );
    _entrance.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartup());
  }

  Future<void> _runStartup() async {
    final t0 = DateTime.now();
    final result = await AppStartup.verify();
    if (!mounted) return;

    const minSplash = Duration(milliseconds: 1100);
    final waited = DateTime.now().difference(t0);
    if (waited < minSplash) {
      await Future<void>.delayed(minSplash - waited);
    }
    if (!mounted) return;

    if (result.ok) {
      setState(() => _phase = _SplashPhase.ready);
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      _goOnboarding();
    } else {
      setState(() {
        _phase = _SplashPhase.error;
        _failureKind = result.failureKind;
      });
    }
  }

  void _goOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, a1, a2) => const OnboardingCarousel(),
        transitionsBuilder: (context, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _retry() {
    setState(() {
      _phase = _SplashPhase.verifying;
      _failureKind = null;
    });
    _runStartup();
  }

  String _errorBody(AppLocalizations l10n) {
    switch (_failureKind) {
      case AppStartupFailureKind.timeout:
        return l10n.splashSetupErrorTimeout;
      case AppStartupFailureKind.unknown:
      case null:
        return l10n.splashSetupErrorGeneric;
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_darkBg, _darkBgDeep]
                : const [Color(0xFFFAFAFA), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _entranceFade,
            child: SlideTransition(
              position: _entranceSlide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    _Mark(isDark: isDark),
                    const SizedBox(height: 28),
                    Text(
                      l10n.appName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4.2,
                        color: isDark ? Colors.white.withValues(alpha: 0.92) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 36),
                    if (_phase != _SplashPhase.error) ...[
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: _phase == _SplashPhase.ready
                            ? Icon(Icons.check_circle_rounded, size: 26, color: Colors.greenAccent.shade400)
                            : CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: isDark ? Colors.white.withValues(alpha: 0.75) : Colors.black54,
                              ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: Text(
                          _phase == _SplashPhase.ready ? l10n.splashSetupReady : l10n.splashSetupVerifying,
                          key: ValueKey(_phase),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.35,
                            color: isDark ? Colors.white.withValues(alpha: 0.55) : Colors.black54,
                          ),
                        ),
                      ),
                    ] else ...[
                      Icon(Icons.error_outline_rounded, size: 40, color: Colors.red.shade300),
                      const SizedBox(height: 20),
                      Text(
                        l10n.splashSetupErrorTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorBody(l10n),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ShadButton(
                        onPressed: _retry,
                        child: Text(l10n.splashRetry),
                      ),
                    ],
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _SplashPhase { verifying, ready, error }

class _Mark extends StatelessWidget {
  const _Mark({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF18181B) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Icon(
        Icons.nightlife_rounded,
        size: 40,
        color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
      ),
    );
  }
}
