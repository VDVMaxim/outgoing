import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
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
    final List<dynamic> openingHoursList = [];
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

      final hoursChunk = await client
          .from('opening_hours')
          .select()
          .inFilter('venue_id', chunk)
          .order('day_of_week', ascending: true);
      openingHoursList.addAll(hoursChunk);
    }

    final tagsByPlace = <String, List<String>>{};
    for (final tag in tagsWithNames) {
      final placeId = tag['venue_id'] as String;
      final tagData = tag['tags'];
      if (tagData != null && tagData['name'] != null) {
        tagsByPlace.putIfAbsent(placeId, () => []).add(tagData['name'] as String);
      }
    }

    final facilitiesByPlace = <String, List<String>>{};
    for (final facility in facilitiesWithNames) {
      final placeId = facility['venue_id'] as String;
      final facilityData = facility['facilities'];
      if (facilityData != null && facilityData['name'] != null) {
        facilitiesByPlace.putIfAbsent(placeId, () => []).add(facilityData['name'] as String);
      }
    }

    final hoursByPlace = <String, List<dynamic>>{};
    for (final hour in openingHoursList) {
      final placeId = hour['venue_id'] as String;
      hoursByPlace.putIfAbsent(placeId, () => []).add(hour);
    }

    return placesList.map((json) {
      final placeId = json['id'] as String;
      final enrichedJson = Map<String, dynamic>.from(json);
      enrichedJson['tags'] = tagsByPlace[placeId] ?? [];
      enrichedJson['facilities'] = facilitiesByPlace[placeId] ?? [];
      enrichedJson['opening_hours'] = hoursByPlace[placeId] ?? [];
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
  Future<List<Place>> getDiscoverPlaces({LatLng? userLocation}) async {
    final client = SupabaseClientProvider.client;

    try {
      final placesResponse = await client
          .from('venues')
          .select()
          .limit(300);
      
      final enriched = await _enrichPlaces(placesResponse as List<dynamic>);

      if (userLocation != null) {
        const distance = Distance();
        enriched.sort((a, b) {
          final distA = distance.as(LengthUnit.Meter, userLocation, a.location);
          final distB = distance.as(LengthUnit.Meter, userLocation, b.location);
          return distA.compareTo(distB);
        });
      } else {
        enriched.sort((a, b) => b.hotnessScore.compareTo(a.hotnessScore));
      }

      return enriched.take(100).toList();
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