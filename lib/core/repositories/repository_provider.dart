import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'interfaces/club_repository.dart';
import 'interfaces/squad_repository.dart';
import 'interfaces/vibe_repository.dart';
import 'interfaces/association_repository.dart';
import 'supabase_club_repository.dart';
import 'supabase_squad_repository.dart';
import 'supabase_vibe_repository.dart';
import 'supabase_association_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return SupabaseClubRepository();
});

final squadRepositoryProvider = Provider<SquadRepository>((ref) {
  return SupabaseSquadRepository();
});

final vibeRepositoryProvider = Provider<VibeRepository>((ref) {
  return SupabaseVibeRepository();
});

final associationRepositoryProvider = Provider<AssociationRepository>((ref) {
  return SupabaseAssociationRepository();
});