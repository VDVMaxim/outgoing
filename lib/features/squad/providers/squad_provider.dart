import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/core/models/squad_member.dart' as models;
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/services/location_service.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';

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
    final isOnline =
        now.difference(lastUpdate).inMilliseconds < offlineThresholdMs;

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

class SquadProvider extends ChangeNotifier {
  static final SquadProvider instance = SquadProvider._internal();
  SquadProvider._internal();

  SquadProviderState _state = const SquadProviderState();
  SquadProviderState get state => _state;

  SettingsService? _settingsService;
  UserProfileService? _userProfileService;
  LocationService get _locationService => LocationService.instance;

  Timer? _positionUpdateTimer;
  Timer? _onlineCheckTimer;
  StreamSubscription<List<models.SquadMember>>? _realtimeSubscription;
  String? _currentUserId;

  VoidCallback? _onPositionPulse;

  LatLng? _lastSentPosition;
  DateTime? _lastSentTime;

  bool get isInSquad => _state.isInSquad;
  String? get squadPin => _state.squadPin;
  List<SquadMemberDisplay> get members => _state.members;

  void setPositionPulseCallback(VoidCallback? callback) {
    _onPositionPulse = callback;
  }

  Future<void> initialize() async {
    _settingsService = await SettingsService.getInstance();
    _userProfileService = await UserProfileService.getInstance();
    _currentUserId = _userProfileService?.userId;
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
    if (_userProfileService == null || !_userProfileService!.hasNickname) {
      return _state = _state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Please set a nickname first',
      );
    }

    final hasLocation = await checkLocationPermission();
    if (!hasLocation) {
      final granted = await requestLocationPermission();
      if (!granted) {
        return _state = _state.copyWith(
          status: SquadConnectionStatus.error,
          errorMessage: 'Location permission is required for squad mode',
        );
      }
    }

    _state = _state.copyWith(status: SquadConnectionStatus.connecting);
    notifyListeners();

    try {
      final squad = await squadRepository.createSquad();

      LatLng userPosition;
      try {
        final position = await _locationService.getCurrentPosition();
        if (position != null) {
          userPosition = LatLng(position.latitude, position.longitude);
        } else {
          userPosition = const LatLng(51.0543, 3.7174);
        }
      } catch (e) {
        userPosition = const LatLng(51.0543, 3.7174);
      }

      final member = await squadRepository.joinSquad(
        squad.id,
        _userProfileService!.nickname ?? 'Anonymous',
        userPosition,
      );

      _state = _state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [
          SquadMemberDisplay.fromModel(
            member,
            _currentUserId ?? '',
            _offlineThresholdMs,
          ),
        ],
      );

      _startTracking();
      _startOnlineCheck();

      _realtimeSubscription = squadRepository
          .subscribeToSquad(squad.id)
          .listen(_onSquadMembersUpdate);

      HapticFeedback.mediumImpact();

