import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/models.dart';

class VibeCheckDialog extends StatefulWidget {
  final Place place;
  const VibeCheckDialog({super.key, required this.place});

  @override
  State<VibeCheckDialog> createState() => _VibeCheckDialogState();
}

class _VibeCheckDialogState extends State<VibeCheckDialog> {
  String _selectedVibe = 'Gezellig';

  final List<String> _vibes = [
    'Doodstil',
    'Gezellig',
    'Druk',
    'Bomvol',
    'Lange rij buiten',
    'Rij gaat vlot',
  ];

  void _submit() {
    // In a real app, send to backend. Here we just pop and show a success message.
    Navigator.pop(context, _selectedVibe);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vibe geüpdatet! Bedankt voor je bijdrage.'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hoe is de Vibe?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 8),
            Text('Update de status voor ${widget.place.name}.', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _vibes.map((vibe) => ChoiceChip(
                label: Text(vibe),
                selected: _selectedVibe == vibe,
                onSelected: (selected) => setState(() => _selectedVibe = vibe),
                backgroundColor: isDark ? Colors.black87 : Colors.white,
                selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
              )).toList(),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: _submit,
                child: const Text('Bevestigen'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
