import 'package:flutter_clubapp/features/vibe/domain/models/vibe_check.dart';

abstract class VibeRepository {
  Future<void> submitVibeCheck({
    required String placeId,
    required bool isPositive,
  });

  Future<List<VibeCheck>> getVibeChecksForPlace(
    String placeId, {
    int limit = 10,
  });
}
