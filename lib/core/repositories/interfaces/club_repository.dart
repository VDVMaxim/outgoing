import 'package:latlong2/latlong.dart';
import '../../models/place.dart';

abstract class ClubRepository {
  Future<List<Place>> getPlacesInViewport(double minLat, double minLng, double maxLat, double maxLng, {String searchQuery = ''});
  Future<List<Place>> getDiscoverPlaces({LatLng? userLocation});
  Future<List<Place>> getEvents({LatLng? userLocation});
  Future<Place?> getPlaceById(String id);
}