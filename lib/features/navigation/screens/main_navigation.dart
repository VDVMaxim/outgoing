import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import '../../map/presentation/screens/map_screen.dart';
import '../../feed/screens/feed_screen.dart';
import '../../profile/screens/profile_tab_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  final LatLng? userLocation;
  const MainNavigation({super.key, this.userLocation});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentMode = ref.watch(themeProvider);
    final isDark =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBlurBackground(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                MapScreen(userLocation: widget.userLocation),
                const FeedScreen(),
                const ProfileTabScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: isDark
              ? const Color(0xFF09090B).withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.95),
          selectedItemColor: isDark ? Colors.white : Colors.black,
          unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              activeIcon: const Icon(Icons.map),
              label: AppLocalizations.of(context)!.navMap,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore),
              label: AppLocalizations.of(context)!.navDiscover,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}