import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class MapFilterSheet extends StatefulWidget {
  final bool isDark;
  final Set<String> initialFilters;
  final ValueChanged<Set<String>> onFiltersChanged;

  const MapFilterSheet({
    super.key,
    required this.isDark,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  late Set<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = Set.from(widget.initialFilters);
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilters.contains(filterKey);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedFilters.add(filterKey);
          } else {
            _selectedFilters.remove(filterKey);
          }
        });
        widget.onFiltersChanged(_selectedFilters);
      },
      backgroundColor: widget.isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
      selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
      checkmarkColor: Colors.blueAccent,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.blueAccent
            : (widget.isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF18181B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            l10n.filtersTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('club', l10n.club),
              _buildFilterChip('event', l10n.event),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ShadButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.apply),
            ),
          )
        ],
      ),
    );
  }
}