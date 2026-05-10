class Squad {
  final String id;
  final String pin;
  final String createdBy;
  final DateTime createdAt;

  const Squad({
    required this.id,
    required this.pin,
    required this.createdBy,
    required this.createdAt,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id'] as String,
      pin: json['pin'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pin': pin,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
