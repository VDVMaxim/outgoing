import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/constants/env.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'package:flutter_clubapp/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_clubapp/core/providers/shared_prefs_provider.dart';
import 'package:flutter_clubapp/core/services/push_notification_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

const Color _kSplashSurface = Color(0xFF09090B);

ThemeData _appThemeForBrightness(Brightness brightness) {
  if (brightness == Brightness.dark) {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: _kSplashSurface,
      canvasColor: _kSplashSurface,
    );
  }
  return ThemeData.light(
    useMaterial3: true,
  ).copyWith(scaffoldBackgroundColor: Colors.white, canvasColor: Colors.white);
}

Future<void> _initializeSupabase() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeSupabase();

  // Laad SharedPreferences zodat onze Notifiers er synchroon aan kunnen
  final prefs = await SharedPreferences.getInstance();

  final pushService = PushNotificationService();
  pushService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        pushNotificationServiceProvider.overrideWithValue(pushService),
      ],
      child: const ClubApp(),
    ),
  );
}

class ClubApp extends ConsumerWidget {
  const ClubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return ShadApp(
      debugShowCheckedModeBanner: false,
      themeMode: currentMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('nl'), Locale('en'), Locale('fr')],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (locale != null) return locale;
        if (deviceLocale == null) return const Locale('en');
        for (final supported in supportedLocales) {
          if (supported.languageCode == deviceLocale.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },
      builder: (context, child) {
        final brightness = currentMode == ThemeMode.system
            ? MediaQuery.platformBrightnessOf(context)
            : (currentMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light);
        return ShadTheme(
          data: ShadThemeData(brightness: brightness),
          child: ShadSonner(
            child: ScaffoldMessenger(
              child: Theme(
                data: _appThemeForBrightness(brightness),
                child: child!,
              ),
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
