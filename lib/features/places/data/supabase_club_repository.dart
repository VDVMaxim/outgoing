import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/features/places/domain/models/place.dart';
import 'package:flutter_clubapp/features/places/domain/repositories/club_repository.dart';

class RepositoryException implements Exception {
  final String message;
  final dynamic originalError;
  RepositoryException(this.message, [this.originalError]);
  @override
  String toString() =>
      'RepositoryException: $message ${originalError != null ? "($originalError)" : ""}';
}

class SupabaseClubRepository implements ClubRepository {
  final SupabaseClient _client;

  // De missende constructor is nu toegevoegd!
  SupabaseClubRepository(this._client);

  Future<List<Place>> _enrichPlaces(List<dynamic> placesList) async {
    if (placesList.isEmpty) return [];

    final placeIds = placesList.map((p) => p['id'].toString()).toList();

    final List<dynamic> tagsWithNames = [];
    final List<dynamic> assocsWithNames = [];
    final List<dynamic> openingHoursList = [];
    final List<dynamic> vibesList = [];

    const int chunkSize = 150;

    for (var i = 0; i < placeIds.length; i += chunkSize) {
      final end = (i + chunkSize < placeIds.length)
          ? i + chunkSize
          : placeIds.length;
      final chunk = placeIds.sublist(i, end);

      final tagsChunk = await _client
          .from('place_tags')
          .select('place_id, tags!inner(name, category)')
          .inFilter('place_id', chunk);
      tagsWithNames.addAll(tagsChunk);

      final assocChunk = await _client
          .from('association_places')
          .select('place_id, associations!inner(name)')
          .inFilter('place_id', chunk);
      assocsWithNames.addAll(assocChunk);

      final hoursChunk = await _client
          .from('opening_hours')
          .select()
          .inFilter('place_id', chunk)
          .order('day_of_week', ascending: true);
      openingHoursList.addAll(hoursChunk);

      final vibesChunk = await _client
          .from('vibe_checks')
          .select('place_id, is_positive, created_at')
          .inFilter('place_id', chunk);
      vibesList.addAll(vibesChunk);
    }

    final tagsByPlace = <String, List<String>>{};
    final facilitiesByPlace = <String, List<String>>{};

    for (final tagRow in tagsWithNames) {
      final placeId = tagRow['place_id'] as String;
      final tagData = tagRow['tags'];
      if (tagData != null && tagData['name'] != null) {
        if (tagData['category'] == 'facility') {
          facilitiesByPlace
              .putIfAbsent(placeId, () => [])
              .add(tagData['name'] as String);
        } else {
          tagsByPlace
              .putIfAbsent(placeId, () => [])
              .add(tagData['name'] as String);
        }
      }
    }

    final assocsByPlace = <String, List<String>>{};
    for (final assocRow in assocsWithNames) {
      final placeId = assocRow['place_id'] as String;
      final assocData = assocRow['associations'];
      if (assocData != null && assocData['name'] != null) {
        assocsByPlace
            .putIfAbsent(placeId, () => [])
            .add(assocData['name'] as String);
      }
    }

    final hoursByPlace = <String, List<dynamic>>{};
    for (final hour in openingHoursList) {
      final placeId = hour['place_id'] as String;
      hoursByPlace.putIfAbsent(placeId, () => []).add(hour);
    }

    final likesByPlace = <String, int>{};
    final dislikesByPlace = <String, int>{};
    final lastVibeByPlace = <String, DateTime>{};

    for (final vibe in vibesList) {
      final placeId = vibe['place_id'] as String;
      final isPositive = vibe['is_positive'] as bool? ?? true;
      final createdAt = DateTime.parse(vibe['created_at'] as String);

      if (isPositive) {
        likesByPlace[placeId] = (likesByPlace[placeId] ?? 0) + 1;
      } else {
        dislikesByPlace[placeId] = (dislikesByPlace[placeId] ?? 0) + 1;
      }

      if (!lastVibeByPlace.containsKey(placeId) ||
          createdAt.isAfter(lastVibeByPlace[placeId]!)) {
        lastVibeByPlace[placeId] = createdAt;
      }
    }

    return placesList.map((json) {
      final placeId = json['id'] as String;
      final enrichedJson = Map<String, dynamic>.from(json);

      enrichedJson['tags'] = tagsByPlace[placeId] ?? [];
      enrichedJson['facilities'] = facilitiesByPlace[placeId] ?? [];
      enrichedJson['associations'] = assocsByPlace[placeId] ?? [];
      enrichedJson['opening_hours'] = hoursByPlace[placeId] ?? [];
      enrichedJson['recent_likes'] = likesByPlace[placeId] ?? 0;
      enrichedJson['recent_dislikes'] = dislikesByPlace[placeId] ?? 0;
      enrichedJson['last_vibe_update'] = lastVibeByPlace[placeId]
          ?.toIso8601String();

      return Place.fromJson(enrichedJson);
    }).toList();
  }

