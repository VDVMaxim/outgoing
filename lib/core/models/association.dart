class Association {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final List<String> tags;

  const Association({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.tags = const [],
  });

  factory Association.fromJson(Map<String, dynamic> json) {
    // Logica om tags uit de geneste join (association_tags -> tags) te halen
    List<String> tagsList = [];
    if (json['association_tags'] != null) {
      final tagsRaw = json['association_tags'] as List;
      tagsList = tagsRaw
          .map((t) => (t['tags'] as Map<String, dynamic>)['name'] as String)
          .toList();
    }

    return Association(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      tags: tagsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
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