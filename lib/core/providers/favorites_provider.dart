import 'package:flutter/foundation.dart';

class FavoritesProvider extends ValueNotifier<Set<String>> {
  static final FavoritesProvider instance = FavoritesProvider._internal();

  FavoritesProvider._internal() : super({});

  void toggleFavorite(String placeId) {
    final newSet = Set<String>.from(value);
    if (newSet.contains(placeId)) {
      newSet.remove(placeId);
    } else {
      newSet.add(placeId);
    }
    value = newSet;
  }

  bool isFavorite(String placeId) => value.contains(placeId);
}
