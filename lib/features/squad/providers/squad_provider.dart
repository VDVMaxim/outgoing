import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/core/models/squad_member.dart' as models;
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/repositories/interfaces/squad_repository.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/services/location_service.dart';

const double _positionUpdateThresholdMeters = 5.0;
const int _positionUpdateFallbackSeconds = 30;

enum SquadConnectionStatus { disconnected, connecting, connected, error }

class SquadProviderState {
  final SquadConnectionStatus status;
  final String? squadId;
  final String? squadPin;
  final String? memberId;
  final List<SquadMemberDisplay> members;
  final String? errorMessage;

  const SquadProviderState({
    this.status = SquadConnectionStatus.disconnected,
    this.squadId,
    this.squadPin,
    this.memberId,
    this.members = const [],
    this.errorMessage,
  });

  bool get isInSquad => status == SquadConnectionStatus.connected;

  SquadProviderState copyWith({
    SquadConnectionStatus? status,
    String? squadId,
    String? squadPin,
    String? memberId,
    List<SquadMemberDisplay>? members,
    String? errorMessage,
  }) {
    return SquadProviderState(
      status: status ?? this.status,
      squadId: squadId ?? this.squadId,
      squadPin: squadPin ?? this.squadPin,
      memberId: memberId ?? this.memberId,
      members: members ?? this.members,
      errorMessage: errorMessage,
    );
  }
}

class SquadMemberDisplay {
  final String id;
  final String odmemberId;
  final String nickname;
  final String? avatarUrl;
  final LatLng position;
  final DateTime lastUpdate;
  final bool isOnline;
  final bool isCurrentUser;

  const SquadMemberDisplay({
    required this.id,
    required this.odmemberId,
    required this.nickname,
    this.avatarUrl,
    required this.position,
    required this.lastUpdate,
    required this.isOnline,
    required this.isCurrentUser,
  });

  factory SquadMemberDisplay.fromModel(
    models.SquadMember model,
    String currentUserId,
    int offlineThresholdMs,
  ) {
    final now = DateTime.now();
    final lastUpdate = model.updatedAt;
    final isOnline = now.difference(lastUpdate).inMilliseconds < offlineThresholdMs;

    return SquadMemberDisplay(
      id: model.id,
      odmemberId: model.userId,
      nickname: model.nickname,
      avatarUrl: null,
      position: LatLng(model.latitude, model.longitude),
      lastUpdate: lastUpdate,
      isOnline: isOnline,
      isCurrentUser: model.userId == currentUserId,
    );
  }

  SquadMemberDisplay copyWith({
    LatLng? position,
    DateTime? lastUpdate,
    bool? isOnline,
  }) {
    return SquadMemberDisplay(
      id: id,
      odmemberId: odmemberId,
      nickname: nickname,
      avatarUrl: avatarUrl,
      position: position ?? this.position,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isOnline: isOnline ?? this.isOnline,
      isCurrentUser: isCurrentUser,
    );
  }
}

class SquadNotifier extends StateNotifier<SquadProviderState> {
  final Ref _ref;

  Timer? _positionUpdateTimer;
  Timer? _onlineCheckTimer;
  StreamSubscription<List<models.SquadMember>>? _realtimeSubscription;

  VoidCallback? _onPositionPulse;
  LatLng? _lastSentPosition;
  DateTime? _lastSentTime;

  SquadNotifier(this._ref) : super(const SquadProviderState());

  SettingsService get _settingsService => _ref.read(settingsServiceProvider);
  UserProfileService get _userProfileService => _ref.read(userProfileServiceProvider);
  LocationService get _locationService => _ref.read(locationServiceProvider);
  SquadRepository get _squadRepository => _ref.read(squadRepositoryProvider);

  String? get currentUserId => _userProfileService.userId;

  void setPositionPulseCallback(VoidCallback? callback) {
    _onPositionPulse = callback;
  }

  Future<bool> checkLocationPermission() async {
    final status = await _locationService.checkPermission();
    return status == LocationPermissionStatus.always ||
        status == LocationPermissionStatus.whileInUse;
  }

  Future<bool> requestLocationPermission() async {
    final status = await _locationService.requestPermission();
    return status == LocationPermissionStatus.always ||
        status == LocationPermissionStatus.whileInUse;
  }

