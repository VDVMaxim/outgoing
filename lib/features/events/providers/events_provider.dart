import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_clubapp/core/models.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/repositories/repository_provider.dart';

final eventsProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  LatLng? userLocation;
  try {
    final pos = await ref.read(locationServiceProvider).getCurrentPosition();
    if (pos != null) {
      userLocation = LatLng(pos.latitude, pos.longitude);
    }
  } catch (_) {}
  
  return ref.read(clubRepositoryProvider).getEvents(userLocation: userLocation);
});