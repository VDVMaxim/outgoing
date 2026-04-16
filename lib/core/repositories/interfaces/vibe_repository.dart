import '../../models/vibe_check.dart';

abstract class VibeRepository {
  Future<void> submitVibeCheck({
    required String placeId,
    required String crowdLevel,
    required int energy,
  });
  Future<List<VibeCheck>> getVibeChecksForPlace(
    String placeId, {
    int limit = 10,
  });
}
