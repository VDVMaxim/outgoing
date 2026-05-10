import 'package:flutter_clubapp/core/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/places/domain/models/place.dart';

import 'package:flutter_clubapp/features/vibe/presentation/providers/vibe_provider.dart';

class VibeCheckDialog extends ConsumerStatefulWidget {
  final Place place;
  const VibeCheckDialog({super.key, required this.place});

  @override
  ConsumerState<VibeCheckDialog> createState() => _VibeCheckDialogState();
}

class _VibeCheckDialogState extends ConsumerState<VibeCheckDialog> {
  bool _isLoading = false;

  void _submit(bool isPositive) async {
    setState(() => _isLoading = true);

    await ref
        .read(vibeProvider.notifier)
        .updateVibe(widget.place.id, isPositive: isPositive);

    ref
        .read(analyticsServiceProvider)
        .logEvent(
          'vibe_check_submitted',
          parameters: {'place_id': widget.place.id, 'is_positive': isPositive},
        );

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.vibeUpdated),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.vibeCheckTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else ...[
              Row(
                children: [
                  Expanded(
                    child: ShadButton(
                      backgroundColor: Colors.orange,
                      onPressed: () => _submit(true),
                      child: Text(AppLocalizations.of(context)!.vibeHot),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadButton.secondary(
                      onPressed: () => _submit(false),
                      child: Text(AppLocalizations.of(context)!.vibeCold),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            ShadButton.ghost(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.vibeCancel),
            ),
          ],
        ),
      ),
    );
  }
}
