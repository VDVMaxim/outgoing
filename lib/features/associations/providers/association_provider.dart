import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_client.dart';
import '../../../core/models/association.dart';

class AssociationState {
  final List<Association> associations;
  final List<AssociationMember> userAssociations;
  final bool isLoading;

  const AssociationState({
    this.associations = const [],
    this.userAssociations = const [],
    this.isLoading = false,
  });

  AssociationState copyWith({
    List<Association>? associations,
    List<AssociationMember>? userAssociations,
    bool? isLoading,
  }) {
    return AssociationState(
      associations: associations ?? this.associations,
      userAssociations: userAssociations ?? this.userAssociations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AssociationNotifier extends AsyncNotifier<AssociationState> {
  late SupabaseClient _supabase;

  @override
  Future<AssociationState> build() async {
    _supabase = ref.watch(supabaseClientProvider);
    return _fetchData();
  }

  Future<AssociationState> _fetchData() async {
    final userId = _supabase.auth.currentUser?.id;

    try {
      // 1. Haal alle verenigingen op
      final assocResponse = await _supabase.from('associations').select();
      final associations = (assocResponse as List).map((json) => Association.fromJson(json)).toList();

      // 2. Haal lidmaatschappen van deze user op
      List<AssociationMember> userAssocs = [];
      if (userId != null) {
        final membershipResponse = await _supabase
            .from('association_members')
            .select('*, associations(*, association_tags(tags(name)))')
            .eq('user_id', userId);
        
        userAssocs = (membershipResponse as List).map((json) => AssociationMember.fromJson(json)).toList();
      }

      return AssociationState(
        associations: associations,
        userAssociations: userAssocs,
        isLoading: false,
      );
    } catch (e) {
      throw Exception('Failed to load associations: $e');
    }
  }

  Future<void> loadData() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchData());
  }

  Future<void> joinAssociation(String associationId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      state = AsyncData(state.value!.copyWith(isLoading: true));
      await _supabase.from('association_members').insert({
        'association_id': associationId,
        'user_id': userId,
        'role': 'pending',
      });
      await loadData(); // Herlaad de verse state vanuit Supabase
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      throw Exception('Failed to join association');
    }
  }

  Future<void> leaveAssociation(String associationId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      state = AsyncData(state.value!.copyWith(isLoading: true));
      await _supabase
          .from('association_members')
          .delete()
          .eq('association_id', associationId)
          .eq('user_id', userId);
      await loadData();
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      throw Exception('Failed to leave association');
    }
  }
}

final associationProvider = AsyncNotifierProvider<AssociationNotifier, AssociationState>(() {
  return AssociationNotifier();
});