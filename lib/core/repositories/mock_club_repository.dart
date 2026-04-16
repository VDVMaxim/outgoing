import '../mock_data.dart';
import '../models.dart';
import 'interfaces/club_repository.dart';

class MockClubRepository implements ClubRepository {
  @override
  Future<List<Place>> getPlaces() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return mockPlaces;
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      return mockPlaces.firstWhere((place) => place.id == id);
    } catch (_) {
      return null;
    }
  }
}
