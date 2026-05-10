import 'package:latlong2/latlong.dart';
import 'opening_hour.dart';

enum LocationType { club, food, emergency, place }

enum ClubStatus { open, event, closed }

class Place {
  final String id;
  final String name;
  final String? address;
  final LatLng location;
  final LocationType type;
  final String? genre;
  final List<String> tags;
  final String? eventName;
  final String? organizer;
  final String? promo;
  final String? poi;
  final int recentLikes;
  final int recentDislikes;
  final String? openingHoursRaw;
  final List<OpeningHour> openingHours;
  final DateTime? lastVibeUpdate;
  final List<String> facilities;
  final List<String> associations;
  final DateTime? startTime;

  const Place({
    required this.id,
    required this.name,
    this.address,
    required this.location,
    required this.type,
    this.genre,
    this.tags = const [],
    this.eventName,
    this.organizer,
    this.promo,
    this.poi,
    this.recentLikes = 0,
    this.recentDislikes = 0,
    this.openingHoursRaw,
    this.openingHours = const [],
    this.lastVibeUpdate,
    this.facilities = const [],
    this.associations = const [],
    this.startTime,
  });

  int get hotnessScore => recentLikes - recentDislikes;

  bool get hasValidLocation =>
      location.latitude != 0.0 && location.longitude != 0.0;

  bool get isFlashPromoActive => promo != null && promo!.isNotEmpty;

  bool get isVereniging => associations.isNotEmpty;

  ClubStatus get status {
    if (eventName != null || startTime != null) return ClubStatus.event;

    final now = DateTime.now();
    final currentDay = now.weekday == 7 ? 0 : now.weekday;
    final currentTime = now.hour * 60 + now.minute;

    for (final oh in openingHours) {
      if (oh.dayOfWeek == currentDay) {
        final openParts = oh.openTime.split(':');
        final closeParts = oh.closeTime.split(':');

        if (openParts.length >= 2 && closeParts.length >= 2) {
          final openTime =
              int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
          var closeTime =
              int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);

          if (closeTime < openTime) closeTime += 24 * 60;

          var checkTime = currentTime;
          if (currentTime < openTime && currentTime < closeTime - 24 * 60) {
            checkTime += 24 * 60;
          }

          if (checkTime >= openTime && checkTime <= closeTime) {
            return ClubStatus.open;
          }
        }
      }
    }
    return ClubStatus.closed;
  }

  bool get isOpen => status != ClubStatus.closed;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      location: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      type: LocationType.values.firstWhere(
        (e) => e.name == json['location_type'],
        orElse: () => LocationType.place,
      ),
      genre: json['genre'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      eventName: json['event_name'] as String?,
      organizer: json['organizer'] as String?,
      promo: json['promo'] as String?,
      poi: json['poi'] as String?,
      recentLikes: json['recent_likes'] as int? ?? 0,
      recentDislikes: json['recent_dislikes'] as int? ?? 0,
      openingHoursRaw: json['opening_hours_raw'] as String?,
      openingHours:
          (json['opening_hours'] as List<dynamic>?)
              ?.map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastVibeUpdate: json['last_vibe_update'] != null
          ? DateTime.parse(json['last_vibe_update'] as String)
          : null,
      facilities: (json['facilities'] as List<dynamic>?)?.cast<String>() ?? [],
      associations:
          (json['associations'] as List<dynamic>?)?.cast<String>() ?? [],
      startTime: json['start_time'] != null
          ? _parseTime(json['start_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'location_type': type.name,
      'genre': genre,
      'tags': tags,
      'event_name': eventName,
      'organizer': organizer,
      'promo': promo,
      'poi': poi,
      'recent_likes': recentLikes,
      'recent_dislikes': recentDislikes,
      'opening_hours_raw': openingHoursRaw,
      'opening_hours': openingHours.map((e) => e.toJson()).toList(),
      'last_vibe_update': lastVibeUpdate?.toIso8601String(),
      'facilities': facilities,
      'associations': associations,
      'start_time': startTime?.toIso8601String(),
    };
  }

  static DateTime? _parseTime(String timeStr) {
    final parsed = DateTime.tryParse(timeStr);
    if (parsed != null) return parsed;

    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      try {
        final now = DateTime.now();
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Place copyWith({
    String? id,
    String? name,
    String? address,
    LatLng? location,
    LocationType? type,
    String? genre,
    List<String>? tags,
    String? eventName,
    String? organizer,
    String? promo,
    String? poi,
    int? recentLikes,
    int? recentDislikes,
    String? openingHoursRaw,
    List<OpeningHour>? openingHours,
    DateTime? lastVibeUpdate,
    List<String>? facilities,
    List<String>? associations,
    DateTime? startTime,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      location: location ?? this.location,
      type: type ?? this.type,
      genre: genre ?? this.genre,
      tags: tags ?? this.tags,
      eventName: eventName ?? this.eventName,
      organizer: organizer ?? this.organizer,
      promo: promo ?? this.promo,
      poi: poi ?? this.poi,
      recentLikes: recentLikes ?? this.recentLikes,
      recentDislikes: recentDislikes ?? this.recentDislikes,
      openingHoursRaw: openingHoursRaw ?? this.openingHoursRaw,
      openingHours: openingHours ?? this.openingHours,
      lastVibeUpdate: lastVibeUpdate ?? this.lastVibeUpdate,
      facilities: facilities ?? this.facilities,
      associations: associations ?? this.associations,
      startTime: startTime ?? this.startTime,
    );
  }
}