      notifyListeners();
      return _state;
    } catch (e) {
      String userMessage = 'Failed to create squad';

      if (e.toString().contains('timeout') ||
          e.toString().contains('connection')) {
        userMessage = 'Connection error. Please check your internet.';
      } else {
        userMessage = 'Something went wrong. Please try again.';
      }

      _state = _state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: userMessage,
      );
      notifyListeners();
      return _state;
    }
  }

  Future<SquadProviderState> joinSquad(String pin) async {
    if (_userProfileService == null || !_userProfileService!.hasNickname) {
      return _state = _state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: 'Please set a nickname first',
      );
    }

    final hasLocation = await checkLocationPermission();
    if (!hasLocation) {
      final granted = await requestLocationPermission();
      if (!granted) {
        return _state = _state.copyWith(
          status: SquadConnectionStatus.error,
          errorMessage: 'Location permission is required for squad mode',
        );
      }
    }

    _state = _state.copyWith(status: SquadConnectionStatus.connecting);
    notifyListeners();

    try {
      final squad = await squadRepository.getSquadByPin(pin);
      if (squad == null) {
        return _state = _state.copyWith(
          status: SquadConnectionStatus.error,
          errorMessage: 'Invalid squad PIN',
        );
      }

      final position = await _locationService.getCurrentPosition();
      final userPosition = position != null
          ? LatLng(position.latitude, position.longitude)
          : const LatLng(51.0543, 3.7174);

      final member = await squadRepository.joinSquad(
        squad.id,
        _userProfileService!.nickname ?? 'Anonymous',
        userPosition,
      );

      _state = _state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [
          SquadMemberDisplay.fromModel(
            member,
            _currentUserId ?? '',
            _offlineThresholdMs,
          ),
        ],
      );

      _startTracking();
      _startOnlineCheck();

      _realtimeSubscription = squadRepository
          .subscribeToSquad(squad.id)
          .listen(_onSquadMembersUpdate);

      HapticFeedback.mediumImpact();

      notifyListeners();
      return _state;
    } catch (e) {
      String userMessage = 'Failed to join squad';

      if (e.toString().contains('timeout') ||
          e.toString().contains('connection')) {
        userMessage = 'Connection error. Please check your internet.';
      } else {
        userMessage = 'Something went wrong. Please try again.';
      }

      _state = _state.copyWith(
        status: SquadConnectionStatus.error,
        errorMessage: userMessage,
      );
      notifyListeners();
      return _state;
    }
  }

  void _startTracking() {
    _positionUpdateTimer?.cancel();
    final frequencySeconds = _settingsService?.trackingFrequency ?? 5;

    _positionUpdateTimer = Timer.periodic(
      Duration(seconds: frequencySeconds),
      (_) => _updateMyPosition(),
    );
  }

  void _startOnlineCheck() {
    _onlineCheckTimer?.cancel();
    final frequencySeconds = _settingsService?.trackingFrequency ?? 5;

    _onlineCheckTimer = Timer.periodic(
      Duration(seconds: frequencySeconds),
      (_) => _checkOnlineStatus(),
    );
  }

  Future<void> _updateMyPosition() async {
    if (_state.memberId == null || _state.squadId == null) return;

    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final currentPosition = LatLng(position.latitude, position.longitude);

        if (_shouldSendPositionUpdate(currentPosition)) {
          await squadRepository.updateMemberPosition(
            _state.memberId!,
            currentPosition,
          );
          _lastSentPosition = currentPosition;
          _lastSentTime = DateTime.now();
          _onPositionPulse?.call();
        }
      }
    } catch (e) {
      // Silently fail position updates
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
    if (_state.members.isEmpty) return;

    final updatedMembers = _state.members.map((member) {
      final now = DateTime.now();
      final timeSinceUpdate = now.difference(member.lastUpdate).inMilliseconds;
      final isOnline = timeSinceUpdate < _offlineThresholdMs;
      return member.copyWith(isOnline: isOnline);
    }).toList();

    if (!_listEquals(updatedMembers, _state.members)) {
      _state = _state.copyWith(members: updatedMembers);
      notifyListeners();
    }
  }

  void _onSquadMembersUpdate(List<models.SquadMember> modelMembers) {
    final currentUserId = _currentUserId ?? '';

    final displayMembers = modelMembers
        .map(
          (m) => SquadMemberDisplay.fromModel(
            m,
            currentUserId,
            _offlineThresholdMs,
          ),
        )
        .toList();

    _state = _state.copyWith(members: displayMembers);
    notifyListeners();
  }

  int get _offlineThresholdMs {
    final frequency = _settingsService?.trackingFrequency ?? 5;
    final multiplier = _settingsService?.offlineMultiplier ?? 4;
    return frequency * multiplier * 1000;
  }

  void leaveSquad() {
    _positionUpdateTimer?.cancel();
    _onlineCheckTimer?.cancel();
    _realtimeSubscription?.cancel();
    _locationService.stopTracking();

    if (_state.squadId != null && _currentUserId != null) {
      squadRepository.leaveSquad(_state.squadId!, _currentUserId!);
    }

    squadRepository.unsubscribeFromSquad();

    _state = const SquadProviderState();
    _onPositionPulse = null;
    _lastSentPosition = null;
    _lastSentTime = null;
    notifyListeners();
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
