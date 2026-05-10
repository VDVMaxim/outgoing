import 'package:uuid/uuid.dart';

enum VibeActionType { checkIn, vibeUpdate, squadInvite, earlyBird, explorer }

extension VibeActionTypeExtension on VibeActionType {
  String get displayName {
    switch (this) {
      case VibeActionType.checkIn:
        return 'Check-in';
      case VibeActionType.vibeUpdate:
        return 'Vibe Update';
      case VibeActionType.squadInvite:
        return 'Squad Invite';
      case VibeActionType.earlyBird:
        return 'Early Bird';
      case VibeActionType.explorer:
        return 'Explorer';
    }
  }

  String get dbValue {
    switch (this) {
      case VibeActionType.checkIn:
        return 'check_in';
      case VibeActionType.vibeUpdate:
        return 'vibe_update';
      case VibeActionType.squadInvite:
        return 'squad_invite';
      case VibeActionType.earlyBird:
        return 'early_bird';
      case VibeActionType.explorer:
        return 'explorer';
    }
  }

  static VibeActionType fromDbValue(String value) {
    switch (value) {
      case 'check_in':
        return VibeActionType.checkIn;
      case 'vibe_update':
        return VibeActionType.vibeUpdate;
      case 'squad_invite':
        return VibeActionType.squadInvite;
      case 'early_bird':
        return VibeActionType.earlyBird;
      case 'explorer':
        return VibeActionType.explorer;
      default:
        return VibeActionType.checkIn;
    }
  }
}

class VibeAction {
  final String id;
  final String odUserId;
  final VibeActionType actionType;
  final String? placeId;
  final int vpEarned;
  final DateTime createdAt;

  const VibeAction({
    required this.id,
    required this.odUserId,
    required this.actionType,
    this.placeId,
    required this.vpEarned,
    required this.createdAt,
  });

  factory VibeAction.fromJson(Map<String, dynamic> json) {
    return VibeAction(
      id: json['id'] as String? ?? const Uuid().v4(),
      odUserId: json['user_id'] as String,
      actionType: VibeActionTypeExtension.fromDbValue(
        json['action_type'] as String,
      ),
      placeId: json['place_id'] as String?,
      vpEarned: json['vp_earned'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': odUserId,
      'action_type': actionType.dbValue,
      'place_id': placeId,
      'vp_earned': vpEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