  Future<SquadProviderState> createSquad() async {
    if (!_userProfileService.hasNickname) {
      state = state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Je moet eerst een nickname instellen.',
      );
      return state;
    }

    final hasLocationPermission = await checkLocationPermission();
    if (!hasLocationPermission) {
      final granted = await requestLocationPermission();
      if (!granted) {
        state = state.copyWith(
          status: SquadConnectionStatus.error,
          errorMessage: 'Locatietoegang is geweigerd. Zet dit aan in je instellingen om Squads te gebruiken.',
        );
        return state;
      }
    }

    state = state.copyWith(status: SquadConnectionStatus.connecting);

    // 1. EERST LOCATIE CHECKEN ZONDER FALLBACKS
    LatLng userPosition;
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        userPosition = LatLng(position.latitude, position.longitude);
      } else {
        throw Exception('Locatie kon niet worden bepaald.');
      }
    } catch (e) {
      // Meteen afbreken als de GPS uit staat of geen signaal heeft
      state = state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Kan je locatie niet bepalen. Controleer of je GPS aan staat.',
      );
      return state;
    }

    // 2. PAS ALS LOCATIE GELUKT IS, SQUAD AANMAKEN IN DATABASE
    try {
      final squad = await _squadRepository.createSquad();

      final member = await _squadRepository.joinSquad(
        squad.id,
        _userProfileService.nickname ?? 'Anonymous',
        userPosition,
      );

      state = state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [
          SquadMemberDisplay.fromModel(
            member,
            currentUserId ?? '',
            _offlineThresholdMs,
          ),
        ],
      );

      _startTracking();
      _startOnlineCheck();

      _realtimeSubscription = _squadRepository
          .subscribeToSquad(squad.id)
          .listen(_onSquadMembersUpdate);

      HapticFeedback.mediumImpact();
      return state;
    } catch (e, stackTrace) {
      debugPrint('SQUAD CREATE ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      
      String userMessage = 'Er is iets misgegaan bij het aanmaken van de squad.';
      if (e.toString().contains('timeout') || e.toString().contains('connection')) {
        userMessage = 'Verbindingsfout. Controleer je internet.';
      }

      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: userMessage);
      return state;
    }
  }

  Future<SquadProviderState> joinSquad(String pin) async {
    if (!_userProfileService.hasNickname) {
      state = state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Je moet eerst een nickname instellen.',
      );
      return state;
    }

    final hasLocationPermission = await checkLocationPermission();
    if (!hasLocationPermission) {
      final granted = await requestLocationPermission();
      if (!granted) {
        state = state.copyWith(
          status: SquadConnectionStatus.error,
          errorMessage: 'Locatietoegang is geweigerd. Zet dit aan in je instellingen om Squads te gebruiken.',
        );
        return state;
      }
    }

    state = state.copyWith(status: SquadConnectionStatus.connecting);

    // 1. EERST LOCATIE CHECKEN ZONDER FALLBACKS
    LatLng userPosition;
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        userPosition = LatLng(position.latitude, position.longitude);
      } else {
        throw Exception('Locatie kon niet worden bepaald.');
      }
    } catch (e) {
      // Meteen afbreken als de GPS uit staat of geen signaal heeft
      state = state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Kan je locatie niet bepalen. Controleer of je GPS aan staat.',
      );
      return state;
    }

    // 2. PAS ALS LOCATIE GELUKT IS, SQUAD JOINEN IN DATABASE
    try {
      final squad = await _squadRepository.getSquadByPin(pin);
      if (squad == null) {
        state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Ongeldige squad PIN.');
        return state;
      }

      final member = await _squadRepository.joinSquad(
        squad.id,
        _userProfileService.nickname ?? 'Anonymous',
        userPosition,
      );

      state = state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [
          SquadMemberDisplay.fromModel(
            member,
            currentUserId ?? '',
            _offlineThresholdMs,
          ),
        ],
      );

      _startTracking();
      _startOnlineCheck();

      _realtimeSubscription = _squadRepository
          .subscribeToSquad(squad.id)
          .listen(_onSquadMembersUpdate);

      HapticFeedback.mediumImpact();
      return state;
    } catch (e, stackTrace) {
      debugPrint('SQUAD JOIN ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      
      String userMessage = 'Er is iets misgegaan bij het joinen van de squad.';
      if (e.toString().contains('timeout') || e.toString().contains('connection')) {
        userMessage = 'Verbindingsfout. Controleer je internet.';
      }

      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: userMessage);
      return state;
    }
  }

  void _startTracking() {
    _positionUpdateTimer?.cancel();
    final frequencySeconds = _settingsService.trackingFrequency;
    _positionUpdateTimer = Timer.periodic(
      Duration(seconds: frequencySeconds),
      (_) => _updateMyPosition(),
    );
  }

  void _startOnlineCheck() {
    _onlineCheckTimer?.cancel();
    final frequencySeconds = _settingsService.trackingFrequency;
    _onlineCheckTimer = Timer.periodic(
      Duration(seconds: frequencySeconds),
      (_) => _checkOnlineStatus(),
    );
  }

  Future<void> _updateMyPosition() async {
    if (state.memberId == null || state.squadId == null) return;

    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final currentPosition = LatLng(position.latitude, position.longitude);

        if (_shouldSendPositionUpdate(currentPosition)) {
          await _squadRepository.updateMemberPosition(
            state.memberId!,
            currentPosition,
          );

          _lastSentPosition = currentPosition;
          _lastSentTime = DateTime.now();
          _onPositionPulse?.call();
        }
      }
    } catch (e) {
      // Stil falen tijdens het updaten van positie is prima (als je even geen bereik hebt in de club)
    }
  }

  bool _shouldSendPositionUpdate(LatLng currentPosition) {
    if (_lastSentPosition == null || _lastSentTime == null) {
      return true;
    }

    final distance = const Distance().as(
      LengthUnit.Meter,
      _lastSentPosition!,
      currentPosition,
    );

    if (distance >= _positionUpdateThresholdMeters) {
      return true;
    }

    final timeSinceLastUpdate = DateTime.now().difference(_lastSentTime!);
    if (timeSinceLastUpdate.inSeconds >= _positionUpdateFallbackSeconds) {
      return true;
    }

    return false;
  }

  void _checkOnlineStatus() {
    if (state.members.isEmpty) return;

    final updatedMembers = state.members.map((member) {
      final now = DateTime.now();
      final timeSinceUpdate = now.difference(member.lastUpdate).inMilliseconds;
      final isOnline = timeSinceUpdate < _offlineThresholdMs;
      return member.copyWith(isOnline: isOnline);
    }).toList();

    if (!_listEquals(updatedMembers, state.members)) {
      state = state.copyWith(members: updatedMembers);
    }
  }

  void _onSquadMembersUpdate(List<models.SquadMember> modelMembers) {
    final cId = currentUserId ?? '';
    final displayMembers = modelMembers
        .map((m) => SquadMemberDisplay.fromModel(m, cId, _offlineThresholdMs))
        .toList();

    state = state.copyWith(members: displayMembers);
  }

  int get _offlineThresholdMs {
    final frequency = _settingsService.trackingFrequency;
    final multiplier = _settingsService.offlineMultiplier;
    return frequency * multiplier * 1000;
  }

  void leaveSquad() {
    _positionUpdateTimer?.cancel();
    _onlineCheckTimer?.cancel();
    _realtimeSubscription?.cancel();
    _locationService.stopTracking();

    if (state.squadId != null && currentUserId != null) {
      _squadRepository.leaveSquad(state.squadId!, currentUserId!);
    }

    _squadRepository.unsubscribeFromSquad();

    state = const SquadProviderState();
    _onPositionPulse = null;
    _lastSentPosition = null;
    _lastSentTime = null;
  }

  bool _listEquals(List<SquadMemberDisplay> a, List<SquadMemberDisplay> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id ||
          a[i].position.latitude != b[i].position.latitude ||
          a[i].position.longitude != b[i].position.longitude ||
          a[i].isOnline != b[i].isOnline) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _positionUpdateTimer?.cancel();
    _onlineCheckTimer?.cancel();
    _realtimeSubscription?.cancel();
    _locationService.stopTracking();
    super.dispose();
  }
}

final squadProvider = StateNotifierProvider<SquadNotifier, SquadProviderState>((ref) {
  return SquadNotifier(ref);
});