  @override
  Future<List<Place>> getPlacesInViewport(
    double minLat,
    double minLng,
    double maxLat,
    double maxLng, {
    String searchQuery = '',
  }) async {
    try {
      final placesResponse = await _client.rpc(
        'get_place_markers_in_viewport',
        params: {
          'min_lat': minLat,
          'min_lng': minLng,
          'max_lat': maxLat,
          'max_lng': maxLng,
          'search_query': searchQuery,
        },
      );

      final eventsResponse = await _client.rpc(
        'get_event_markers_in_viewport',
        params: {
          'min_lat': minLat,
          'min_lng': minLng,
          'max_lat': maxLat,
          'max_lng': maxLng,
          'search_query': searchQuery,
        },
      );

      final List<dynamic> combinedList = [];

      if (placesResponse != null) {
        for (final p in placesResponse as Iterable<dynamic>) {
          combinedList.add({
            'id': p['id'],
            'name': '',
            'latitude': p['latitude'],
            'longitude': p['longitude'],
            'location_type': p['location_type'],
            'recent_likes': p['hotness_score'] ?? 0,
            'recent_dislikes': 0,
            'event_name': p['is_event'] == true ? 'Event' : null,
            'promo': p['is_flash_promo'] == true ? 'Promo' : null,
          });
        }
      }

      if (eventsResponse != null) {
        for (final e in eventsResponse as Iterable<dynamic>) {
          combinedList.add({
            'id': e['id'],
            'name': '',
            'event_name': 'Event',
            'latitude': e['latitude'],
            'longitude': e['longitude'],
            'location_type': 'place',
            'recent_likes': e['hotness_score'] ?? 0,
            'recent_dislikes': 0,
            'start_time': DateTime.now().toIso8601String(),
          });
        }
      }

      return combinedList.map((json) => Place.fromJson(json)).toList();
    } catch (e, stackTrace) {
      debugPrint('🚨 ERROR in getPlacesInViewport: $e\n$stackTrace');
      throw RepositoryException('Failed to fetch places in viewport', e);
    }
  }

  @override
  Future<List<Place>> getDiscoverPlaces({LatLng? userLocation}) async {
    try {
      final placesResponse = await _client.from('places').select().limit(300);

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
    } catch (e, stackTrace) {
      debugPrint('🚨 ERROR in getDiscoverPlaces: $e\n$stackTrace');
      throw RepositoryException('Failed to fetch discover places', e);
    }
  }

  @override
  Future<List<Place>> getEvents({LatLng? userLocation}) async {
    try {
      final eventsResponse = await _client
          .from('events')
          .select()
          .gte(
            'start_datetime',
            DateTime.now()
                .toUtc()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
          )
          .limit(100);

      final List<Place> mappedEvents = (eventsResponse as List<dynamic>).map((
        row,
      ) {
        final Map<String, dynamic> json = Map.from(row as Map<String, dynamic>);
        return Place(
          id: json['id'] as String,
          name: json['title'] as String,
          address: json['address'] as String?,
          location: LatLng(
            (json['latitude'] as num).toDouble(),
            (json['longitude'] as num).toDouble(),
          ),
          type: LocationType.place,
          eventName: json['title'] as String,
          startTime: DateTime.parse(json['start_datetime'] as String),
          genre: null,
          tags: [],
          organizer: null,
          promo: null,
          poi: null,
          recentLikes: 0,
          recentDislikes: 0,
          openingHoursRaw: null,
          openingHours: [],
          lastVibeUpdate: null,
          facilities: [],
          associations: [],
        );
      }).toList();

      if (userLocation != null) {
        const distance = Distance();
        mappedEvents.sort((a, b) {
          final distA = distance.as(LengthUnit.Meter, userLocation, a.location);
          final distB = distance.as(LengthUnit.Meter, userLocation, b.location);
          return distA.compareTo(distB);
        });
      } else {
        mappedEvents.sort((a, b) => a.startTime!.compareTo(b.startTime!));
      }

      return mappedEvents;
    } catch (e, stackTrace) {
      debugPrint('🚨 ERROR in getEvents: $e\n$stackTrace');
      throw RepositoryException('Failed to fetch events', e);
    }
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    try {
      final placeResponse = await _client
          .from('places')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (placeResponse == null) return null;

      final result = await _enrichPlaces([placeResponse]);
      return result.isNotEmpty ? result.first : null;
    } catch (e, stackTrace) {
      debugPrint('🚨 ERROR in getPlaceById: $e\n$stackTrace');
      throw RepositoryException('Failed to fetch place by ID', e);
    }
  }
}
