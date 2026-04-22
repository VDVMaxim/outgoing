import '../../models/place.dart';

abstract class ClubRepository {
  Future<List<Place>> getPlacesInViewport(double minLat, double minLng, double maxLat, double maxLng);
  Future<List<Place>> getDiscoverPlaces();
  Future<Place?> getPlaceById(String id);
}