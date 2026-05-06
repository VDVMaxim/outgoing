import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final bool obscureText;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int? maxLength;
  final String? initialValue;

  const AppTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.obscureText = false,
    this.trailing,
    this.onTrailingTap,
    this.errorText,
    this.keyboardType,
    this.onChanged,
    this.autofocus = false,
    this.maxLength,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
          child: trailing != null
              ? Row(
                  children: [
                    Expanded(
                      child: ShadInput(
                        controller: controller,
                        placeholder: Text(placeholder ?? ''),
                        obscureText: obscureText,
                        keyboardType: keyboardType,
                        onChanged: onChanged,
                        autofocus: autofocus,
                        maxLength: maxLength,
                        initialValue: initialValue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: onTrailingTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: trailing,
                        ),
                      ),
                    ),
                  ],
                )
              : ShadInput(
                  controller: controller,
                  placeholder: Text(placeholder ?? ''),
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  autofocus: autofocus,
                  maxLength: maxLength,
                  initialValue: initialValue,
                ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
