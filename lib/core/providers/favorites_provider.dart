import 'package:flutter/foundation.dart';

class FavoritesProvider extends ValueNotifier<Set<String>> {
  static final FavoritesProvider instance = FavoritesProvider._internal();

  FavoritesProvider._internal() : super({});

  void toggleFavorite(String eventId) {
    final newSet = Set<String>.from(value);
    if (newSet.contains(eventId)) {
      newSet.remove(eventId);
    } else {
      newSet.add(eventId);
    }
    value = newSet;
  }

  bool isFavorite(String eventId) => value.contains(eventId);
}
