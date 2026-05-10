import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Gebruik vanaf nu deze provider om de SupabaseClient te injecteren
/// in je repositories in plaats van de statische getter.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Tijdelijk behouden voor achterwaartse compatibiliteit in Fase 1.
/// Verouderde repositories gebruiken dit momenteel nog. Wordt in
/// een latere fase volledig verwijderd.
class SupabaseClientProvider {
  static SupabaseClient get client {
    return Supabase.instance.client;
  }
}
