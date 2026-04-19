import '../config/supabase_client.dart';
import '../models/place.dart';
import 'interfaces/club_repository.dart';

class SupabaseClubRepository implements ClubRepository {
  @override
  Future<List<Place>> getPlaces() async {
    final client = SupabaseClientProvider.client;
    final placesResponse = await client.from('venues').select();

    final tagsWithNames = await client
        .from('venue_tags')
        .select('venue_id, tags:tag_id(name)');

    final facilitiesWithNames = await client
        .from('venue_facilities')
        .select('venue_id, facilities:facility_id(name)');

    final tagsByPlace = <String, List<String>>{};
    for (final tag in tagsWithNames) {
      final placeId = tag['venue_id'] as String;
      final tagData = tag['tags'];
      if (tagData != null && tagData['name'] != null) {
        tagsByPlace
            .putIfAbsent(placeId, () => [])
            .add(tagData['name'] as String);
      }
    }

    final facilitiesByPlace = <String, List<String>>{};
    for (final facility in facilitiesWithNames) {
      final placeId = facility['venue_id'] as String;
      final facilityData = facility['facilities'];
      if (facilityData != null && facilityData['name'] != null) {
        facilitiesByPlace
            .putIfAbsent(placeId, () => [])
            .add(facilityData['name'] as String);
      }
    }

    return (placesResponse as List).map((json) {
      final placeId = json['id'] as String;
      final enrichedJson = Map<String, dynamic>.from(json);
      enrichedJson['tags'] = tagsByPlace[placeId] ?? [];
      enrichedJson['facilities'] = facilitiesByPlace[placeId] ?? [];
      return Place.fromJson(enrichedJson);
    }).toList();
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    final client = SupabaseClientProvider.client;
    final placeResponse = await client
        .from('venues')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (placeResponse == null) return null;

    final tagsResponse = await client
        .from('venue_tags')
        .select('tags:tag_id(name)')
        .eq('venue_id', id);

    final facilitiesResponse = await client
        .from('venue_facilities')
        .select('facilities:facility_id(name)')
        .eq('venue_id', id);

    final enrichedJson = Map<String, dynamic>.from(placeResponse);
    enrichedJson['tags'] = (tagsResponse as List)
        .map((t) => (t['tags'] as Map<String, dynamic>?)?['name'] as String?)
        .whereType<String>()
        .toList();

    enrichedJson['facilities'] = (facilitiesResponse as List)
        .map(
          (f) => (f['facilities'] as Map<String, dynamic>?)?['name'] as String?,
        )
        .whereType<String>()
        .toList();

    return Place.fromJson(enrichedJson);
  }
}