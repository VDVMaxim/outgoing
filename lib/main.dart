import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/constants/env.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'core/config/supabase_config.dart';
import 'core/config/supabase_client.dart';
import 'core/providers/service_providers.dart';
import 'core/services/user_profile_service.dart';
import 'core/services/settings_service.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);
const Color _kSplashSurface = Color(0xFF09090B);

ThemeData _appThemeForBrightness(Brightness brightness) {
  if (brightness == Brightness.dark) {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: _kSplashSurface,
      canvasColor: _kSplashSurface,
    );
  }
  return ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
  );
}

Future<void> _initializeSupabase() async {
  if (!await SupabaseConfig.hasCredentials()) {
    await SupabaseConfig.setUrl(Env.supabaseUrl);
    await SupabaseConfig.setAnonKey(Env.supabaseAnonKey);
  }
  await SupabaseClientProvider.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSupabase();
  
  await UserProfileService.getInstance();
  
  // 1. Wacht tot de settings service volledig is ingeladen en sla hem op in een variabele
  final ingeladenSettingsService = await SettingsService.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // 2. Injecteer de ingeladen service direct in de provider!
        settingsServiceProvider.overrideWithValue(ingeladenSettingsService),
      ],
      child: const ClubApp(),
    ),
  );
}

class ClubApp extends StatelessWidget {
  const ClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return ValueListenableBuilder<Locale?>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
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
              supportedLocales: const [
                Locale('nl'),
                Locale('en'),
                Locale('fr'),
              ],
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
          },
        );
      },
    );
  }
}