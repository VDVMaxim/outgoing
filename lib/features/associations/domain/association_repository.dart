import 'package:flutter_clubapp/features/associations/domain/models/association.dart';

abstract class AssociationRepository {
  Future<List<Association>> getAllAssociations();
  Future<List<AssociationMember>> getUserAssociations(String userId);
  Future<void> joinAssociation(String associationId, String userId);
  Future<void> leaveAssociation(String associationId, String userId);
}
