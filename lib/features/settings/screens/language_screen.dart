import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/settings/presentation/providers/settings_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsLanguage,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LanguageOption(
            flag: '🇧🇪',
            name: l10n.settingsLanguageNl,
            locale: const Locale('nl'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _LanguageOption(
            flag: '🇫🇷',
            name: l10n.settingsLanguageFr,
            locale: const Locale('fr'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _LanguageOption(
            flag: '🇬🇧',
            name: l10n.settingsLanguageEn,
            locale: const Locale('en'),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends ConsumerWidget {
  final String flag;
  final String name;
  final Locale locale;
  final bool isDark;

  const _LanguageOption({
    required this.flag,
    required this.name,
    required this.locale,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isSelected =
        currentLocale?.languageCode == locale.languageCode ||
        (currentLocale == null &&
            Localizations.localeOf(context).languageCode ==
                locale.languageCode);

    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.1)
              : (isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blueAccent,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
