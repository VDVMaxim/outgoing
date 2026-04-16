import '../../models/place.dart';

abstract class ClubRepository {
  Future<List<Place>> getPlaces();
  Future<Place?> getPlaceById(String id);
}
