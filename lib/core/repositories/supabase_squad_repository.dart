import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/core/models/squad.dart';
import 'package:flutter_clubapp/core/models/squad_member.dart';
import 'package:flutter_clubapp/core/repositories/interfaces/squad_repository.dart';

class SupabaseSquadRepository implements SquadRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _squadChannel;
  final _squadMembersController = StreamController<List<SquadMember>>.broadcast();

  String get _currentUserId {
    return _supabase.auth.currentUser?.id ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<Map<String, dynamic>> createSquadWithMember(String nickname, LatLng position) async {
    final response = await _supabase.rpc('create_squad', params: {
      'p_user_id': _currentUserId,
      'p_nickname': nickname,
      'p_lat': position.latitude,
      'p_lng': position.longitude,
    });
    
    return {
      'squad': Squad.fromJson(response['squad']),
      'member': SquadMember.fromJson(response['member']),
    };
  }

  @override
  Future<SquadMember> joinSquad(String squadId, String nickname, LatLng position) async {
    final response = await _supabase
        .from('squad_members')
        .insert({
          'squad_id': squadId,
          'user_id': _currentUserId,
          'nickname': nickname,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();
    return SquadMember.fromJson(response);
  }

  @override
  Future<Squad?> getSquadByPin(String pin) async {
    final response = await _supabase
        .from('squads')
        .select()
        .eq('pin', pin)
        .maybeSingle();
    if (response == null) return null;
    return Squad.fromJson(response);
  }

  @override
  Future<void> updateMemberPosition(String memberId, LatLng position) async {
    await _supabase
        .from('squad_members')
        .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', memberId);
  }

  @override
  Future<void> leaveSquad(String squadId, String userId) async {
      await _supabase
        .from('squad_members')
        .delete()
        .eq('squad_id', squadId)
        .eq('user_id', userId);
  }

  @override
  Stream<List<SquadMember>> subscribeToSquad(String squadId) {
    _squadChannel?.unsubscribe();
    
    _squadChannel = _supabase.channel('public:squad_members:squad_id=eq.$squadId');
    _squadChannel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'squad_members',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'squad_id',
        value: squadId,
      ),
      callback: (payload) {
        _fetchSquadMembers(squadId);
      },
    ).subscribe();
    _fetchSquadMembers(squadId);

    return _squadMembersController.stream;
  }

  Future<void> _fetchSquadMembers(String squadId) async {
    try {
      final response = await _supabase
          .from('squad_members')
          .select()
          .eq('squad_id', squadId);
      final members = (response as List).map((json) => SquadMember.fromJson(json)).toList();
      _squadMembersController.add(members);
    } catch (e) {
      debugPrint('Error fetching squad members: $e');
    }
  }

  @override
  void unsubscribeFromSquad() {
    _squadChannel?.unsubscribe();
    _squadChannel = null;
  }
}