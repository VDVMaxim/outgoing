import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  void toggleFavorite(String eventId) {
    if (state.contains(eventId)) {
      state = {...state}..remove(eventId);
    } else {
      state = {...state, eventId};
    }
  }

  bool isFavorite(String eventId) => state.contains(eventId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(() {
  return FavoritesNotifier();
});