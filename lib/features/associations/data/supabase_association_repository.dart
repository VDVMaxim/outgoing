import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/core/models/association.dart';
import '../domain/association_repository.dart';

class SupabaseAssociationRepository implements AssociationRepository {
  final SupabaseClient _client;

  SupabaseAssociationRepository(this._client);

  @override
  Future<List<Association>> getAllAssociations() async {
    final response = await _client
        .from('associations')
        .select('*, association_tags(tags(name))')
        .order('name');
    
    return (response as List)
        .map((json) => Association.fromJson(json))
        .toList();
  }

  @override
  Future<List<AssociationMember>> getUserAssociations(String userId) async {
    final response = await _client
        .from('association_members')
        .select('*, associations(*, association_tags(tags(name)))')
        .eq('user_id', userId);

    return (response as List)
        .map((json) => AssociationMember.fromJson(json))
        .toList();
  }

  @override
  Future<void> joinAssociation(String associationId, String userId) async {
    await _client.from('association_members').insert({
      'association_id': associationId,
      'user_id': userId,
      'role': 'pending'
    });
  }

  @override
  Future<void> leaveAssociation(String associationId, String userId) async {
    await _client
        .from('association_members')
        .delete()
        .eq('association_id', associationId)
        .eq('user_id', userId);
  }
}