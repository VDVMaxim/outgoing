import 'package:latlong2/latlong.dart';

class SquadPin {
  final String id;
  final String squadId;
  final String creatorId;
  final LatLng position;
  final DateTime targetTime;
  final DateTime createdAt;
  final List<String> joinedUserIds;

  const SquadPin({
    required this.id,
    required this.squadId,
    required this.creatorId,
    required this.position,
    required this.targetTime,
    required this.createdAt,
    this.joinedUserIds = const [],
  });

  factory SquadPin.fromJson(Map<String, dynamic> json) {
    final joinsRaw = json['squad_pin_joins'] as List<dynamic>? ?? [];
    final joins = joinsRaw.map((j) => j['user_id'] as String).toList();

    return SquadPin(
      id: json['id'] as String,
      squadId: json['squad_id'] as String,
      creatorId: json['creator_id'] as String,
      position: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      targetTime: DateTime.parse(json['target_time'] as String).toLocal(),
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      joinedUserIds: joins,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'creator_id': creatorId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'target_time': targetTime.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  SquadPin copyWith({
    String? id,
    String? squadId,
    String? creatorId,
    LatLng? position,
    DateTime? targetTime,
    DateTime? createdAt,
    List<String>? joinedUserIds,
  }) {
    return SquadPin(
      id: id ?? this.id,
      squadId: squadId ?? this.squadId,
      creatorId: creatorId ?? this.creatorId,
      position: position ?? this.position,
      targetTime: targetTime ?? this.targetTime,
      createdAt: createdAt ?? this.createdAt,
      joinedUserIds: joinedUserIds ?? this.joinedUserIds,
    );
  }
}
