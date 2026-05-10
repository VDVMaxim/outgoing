import 'package:flutter_clubapp/features/places/presentation/providers/place_provider.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum AppStartupFailureKind { timeout, unknown }

class AppStartupResult {
  const AppStartupResult._({required this.ok, this.failureKind, this.detail});
  const AppStartupResult.success() : this._(ok: true);
  factory AppStartupResult.failure(
    AppStartupFailureKind kind, {
    String? detail,
  }) => AppStartupResult._(ok: false, failureKind: kind, detail: detail);

  final bool ok;
  final AppStartupFailureKind? failureKind;
  final String? detail;
}

class AppStartup {
  AppStartup._();
  static const Duration _placesTimeout = Duration(seconds: 15);

  static Future<AppStartupResult> verify(ProviderContainer container) async {
    try {
      final repo = container.read(clubRepositoryProvider);
      await repo.getDiscoverPlaces().timeout(
        _placesTimeout,
        onTimeout: () => throw TimeoutException('places'),
      );
      return const AppStartupResult.success();
    } on TimeoutException {
      return AppStartupResult.failure(AppStartupFailureKind.timeout);
    } catch (e) {
      return AppStartupResult.failure(
        AppStartupFailureKind.unknown,
        detail: e.toString(),
      );
    }
  }
}
