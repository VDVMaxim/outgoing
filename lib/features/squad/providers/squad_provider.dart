import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_clubapp/core/models/squad.dart';
import 'package:flutter_clubapp/core/models/squad_member.dart' as models;
import 'package:flutter_clubapp/core/models/squad_pin.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import 'package:flutter_clubapp/core/services/location_service.dart';
import 'package:flutter_clubapp/core/services/analytics_service.dart';

const double _positionUpdateThresholdMeters = 2.0;
const int _positionUpdateFallbackSeconds = 10;

enum SquadConnectionStatus { disconnected, connecting, connected, error }

class SquadProviderState {
  final SquadConnectionStatus status;
  final String? squadId;
  final String? squadPin;
  final String? memberId;
  final List<SquadMemberDisplay> members;
  final List<SquadPin> pins;
  final String? errorMessage;
  final bool isMuted;

  const SquadProviderState({
    this.status = SquadConnectionStatus.disconnected,
    this.squadId,
    this.squadPin,
    this.memberId,
    this.members = const [],
    this.pins = const [],
    this.errorMessage,
    this.isMuted = true,
  });

  bool get isInSquad => status == SquadConnectionStatus.connected;

  SquadProviderState copyWith({
    SquadConnectionStatus? status,
    String? squadId,
    String? squadPin,
    String? memberId,
    List<SquadMemberDisplay>? members,
    List<SquadPin>? pins,
    String? errorMessage,
    bool? isMuted,
  }) {
    return SquadProviderState(
      status: status ?? this.status,
      squadId: squadId ?? this.squadId,
      squadPin: squadPin ?? this.squadPin,
      memberId: memberId ?? this.memberId,
      members: members ?? this.members,
      pins: pins ?? this.pins,
      errorMessage: errorMessage,
      isMuted: isMuted ?? this.isMuted,
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
  final bool isSpeaking;

  const SquadMemberDisplay({
    required this.id,
    required this.odmemberId,
    required this.nickname,
    this.avatarUrl,
    required this.position,
    required this.lastUpdate,
    required this.isOnline,
    required this.isCurrentUser,
    this.isSpeaking = false,
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
      isSpeaking: false,
    );
  }

  SquadMemberDisplay copyWith({
    LatLng? position,
    DateTime? lastUpdate,
    bool? isOnline,
    bool? isSpeaking,
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
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }
}

class SquadNotifier extends StateNotifier<SquadProviderState> {
  final Ref _ref;

  Timer? _positionUpdateTimer;
  Timer? _onlineCheckTimer;
  Timer? _dbAnalyticsTimer;
  StreamSubscription<List<models.SquadMember>>? _realtimeSubscription;
  StreamSubscription<List<SquadPin>>? _pinsSubscription;

  VoidCallback? _onPositionPulse;
  LatLng? _lastSentPosition;
  DateTime? _lastSentTime;

  final Map<String, RTCPeerConnection> _peers = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  final Map<String, MediaStream> _remoteStreams = {};
  MediaStream? _localStream;
  RealtimeChannel? _signalingChannel;
  String? _myDbUserId;

  SquadNotifier(this._ref) : super(const SquadProviderState());

  SettingsService get _settingsService => _ref.read(settingsServiceProvider);
  UserProfileService get _userProfileService => _ref.read(userProfileServiceProvider);
  LocationService get _locationService => _ref.read(locationServiceProvider);
  SquadRepository get _squadRepository => _ref.read(squadRepositoryProvider);
  AnalyticsService get _analytics => _ref.read(analyticsServiceProvider);

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
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Je moet eerst een nickname instellen.');
      return state;
    }

    if (!await checkLocationPermission() && !await requestLocationPermission()) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Locatietoegang is geweigerd.');
      return state;
    }

    state = state.copyWith(status: SquadConnectionStatus.connecting);

    LatLng userPosition;
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        userPosition = LatLng(position.latitude, position.longitude);
      } else {
        throw Exception('Locatie kon niet worden bepaald.');
      }
    } catch (e) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Kan je locatie niet bepalen. Controleer of je GPS aan staat.');
      return state;
    }

    try {
      final data = await _squadRepository.createSquadWithMember(
        _userProfileService.nickname ?? 'Anonymous',
        userPosition,
      );

      final squad = data['squad'] as Squad;
      final member = data['member'] as models.SquadMember;
      
      _myDbUserId = member.userId;

      state = state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [SquadMemberDisplay.fromModel(member, _myDbUserId!, _offlineThresholdMs)],
      );

      _startTracking();
      _startOnlineCheck();
      _startDbAnalyticsTimer();
      await _initWebRTC();

      _realtimeSubscription = _squadRepository.subscribeToSquad(squad.id).listen(_onSquadMembersUpdate);
      _pinsSubscription = _squadRepository.subscribeToPins(squad.id).listen(_onPinsUpdate);

      _analytics.logEvent('squad_created', parameters: {'squad_id': squad.id});
      HapticFeedback.mediumImpact();
      return state;
    } catch (e) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Er is iets misgegaan bij het aanmaken van de squad.');
      return state;
    }
  }

  Future<SquadProviderState> joinSquad(String pin) async {
    if (!_userProfileService.hasNickname) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Je moet eerst een nickname instellen.');
      return state;
    }

    if (!await checkLocationPermission() && !await requestLocationPermission()) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Locatietoegang is geweigerd.');
      return state;
    }

    state = state.copyWith(status: SquadConnectionStatus.connecting);

    LatLng userPosition;
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        userPosition = LatLng(position.latitude, position.longitude);
      } else {
        throw Exception('Locatie kon niet worden bepaald.');
      }
    } catch (e) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Kan je locatie niet bepalen.');
      return state;
    }

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

      _myDbUserId = member.userId;

      state = state.copyWith(
        status: SquadConnectionStatus.connected,
        squadId: squad.id,
        squadPin: squad.pin,
        memberId: member.id,
        members: [SquadMemberDisplay.fromModel(member, _myDbUserId!, _offlineThresholdMs)],
      );

      _startTracking();
      _startOnlineCheck();
      _startDbAnalyticsTimer();
      await _initWebRTC();

      _realtimeSubscription = _squadRepository.subscribeToSquad(squad.id).listen(_onSquadMembersUpdate);
      _pinsSubscription = _squadRepository.subscribeToPins(squad.id).listen(_onPinsUpdate);

      _analytics.logEvent('squad_joined', parameters: {'squad_id': squad.id});
      HapticFeedback.mediumImpact();
      return state;
    } catch (e) {
      state = state.copyWith(status: SquadConnectionStatus.error, errorMessage: 'Er is iets misgegaan bij het joinen van de squad.');
      return state;
    }
  }

  Future<void> createPin(LatLng position, DateTime targetTime) async {
    if (state.squadId == null || _myDbUserId == null) return;
    await _squadRepository.createPin(state.squadId!, _myDbUserId!, position, targetTime);
  }

  Future<void> joinPin(String pinId) async {
    if (_myDbUserId == null) return;
    await _squadRepository.joinPin(pinId, _myDbUserId!);
  }

  void _onPinsUpdate(List<SquadPin> pins) {
    state = state.copyWith(pins: pins);
    _onPositionPulse?.call();
  }

  Future<void> _initWebRTC() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': false,
      });

      _localStream?.getAudioTracks().forEach((track) {
        track.enabled = !state.isMuted;
      });
      
      Helper.setSpeakerphoneOn(true);
    } catch (e) {
      debugPrint('❌ Microfoon permissie geweigerd of niet beschikbaar: $e');
    }

    _signalingChannel = Supabase.instance.client.channel('squad_signaling_${state.squadId}');
    _signalingChannel!.onBroadcast(
      event: 'signaling',
      callback: _handleSignalingMessage,
    );

    _signalingChannel!.subscribe((status, [error]) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        _broadcastSignaling({'signalType': 'peer-join', 'userId': _myDbUserId});
      }
    });
  }

  void _handleSignalingMessage(Map<String, dynamic> rawData) async {
    Map<String, dynamic> data = {};

    if (rawData.containsKey('payload')) {
      final innerPayload = rawData['payload'];

      if (innerPayload is Map) {
        if (innerPayload.containsKey('payload') && innerPayload['payload'] is Map) {
          data = innerPayload['payload'] as Map<String, dynamic>;
        } else {
          data = innerPayload as Map<String, dynamic>;
        }
      } else if (innerPayload is String) {
        try { data = jsonDecode(innerPayload) as Map<String, dynamic>;
        } catch (_) {}
      }
    } else {
      data = rawData;
    }

    final signalType = data['signalType'];
    final userId = data['userId'];
    final targetUserId = data['targetUserId'];

    if (signalType == null || userId == null) return;
    if (userId == _myDbUserId) return;

    if (targetUserId != null && targetUserId != _myDbUserId) return;

    try {
      switch (signalType) {
        case 'peer-join':
          await _createPeerConnection(userId, isInitiator: true);
          break;
        case 'offer':
          await _createPeerConnection(userId, isInitiator: false);
          await _peers[userId]!.setRemoteDescription(RTCSessionDescription(data['sdp'], 'offer'));

          final answer = await _peers[userId]!.createAnswer();
          await _peers[userId]!.setLocalDescription(answer);
          _broadcastSignaling({
            'signalType': 'answer',
            'userId': _myDbUserId,
            'targetUserId': userId,
            'sdp': answer.sdp,
          });
          break;
        case 'answer':
          if (_peers.containsKey(userId)) {
            await _peers[userId]!.setRemoteDescription(RTCSessionDescription(data['sdp'], 'answer'));
          }
          break;

        case 'ice-candidate':
          if (_peers.containsKey(userId)) {
            await _peers[userId]!.addCandidate(RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ));
          }
          break;

      }
    } catch (e) {
      debugPrint('❌ Fout tijdens _handleSignalingMessage verwerking: $e');
    }
  }

  Future<void> _createPeerConnection(String peerId, {required bool isInitiator}) async {
    if (_peers.containsKey(peerId)) return;

    try {
      final pc = await createPeerConnection({
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
          {
            'urls': 'turn:openrelay.metered.ca:80',
            'username': 'openrelayproject',
            'credential': 'openrelayproject'
          },
          {
            'urls': 'turn:openrelay.metered.ca:443',
            'username': 'openrelayproject',
            'credential': 'openrelayproject'
          },
        ]
      });

      _peers[peerId] = pc;

      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) {
          pc.addTrack(track, _localStream!);
        });
      }

      pc.onTrack = (event) {
        if (event.track.kind == 'audio' && event.streams.isNotEmpty) {
          _remoteStreams[peerId] = event.streams.first;
        }
      };

      pc.onIceConnectionState = (connState) {
        if (connState == RTCIceConnectionState.RTCIceConnectionStateConnected) {
          Helper.setSpeakerphoneOn(true);
        }
      };

      pc.onIceCandidate = (candidate) {
        _broadcastSignaling({
          'signalType': 'ice-candidate',
          'userId': _myDbUserId,
          'targetUserId': peerId,
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      };

      if (isInitiator) {
        final init = RTCDataChannelInit()..ordered = false..maxRetransmits = 0;

        final dc = await pc.createDataChannel('data', init);
        _setupDataChannel(peerId, dc);

        final offer = await pc.createOffer();
        await pc.setLocalDescription(offer);

        _broadcastSignaling({
          'signalType': 'offer',
          'userId': _myDbUserId,
          'targetUserId': peerId,
          'sdp': offer.sdp,
        });

      } else {
        pc.onDataChannel = (dc) {
          _setupDataChannel(peerId, dc);
        };
      }
    } catch (e) {
      debugPrint('❌ Fout tijdens _createPeerConnection: $e');
    }
  }

  void _setupDataChannel(String peerId, RTCDataChannel dc) {
    _dataChannels[peerId] = dc;

    dc.onMessage = (message) {
      try {
        final data = jsonDecode(message.text);

        final msgType = data['type'];
        final sender = data['userId'] as String;

        if (msgType == 'pos') {
          final lat = data['lat'] as double;

          final lng = data['lng'] as double;
          _updateMemberStateFromWebRTC(sender, position: LatLng(lat, lng));

        } else if (msgType == 'ptt') {
          final isSpeaking = data['isSpeaking'] as bool;

          _updateMemberStateFromWebRTC(sender, isSpeaking: isSpeaking);
        }
      } catch (_) {}
    };
  }

  void _broadcastSignaling(Map<String, dynamic> payload) {
    _signalingChannel?.sendBroadcastMessage(
      event: 'signaling',
      payload: payload,
    );
  }

  void setMute(bool mute) {
    if (state.isMuted == mute) return; 
    
    state = state.copyWith(isMuted: mute);

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !mute;
    });

    if (_myDbUserId != null) {
      _updateMemberStateFromWebRTC(_myDbUserId!, isSpeaking: !mute);
    }
    
    final pttMsg = jsonEncode({
      'type': 'ptt',
      'userId': _myDbUserId,
      'isSpeaking': !mute,
    });

    for (final dc in _dataChannels.values) {
      if (dc.state == RTCDataChannelState.RTCDataChannelOpen) {
        dc.send(RTCDataChannelMessage(pttMsg));
      }
    }
    
    _analytics.logEvent('squad_ptt', parameters: {'talking': !mute});
  }

  void _updateMemberStateFromWebRTC(String userId, {LatLng? position, bool? isSpeaking}) {
    final updatedMembers = state.members.map((m) {
      if (m.odmemberId == userId) {
        return m.copyWith(
          position: position ?? m.position,
          isSpeaking: isSpeaking ?? m.isSpeaking,
          lastUpdate: DateTime.now(),
          isOnline: true,
        );
      }
  
      return m;
    }).toList();
    
    state = state.copyWith(members: updatedMembers);
    _onPositionPulse?.call();
  }

  void _startTracking() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _updateMyPosition(),
    );
  }

  void _startOnlineCheck() {
    _onlineCheckTimer?.cancel();
    _onlineCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkOnlineStatus(),
    );
  }

  void _startDbAnalyticsTimer() {
    _dbAnalyticsTimer?.cancel();
    _dbAnalyticsTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      if (state.memberId != null && _lastSentPosition != null) {
        try {
          await _squadRepository.updateMemberPosition(state.memberId!, _lastSentPosition!);
        } catch (e) {
          // negeer
        }
      }
    });
  }

  Future<void> _updateMyPosition() async {
    if (state.memberId == null || state.squadId == null) return;

    try {
      final position = await _locationService.getCurrentPosition();

      if (position != null) {
        final currentPosition = LatLng(position.latitude, position.longitude);

        if (_shouldSendPositionUpdate(currentPosition)) {
           
          final posMsg = jsonEncode({
            'type': 'pos',
            'lat': currentPosition.latitude,
            'lng': currentPosition.longitude,
            'userId': _myDbUserId,
          });

          for (final dc in _dataChannels.values) {
            if (dc.state == RTCDataChannelState.RTCDataChannelOpen) {
              dc.send(RTCDataChannelMessage(posMsg));
            }
          }

          if (_myDbUserId != null) {
            _updateMemberStateFromWebRTC(_myDbUserId!, position: currentPosition);
          }
          _lastSentPosition = currentPosition;
          _lastSentTime = DateTime.now();
        }
      }
    } catch (_) {}
  }

  bool _shouldSendPositionUpdate(LatLng currentPosition) {
    if (_lastSentPosition == null || _lastSentTime == null) return true;

    final distance = const Distance().as(LengthUnit.Meter, _lastSentPosition!, currentPosition);
    if (distance >= _positionUpdateThresholdMeters) return true;
    if (DateTime.now().difference(_lastSentTime!).inSeconds >= _positionUpdateFallbackSeconds) return true;

    return false;
  }

  void _checkOnlineStatus() {
    if (state.members.isEmpty) return;

    final updatedMembers = state.members.map((member) {
      final isOnline = DateTime.now().difference(member.lastUpdate).inMilliseconds < _offlineThresholdMs;
      return member.copyWith(isOnline: isOnline, isSpeaking: isOnline ? member.isSpeaking : false);
    }).toList();

    if (!_listEquals(updatedMembers, state.members)) {
      state = state.copyWith(members: updatedMembers);
    }
  }

  void _onSquadMembersUpdate(List<models.SquadMember> modelMembers) {
    final cId = _myDbUserId ?? '';

    final currentMembersMap = {for (var m in state.members) m.odmemberId: m};

    final displayMembers = modelMembers.map((m) {
      final existing = currentMembersMap[m.userId];
      final pos = existing != null ? existing.position : LatLng(m.latitude, m.longitude);
      final lastUpdate = existing != null ? existing.lastUpdate : m.updatedAt;
      final isOnline = DateTime.now().difference(lastUpdate).inMilliseconds < _offlineThresholdMs;
      final isSpeaking = existing != null ? existing.isSpeaking : false;

      return SquadMemberDisplay(
        id: m.id,
        odmemberId: m.userId,
        nickname: m.nickname,
        avatarUrl: null,
        position: pos,
        lastUpdate: lastUpdate,
        isOnline: isOnline,
        isCurrentUser: m.userId == cId,
        isSpeaking: isSpeaking,
      );
    }).toList();

    state = state.copyWith(members: displayMembers);
  }

  int get _offlineThresholdMs {
    return _settingsService.trackingFrequency * _settingsService.offlineMultiplier * 1000;
  }

  void leaveSquad() {
    _analytics.logEvent('squad_left', parameters: {'squad_id': state.squadId});

    _positionUpdateTimer?.cancel();
    _onlineCheckTimer?.cancel();
    _dbAnalyticsTimer?.cancel();
    _realtimeSubscription?.cancel();
    _pinsSubscription?.cancel();
    _locationService.stopTracking();

    for (final pc in _peers.values) { pc.close(); }
    _peers.clear();
    _dataChannels.clear();
    _remoteStreams.clear();
    _localStream?.dispose();
    _localStream = null;
    _signalingChannel?.unsubscribe();

    _signalingChannel = null;

    if (state.squadId != null && _myDbUserId != null) {
      try {
        _squadRepository.leaveSquad(state.squadId!, _myDbUserId!);
      } catch (e) {
        debugPrint('⚠️ Kon squad niet verlaten in DB: $e');
      }
    }
    _squadRepository.unsubscribeFromSquad();
    _squadRepository.unsubscribeFromPins();

    _myDbUserId = null;
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
          a[i].isOnline != b[i].isOnline ||
          a[i].isSpeaking != b[i].isSpeaking) { 
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    leaveSquad();
    super.dispose();
  }
}

final squadProvider = StateNotifierProvider<SquadNotifier, SquadProviderState>((ref) {
  return SquadNotifier(ref);
});