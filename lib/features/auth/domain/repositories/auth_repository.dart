abstract class AuthRepository {
  bool get isAuthenticated;
  bool get isAnonymous;
  String? get userId;

  Future<AuthResult> signInAnonymously();

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String nickname,
    String? bio,
  });

  Future<AuthResult> signIn({required String email, required String password});

  Future<void> signOut();

  Future<AuthResult> deleteAccount();

  Future<String?> getNicknameFromProfile();

  Future<Map<String, dynamic>?> getProfile();
}

enum AuthResultStatus { success, error, emailAlreadyInUse, invalidCredentials }

class AuthResult {
  final AuthResultStatus status;
  final String? errorMessage;

  AuthResult({required this.status, this.errorMessage});
}