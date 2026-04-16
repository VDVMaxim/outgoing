import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Haptics only for squad sync (create or join). Intentionally subtle.
class HapticService {
  HapticService._();

  /// Light confirmation when your squad is live or you joined another device’s squad.
  static Future<void> squadSync() async {
    if (kIsWeb) return;
    await HapticFeedback.mediumImpact();
  }
}
