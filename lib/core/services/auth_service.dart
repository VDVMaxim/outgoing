import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthResultStatus { success, error, emailAlreadyInUse, invalidCredentials }

class AuthResult {
  final AuthResultStatus status;
  final String? errorMessage;

  AuthResult({required this.status, this.errorMessage});
}

class AuthService {
  final SupabaseClient _supabase;
  
  AuthService(this._supabase); 

  bool get isAuthenticated => _supabase.auth.currentUser != null;
  String? get userId => _supabase.auth.currentUser?.id;

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
      );
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'user_id': response.user!.id,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'nickname': nickname,
          if (bio != null && bio.isNotEmpty) 'bio': bio,
        });
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
      return AuthResult(status: AuthResultStatus.error, errorMessage: e.message);
    } catch (e) {
      return AuthResult(status: AuthResultStatus.error, errorMessage: e.toString());
    }
  }

  Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return AuthResult(status: AuthResultStatus.success);
      }
      return AuthResult(status: AuthResultStatus.error, errorMessage: 'Unknown error occurred');
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login') || e.message.contains('Invalid credentials')) {
        return AuthResult(
          status: AuthResultStatus.invalidCredentials,
          errorMessage: 'Email of wachtwoord is incorrect',
        );
      }
      return AuthResult(status: AuthResultStatus.error, errorMessage: e.message);
    } catch (e) {
      return AuthResult(status: AuthResultStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<AuthResult> deleteAccount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return AuthResult(status: AuthResultStatus.error, errorMessage: 'Not logged in');
      }
      await _supabase.from('profiles').delete().eq('user_id', userId);
      await _supabase.auth.admin.deleteUser(userId);
      return AuthResult(status: AuthResultStatus.success);
    } catch (e) {
      return AuthResult(status: AuthResultStatus.error, errorMessage: e.toString());
    }
  }

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