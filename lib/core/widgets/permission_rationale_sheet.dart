import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PermissionRationaleSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

  const PermissionRationaleSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.onPrimary,
    this.onSecondary,
  });

  static Future<void> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimary,
    VoidCallback? onSecondary,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PermissionRationaleSheet(
        icon: icon,
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18181B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  onPressed: onPrimary,
                  child: Text(primaryButtonText),
                ),
              ),
              if (onSecondary != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ShadButton.ghost(
                    onPressed: onSecondary,
                    child: const Text('Not now'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
