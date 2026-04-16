import 'dart:async';

import 'package:flutter_clubapp/core/repositories/repository_provider.dart';

enum AppStartupFailureKind {
  timeout,
  unknown,
}

class AppStartupResult {
  const AppStartupResult._({
    required this.ok,
    this.failureKind,
    this.detail,
  });

  const AppStartupResult.success() : this._(ok: true);

  factory AppStartupResult.failure(
    AppStartupFailureKind kind, {
    String? detail,
  }) =>
      AppStartupResult._(ok: false, failureKind: kind, detail: detail);

  final bool ok;
  final AppStartupFailureKind? failureKind;
  final String? detail;
}

/// Validates essential services and loads [clubRepository] data before the app continues.
class AppStartup {
  AppStartup._();

  static const Duration _placesTimeout = Duration(seconds: 15);

  static Future<AppStartupResult> verify() async {
    try {
      await clubRepository
          .getPlaces()
          .timeout(_placesTimeout, onTimeout: () => throw TimeoutException('places'));
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
