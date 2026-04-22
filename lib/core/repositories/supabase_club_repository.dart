import 'package:flutter/foundation.dart';
import '../config/supabase_client.dart';
import '../models/place.dart';
import 'interfaces/club_repository.dart';

class SupabaseClubRepository implements ClubRepository {
  
  Future<List<Place>> _enrichPlaces(List<dynamic> placesList) async {
    if (placesList.isEmpty) return [];
    
    final client = SupabaseClientProvider.client;
    final placeIds = placesList.map((p) => p['id'].toString()).toList();

    final List<dynamic> tagsWithNames = [];
    final List<dynamic> facilitiesWithNames = [];
    const int chunkSize = 150;

    for (var i = 0; i < placeIds.length; i += chunkSize) {
      final end = (i + chunkSize < placeIds.length) ? i + chunkSize : placeIds.length;
      final chunk = placeIds.sublist(i, end);

      final tagsChunk = await client
          .from('venue_tags')
          .select('venue_id, tags:tag_id(name)')
          .inFilter('venue_id', chunk);
      tagsWithNames.addAll(tagsChunk);

      final facilitiesChunk = await client
          .from('venue_facilities')
          .select('venue_id, facilities:facility_id(name)')
          .inFilter('venue_id', chunk);
      facilitiesWithNames.addAll(facilitiesChunk);
    }

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

    return placesList.map((json) {
      final placeId = json['id'] as String;
      final enrichedJson = Map<String, dynamic>.from(json);
      enrichedJson['tags'] = tagsByPlace[placeId] ?? [];
      enrichedJson['facilities'] = facilitiesByPlace[placeId] ?? [];
      return Place.fromJson(enrichedJson);
    }).toList();
  }

  @override
  Future<List<Place>> getPlacesInViewport(double minLat, double minLng, double maxLat, double maxLng) async {
    final client = SupabaseClientProvider.client;

    try {
      final placesResponse = await client.rpc('get_venues_in_viewport', params: {
        'min_lat': minLat,
        'min_lng': minLng,
        'max_lat': maxLat,
        'max_lng': maxLng,
      });

      if (placesResponse == null) return [];
      
      final List<dynamic> placesList = List<dynamic>.from(placesResponse as Iterable<dynamic>);
      return await _enrichPlaces(placesList);
    } catch (e) {
      debugPrint('🚨 CRASH PREVENTED in getPlacesInViewport: $e');
      return [];
    }
  }

  @override
  Future<List<Place>> getDiscoverPlaces() async {
    final client = SupabaseClientProvider.client;

    try {
      final placesResponse = await client
          .from('venues')
          .select()
          .or('location_type.eq.club,status.eq.event,is_flash_promo_active.eq.true')
          .limit(1000);
      
      return await _enrichPlaces(placesResponse as List<dynamic>);
    } catch (e) {
      debugPrint('🚨 CRASH PREVENTED in getDiscoverPlaces: $e');
      return [];
    }
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    final client = SupabaseClientProvider.client;

    try {
      final placeResponse = await client
          .from('venues')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (placeResponse == null) return null;
      
      final result = await _enrichPlaces([placeResponse]);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('🚨 CRASH PREVENTED in getPlaceById: $e');
      return null;
    }
  }
}