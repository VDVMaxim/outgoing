import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/supabase_client.dart';

// Importeer vanuit de nieuwe locaties
import '../../features/places/domain/club_repository.dart';
import '../../features/places/data/supabase_club_repository.dart';

import '../../features/squad/domain/squad_repository.dart';
import '../../features/squad/data/supabase_squad_repository.dart';

import '../../features/vibe/domain/vibe_repository.dart';
import '../../features/vibe/data/supabase_vibe_repository.dart';

import '../../features/associations/domain/association_repository.dart';
import '../../features/associations/data/supabase_association_repository.dart';

// Exporteer de interfaces zodat je niet honderden bestanden hoeft aan te passen
export '../../features/places/domain/club_repository.dart';
export '../../features/squad/domain/squad_repository.dart';
export '../../features/vibe/domain/vibe_repository.dart';
export '../../features/associations/domain/association_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  // We injecteren de client netjes via de nieuwe constructor!
  return SupabaseClubRepository(ref.watch(supabaseClientProvider));
});

final vibeRepositoryProvider = Provider<VibeRepository>((ref) {
  return SupabaseVibeRepository(ref.watch(supabaseClientProvider));
});

final squadRepositoryProvider = Provider<SquadRepository>((ref) {
  return SupabaseSquadRepository(ref.watch(supabaseClientProvider));
});

final associationRepositoryProvider = Provider<AssociationRepository>((ref) {
  return SupabaseAssociationRepository(ref.watch(supabaseClientProvider));
});