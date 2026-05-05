import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/animated_background.dart';
import '../../map/screens/map_screen.dart';
import '../../events/presentation/screens/events_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../main.dart';

class MainNavigation extends StatefulWidget {
  final LatLng? userLocation;
  const MainNavigation({super.key, this.userLocation});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
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
                    const EventsScreen(),
                    const SettingsScreen(),
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
                  icon: const Icon(Icons.event_outlined),
                  activeIcon: const Icon(Icons.event),
                  label: AppLocalizations.of(context)!.navEvents,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  activeIcon: const Icon(Icons.settings),
                  label: AppLocalizations.of(context)!.navSettings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}