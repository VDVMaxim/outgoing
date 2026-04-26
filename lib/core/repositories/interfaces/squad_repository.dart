import 'package:latlong2/latlong.dart';
import '../../models/squad.dart';
import '../../models/squad_member.dart';
import '../../models/squad_pin.dart';

abstract class SquadRepository {
  Future<Map<String, dynamic>> createSquadWithMember(String nickname, LatLng position);
  Future<Squad?> getSquadByPin(String pin);
  Future<SquadMember> joinSquad(String squadId, String nickname, LatLng position);
  Future<void> leaveSquad(String squadId, String userId);
  Future<void> updateMemberPosition(String memberId, LatLng position);
  Stream<List<SquadMember>> subscribeToSquad(String squadId);
  void unsubscribeFromSquad();

  Future<void> createPin(String squadId, String userId, LatLng position, DateTime targetTime);
  Future<void> joinPin(String pinId, String userId);
  Stream<List<SquadPin>> subscribeToPins(String squadId);
  void unsubscribeFromPins();
}