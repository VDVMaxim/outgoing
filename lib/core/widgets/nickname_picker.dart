import 'package:flutter/material.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class NicknamePicker extends StatefulWidget {
  final TextEditingController nicknameController;
  final VoidCallback onGenerate;
  final VoidCallback? onStateRefresh;
  final String? errorText;
  final bool showGenerateButton;
  final Widget? child;

  const NicknamePicker({
    super.key,
    required this.nicknameController,
    required this.onGenerate,
    this.onStateRefresh,
    this.errorText,
    this.showGenerateButton = true,
    this.child,
  });

  @override
  State<NicknamePicker> createState() => _NicknamePickerState();
}

class _NicknamePickerState extends State<NicknamePicker> {
  void _handleGenerate() {
    widget.onGenerate();
    widget.onStateRefresh?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: UserAvatar(
              name: widget.nicknameController.text.isEmpty
                  ? '?'
                  : widget.nicknameController.text,
              size: 80,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboardingNicknameTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingNicknameDesc,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: widget.nicknameController,
            decoration: InputDecoration(
              hintText: l10n.onboardingNicknameHint,
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            onChanged: (_) {
              setState(() {});
            },
          ),
          if (widget.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          if (widget.showGenerateButton) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: _handleGenerate,
              child: Text(
                l10n.onboardingNicknameGenerate,
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
          const Spacer(),
          if (widget.child != null) ...[
            const SizedBox(height: 16),
            widget.child!,
          ],
        ],
      ),
    );
  }
}
