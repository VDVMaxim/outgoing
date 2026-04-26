class Association {
  final String id;
  final String name;

  const Association({required this.id, required this.name});

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AssociationMember {
  final String id;
  final String associationId;
  final String userId;
  final String role;
  final Association? association;

  const AssociationMember({
    required this.id,
    required this.associationId,
    required this.userId,
    required this.role,
    this.association,
  });

  factory AssociationMember.fromJson(Map<String, dynamic> json) {
    return AssociationMember(
      id: json['id'] as String,
      associationId: json['association_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      association: json['associations'] != null 
          ? Association.fromJson(json['associations']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'association_id': associationId,
      'user_id': userId,
      'role': role,
    };
  }
}