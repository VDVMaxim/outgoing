import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/config/supabase_client.dart';
import 'package:flutter_clubapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clubapp/features/auth/data/supabase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(supabase);
});

class AuthState {
  final bool isAuthenticated;
  final bool isAnonymous;
  final String? userId;
  final String? errorMessage;

  AuthState({
    this.isAuthenticated = false,
    this.isAnonymous = false,
    this.userId,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isAnonymous,
    String? userId,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      userId: userId ?? this.userId,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    return AuthState(
      isAuthenticated: _repository.isAuthenticated,
      isAnonymous: _repository.isAnonymous,
      userId: _repository.userId,
    );
  }

  Future<AuthResult> signInAnonymously() async {
    final result = await _repository.signInAnonymously();
    _updateState(result);
    return result;
  }

  Future<AuthResult> signIn({required String email, required String password}) async {
    final result = await _repository.signIn(email: email, password: password);
    _updateState(result);
    return result;
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String nickname,
    String? bio,
  }) async {
    final result = await _repository.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
      bio: bio,
    );
    _updateState(result);
    return result;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = AuthState(isAuthenticated: false, isAnonymous: false, userId: null);
  }

  Future<AuthResult> deleteAccount() async {
    final result = await _repository.deleteAccount();
    if (result.status == AuthResultStatus.success) {
      state = AuthState(isAuthenticated: false, isAnonymous: false, userId: null);
    }
    return result;
  }

  Future<String?> getNicknameFromProfile() {
    return _repository.getNicknameFromProfile();
  }

  void _updateState(AuthResult result) {
    if (result.status == AuthResultStatus.success) {
      state = AuthState(
        isAuthenticated: _repository.isAuthenticated,
        isAnonymous: _repository.isAnonymous,
        userId: _repository.userId,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(errorMessage: result.errorMessage ?? 'Unknown error');
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final authServiceProvider = Provider<AuthNotifier>((ref) {
  return ref.watch(authProvider.notifier);
});