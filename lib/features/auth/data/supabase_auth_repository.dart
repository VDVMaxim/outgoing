import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepository(this._supabase);

  @override
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  @override
  bool get isAnonymous => _supabase.auth.currentUser?.isAnonymous ?? false;

  @override
  String? get userId => _supabase.auth.currentUser?.id;

  @override
  Future<AuthResult> signInAnonymously() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      if (response.user != null) {
        return AuthResult(status: AuthResultStatus.success);
      }
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: 'Unknown error occurred',
      );
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String nickname,
    String? bio,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'nickname': nickname,
        },
      );
      if (response.user != null) {
        if (bio != null && bio.isNotEmpty) {
          await _supabase
              .from('profiles')
              .update({'bio': bio})
              .eq('user_id', response.user!.id);
        }
        return AuthResult(status: AuthResultStatus.success);
      }
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: 'Unknown error occurred',
      );
    } on AuthException catch (e) {
      if (e.message.contains('already') || e.statusCode == '422') {
        return AuthResult(
          status: AuthResultStatus.emailAlreadyInUse,
          errorMessage: 'Dit email adres is al in gebruik',
        );
      }
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return AuthResult(status: AuthResultStatus.success);
      }
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: 'Unknown error occurred',
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login') ||
          e.message.contains('Invalid credentials')) {
        return AuthResult(
          status: AuthResultStatus.invalidCredentials,
          errorMessage: 'Email of wachtwoord is incorrect',
        );
      }
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<AuthResult> deleteAccount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return AuthResult(
          status: AuthResultStatus.error,
          errorMessage: 'Not logged in',
        );
      }
      await _supabase.from('profiles').delete().eq('user_id', userId);
      await _supabase.auth.admin.deleteUser(userId);
      return AuthResult(status: AuthResultStatus.success);
    } catch (e) {
      return AuthResult(
        status: AuthResultStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<String?> getNicknameFromProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final profile = await _supabase
        .from('profiles')
        .select('nickname')
        .eq('user_id', userId)
        .maybeSingle();

    return profile?['nickname'];
  }

  @override
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return profile;
  }
}