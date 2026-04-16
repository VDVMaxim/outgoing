import 'package:latlong2/latlong.dart';
import '../../models/squad.dart';
import '../../models/squad_member.dart';

abstract class SquadRepository {
  Future<Squad> createSquad();
  Future<Squad?> getSquadByPin(String pin);
  Future<SquadMember> joinSquad(
    String squadId,
    String nickname,
    LatLng position,
  );
  Future<void> leaveSquad(String squadId, String userId);
  Future<void> updateMemberPosition(String memberId, LatLng position);
  Stream<List<SquadMember>> subscribeToSquad(String squadId);
  void unsubscribeFromSquad();
}
