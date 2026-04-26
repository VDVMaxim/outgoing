import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/association.dart';
import '../../../core/repositories/repository_provider.dart';

class AssociationState {
  final List<Association> allAssociations;
  final List<AssociationMember> userAssociations;
  final bool isLoading;
  final String? error;

  const AssociationState({
    this.allAssociations = const [],
    this.userAssociations = const [],
    this.isLoading = false,
    this.error,
  });

  AssociationState copyWith({
    List<Association>? allAssociations,
    List<AssociationMember>? userAssociations,
    bool? isLoading,
    String? error,
  }) {
    return AssociationState(
      allAssociations: allAssociations ?? this.allAssociations,
      userAssociations: userAssociations ?? this.userAssociations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AssociationNotifier extends StateNotifier<AssociationState> {
  final Ref _ref;

  AssociationNotifier(this._ref) : super(const AssociationState());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = _ref.read(associationRepositoryProvider);
      final all = await repository.getAllAssociations();
      
      final userId = Supabase.instance.client.auth.currentUser?.id;
      List<AssociationMember> userAssocs = [];
      if (userId != null) {
        userAssocs = await repository.getUserAssociations(userId);
      }

      state = state.copyWith(
        allAssociations: all,
        userAssociations: userAssocs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> joinAssociation(String associationId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = _ref.read(associationRepositoryProvider);
      await repository.joinAssociation(associationId, userId);
      await loadData();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> leaveAssociation(String associationId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = _ref.read(associationRepositoryProvider);
      await repository.leaveAssociation(associationId, userId);
      await loadData();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final associationProvider = StateNotifierProvider<AssociationNotifier, AssociationState>((ref) {
  return AssociationNotifier(ref);
});