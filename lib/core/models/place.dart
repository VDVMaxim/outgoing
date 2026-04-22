import 'package:latlong2/latlong.dart';
import 'opening_hour.dart';

enum LocationType { club, food, emergency }

enum ClubStatus { open, event, closed }

class Place {
  final String id;
  final String name;
  final String? address;
  final LatLng location;
  final LocationType type;
  final String? genre;
  final List<String> tags;
  final ClubStatus status;
  final String? eventName;
  final String? organizer;
  final String? promo;
  final bool isFlashPromoActive;
  final String? poi;
  final int recentLikes;
  final int recentDislikes;
  final String? waitTime;
  final String? openingHoursRaw;
  final List<OpeningHour> openingHours;
  final DateTime? lastVibeUpdate;
  final List<String> facilities;
  final bool isVereniging;
  final DateTime? startTime;

  const Place({
    required this.id,
    required this.name,
    this.address,
    required this.location,
    required this.type,
    this.genre,
    this.tags = const [],
    required this.status,
    this.eventName,
    this.organizer,
    this.promo,
    this.isFlashPromoActive = false,
    this.poi,
    this.recentLikes = 0,
    this.recentDislikes = 0,
    this.waitTime,
    this.openingHoursRaw,
    this.openingHours = const [],
    this.lastVibeUpdate,
    this.facilities = const [],
    this.isVereniging = false,
    this.startTime,
  });

  int get hotnessScore => recentLikes - recentDislikes;

  bool get hasValidLocation => location.latitude != 0.0 && location.longitude != 0.0;

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
        orElse: () => LocationType.club,
      ),
      genre: json['genre'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      status: ClubStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ClubStatus.closed,
      ),
      eventName: json['event_name'] as String?,
      organizer: json['organizer'] as String?,
      promo: json['promo'] as String?,
      isFlashPromoActive: json['is_flash_promo_active'] as bool? ?? false,
      poi: json['poi'] as String?,
      recentLikes: json['recent_likes'] as int? ?? 0,
      recentDislikes: json['recent_dislikes'] as int? ?? 0,
      waitTime: json['wait_time'] as String?,
      openingHoursRaw: json['opening_hours_raw'] as String?,
      openingHours: (json['opening_hours'] as List<dynamic>?)
              ?.map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastVibeUpdate: json['last_vibe_update'] != null
          ? DateTime.parse(json['last_vibe_update'] as String)
          : null,
      facilities: (json['facilities'] as List<dynamic>?)?.cast<String>() ?? [],
      isVereniging: json['is_vereniging'] as bool? ?? false,
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
      'status': status.name,
      'event_name': eventName,
      'organizer': organizer,
      'promo': promo,
      'is_flash_promo_active': isFlashPromoActive,
      'poi': poi,
      'recent_likes': recentLikes,
      'recent_dislikes': recentDislikes,
      'wait_time': waitTime,
      'opening_hours_raw': openingHoursRaw,
      'opening_hours': openingHours.map((e) => e.toJson()).toList(),
      'last_vibe_update': lastVibeUpdate?.toIso8601String(),
      'facilities': facilities,
      'is_vereniging': isVereniging,
      'start_time': startTime?.toIso8601String(),
    };
  }

  static DateTime? _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
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
    ClubStatus? status,
    String? eventName,
    String? organizer,
    String? promo,
    bool? isFlashPromoActive,
    String? poi,
    int? recentLikes,
    int? recentDislikes,
    String? waitTime,
    String? openingHoursRaw,
    List<OpeningHour>? openingHours,
    DateTime? lastVibeUpdate,
    List<String>? facilities,
    bool? isVereniging,
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
      status: status ?? this.status,
      eventName: eventName ?? this.eventName,
      organizer: organizer ?? this.organizer,
      promo: promo ?? this.promo,
      isFlashPromoActive: isFlashPromoActive ?? this.isFlashPromoActive,
      poi: poi ?? this.poi,
      recentLikes: recentLikes ?? this.recentLikes,
      recentDislikes: recentDislikes ?? this.recentDislikes,
      waitTime: waitTime ?? this.waitTime,
      openingHoursRaw: openingHoursRaw ?? this.openingHoursRaw,
      openingHours: openingHours ?? this.openingHours,
      lastVibeUpdate: lastVibeUpdate ?? this.lastVibeUpdate,
      facilities: facilities ?? this.facilities,
      isVereniging: isVereniging ?? this.isVereniging,
      startTime: startTime ?? this.startTime,
    );
  }

  bool get isOpen => status != ClubStatus.closed;
}