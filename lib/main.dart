import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'core/config/supabase_config.dart';
import 'core/config/supabase_client.dart';
import 'core/repositories/repository_provider.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

final ValueNotifier<Locale?> localeNotifier = ValueNotifier(null);

const Color _kSplashSurface = Color(0xFF09090B);

const _supabaseUrl = 'https://gucwsgnxvawtfrnhnqtw.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1Y3dzZ254dmF3dGZybmhucXR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYyNTUyMzgsImV4cCI6MjA5MTgzMTIzOH0.lhrZ0RAs9PzCf3tCBloim-tpsAB9_wifNtqTgu169ws';

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
  if (!await SupabaseConfig.hasCredentials()) {
    await SupabaseConfig.setUrl(_supabaseUrl);
    await SupabaseConfig.setAnonKey(_supabaseAnonKey);
  }

  await SupabaseClientProvider.initialize();
  initializeRepositories();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeSupabase();

  runApp(const ClubApp());
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
