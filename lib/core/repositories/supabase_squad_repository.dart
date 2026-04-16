import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_client.dart';
import '../models/squad.dart';
import '../models/squad_member.dart';
import 'interfaces/squad_repository.dart';

class SupabaseSquadRepository implements SquadRepository {
  RealtimeChannel? _channel;
  final _memberStreamController =
      StreamController<List<SquadMember>>.broadcast();

  String _generatePin() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  String _generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    return '$timestamp$random';
  }

  @override
  Future<Squad> createSquad() async {
    final client = SupabaseClientProvider.client;
    final userId = _generateUserId();
    final pin = _generatePin();

    final response = await client
        .from('squads')
        .insert({'pin': pin, 'created_by': userId})
        .select()
        .single();

    return Squad.fromJson(response);
  }

  @override
  Future<Squad?> getSquadByPin(String pin) async {
    final client = SupabaseClientProvider.client;

    final response = await client
        .from('squads')
        .select()
        .eq('pin', pin)
        .maybeSingle();

    if (response == null) return null;
    return Squad.fromJson(response);
  }

  @override
  Future<SquadMember> joinSquad(
    String squadId,
    String nickname,
    LatLng position,
  ) async {
    final client = SupabaseClientProvider.client;
    final userId = _generateUserId();

    final response = await client
        .from('squad_members')
        .insert({
          'squad_id': squadId,
          'user_id': userId,
          'nickname': nickname,
          'latitude': position.latitude,
          'longitude': position.longitude,
        })
        .select()
        .single();

    return SquadMember.fromJson(response);
  }

  @override
  Future<void> leaveSquad(String squadId, String userId) async {
    final client = SupabaseClientProvider.client;

    await client
        .from('squad_members')
        .delete()
        .eq('squad_id', squadId)
        .eq('user_id', userId);
  }

  @override
  Future<void> updateMemberPosition(String memberId, LatLng position) async {
    final client = SupabaseClientProvider.client;

    await client
        .from('squad_members')
        .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', memberId);
  }

  @override
  Stream<List<SquadMember>> subscribeToSquad(String squadId) {
    _channel?.unsubscribe();
    _memberStreamController.add(<SquadMember>[]);

    _channel = SupabaseClientProvider.client
        .channel('squad_members_$squadId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'squad_members',
          callback: (payload) => _onSquadMemberChange(squadId),
        );

    _channel!.subscribe();

    _loadSquadMembers(squadId);

    return _memberStreamController.stream;
  }

  Future<void> _loadSquadMembers(String squadId) async {
    final client = SupabaseClientProvider.client;

    final response = await client
        .from('squad_members')
        .select()
        .eq('squad_id', squadId);

    final members = (response as List)
        .map((json) => SquadMember.fromJson(json as Map<String, dynamic>))
        .toList();

    _memberStreamController.add(members);
  }

  Future<void> _onSquadMemberChange(String squadId) async {
    await _loadSquadMembers(squadId);
  }

  @override
  void unsubscribeFromSquad() {
    _channel?.unsubscribe();
    _channel = null;
  }

  void dispose() {
    unsubscribeFromSquad();
    _memberStreamController.close();
  }
}
