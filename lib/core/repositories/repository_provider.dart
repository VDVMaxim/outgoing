import 'interfaces/club_repository.dart';
import 'interfaces/vibe_repository.dart';
import 'interfaces/squad_repository.dart';
import 'mock_club_repository.dart';
import 'supabase_club_repository.dart';
import 'supabase_vibe_repository.dart';
import 'supabase_squad_repository.dart';

enum DataBackend { mock, supabase }

const String _clubDataBackendEnv = String.fromEnvironment(
  'CLUB_DATA_BACKEND',
  defaultValue: 'supabase',
);

const DataBackend kClubDataBackendFallback = DataBackend.supabase;

DataBackend get kClubDataBackend {
  switch (_clubDataBackendEnv) {
    case 'mock':
      return DataBackend.mock;
    case 'supabase':
      return DataBackend.supabase;
    default:
      return kClubDataBackendFallback;
  }
}

late final ClubRepository clubRepository;
late final VibeRepository vibeRepository;
late final SquadRepository squadRepository;

void initializeRepositories() {
  switch (kClubDataBackend) {
    case DataBackend.mock:
      clubRepository = MockClubRepository();
      throw UnimplementedError('Mock VibeRepository not implemented');
    case DataBackend.supabase:
      clubRepository = SupabaseClubRepository();
      vibeRepository = SupabaseVibeRepository();
      squadRepository = SupabaseSquadRepository();
  }
}
