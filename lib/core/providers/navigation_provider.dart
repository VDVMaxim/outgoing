import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/models/place.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);
final mapFocusProvider = StateProvider<Place?>((ref) => null);
