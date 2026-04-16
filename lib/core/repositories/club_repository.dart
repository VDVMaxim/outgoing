import '../models.dart';

abstract class ClubRepository {
  Future<List<Place>> getPlaces();
  Future<Place?> getPlaceById(String id);
}
