import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/config/supabase_client.dart';
import 'package:flutter_clubapp/features/places/domain/repositories/club_repository.dart';
import 'package:flutter_clubapp/features/places/data/supabase_club_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return SupabaseClubRepository(ref.watch(supabaseClientProvider));
});
