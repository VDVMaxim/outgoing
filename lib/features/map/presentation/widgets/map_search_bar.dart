import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class MapSearchBar extends StatelessWidget {
  final bool isDark;
  final bool hasActiveFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;

  const MapSearchBar({
    super.key,
    required this.isDark,
    required this.hasActiveFilters,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF18181B).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              cursorColor: isDark ? Colors.white : Colors.black,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: l10n.eventsSearchHint,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: hasActiveFilters
                        ? Colors.blueAccent
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                  onPressed: onFilterTap,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ),
      ),
    );
  }
}