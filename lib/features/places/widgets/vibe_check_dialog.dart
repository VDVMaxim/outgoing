import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/vibe_provider.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';

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

    await ref.read(vibeProvider.notifier).updateVibe(widget.place.id, isPositive: isPositive);

    ref.read(analyticsServiceProvider).logEvent('vibe_check_submitted', parameters: {
      'place_id': widget.place.id,
      'is_positive': isPositive,
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vibe geüpdatet! +20 VP'),
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
            const Text('Hoe is de Vibe?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      child: const Text('🔥 Heet'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadButton.secondary(
                      onPressed: () => _submit(false),
                      child: const Text('🧊 Koud'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            ShadButton.ghost(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleren'),
            ),
          ],
        ),
      ),
    );
  }
}