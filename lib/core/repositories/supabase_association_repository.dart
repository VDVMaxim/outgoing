import '../config/supabase_client.dart';
import '../models/association.dart';
import 'interfaces/association_repository.dart';

class SupabaseAssociationRepository implements AssociationRepository {
  @override
  Future<List<Association>> getAllAssociations() async {
    final client = SupabaseClientProvider.client;
    final response = await client.from('associations').select().order('name');
    
    return (response as List)
        .map((json) => Association.fromJson(json))
        .toList();
  }

  @override
  Future<List<AssociationMember>> getUserAssociations(String userId) async {
    final client = SupabaseClientProvider.client;
    final response = await client
        .from('association_members')
        .select('*, associations(*)')
        .eq('user_id', userId);
        
    return (response as List)
        .map((json) => AssociationMember.fromJson(json))
        .toList();
  }

  @override
  Future<void> joinAssociation(String associationId, String userId) async {
    final client = SupabaseClientProvider.client;
    await client.from('association_members').insert({
      'association_id': associationId,
      'user_id': userId,
      'role': 'pending'
    });
  }

  @override
  Future<void> leaveAssociation(String associationId, String userId) async {
    final client = SupabaseClientProvider.client;
    await client
        .from('association_members')
        .delete()
        .eq('association_id', associationId)
        .eq('user_id', userId);
  }
}