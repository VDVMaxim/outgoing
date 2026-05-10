class OpeningHour {
  final String id;
  final String placeId;
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const OpeningHour({
    required this.id,
    required this.placeId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      id: json['id'] as String,
      placeId: json['place_id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      openTime: (json['open_time'] as String).substring(0, 5),
      closeTime: (json['close_time'] as String).substring(0, 5),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'day_of_week': dayOfWeek,
      'open_time': openTime,
      'close_time': closeTime,
    };
  }
}
