import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? nickname;
  final String? email;
  final String? displayName;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
    this.nickname,
    this.email,
    this.displayName,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? nickname,
    String? email,
    String? displayName,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  StreamSubscription? _authStateSubscription;

  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final profile = await UserProfileService.getInstance();
    _updateFromProfile(profile);

    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((event) async {
          final profile = await UserProfileService.getInstance();
          _updateFromProfile(profile);
        });
  }

  void _updateFromProfile(UserProfileService profile) {
    state = AuthState(
      isAuthenticated: profile.isAuthenticated,
      isLoading: false,
      nickname: profile.nickname,
      email: profile.email,
      displayName: profile.displayName,
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await AuthService().signIn(email: email, password: password);

    if (result.status == AuthResultStatus.success) {
      final profile = await UserProfileService.getInstance();
      await profile.loadProfileFromSupabase();
      _updateFromProfile(profile);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      );
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime birthday,
    required String nickname,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await AuthService().signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      nickname: nickname,
    );

    if (result.status == AuthResultStatus.success) {
      final profile = await UserProfileService.getInstance();
      await profile.loadProfileFromSupabase();
      _updateFromProfile(profile);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await Supabase.instance.client.auth.signOut();
    final profile = await UserProfileService.getInstance();
    profile.clearAuthData();
    _updateFromProfile(profile);
  }

  Future<void> refresh() async {
    final profile = await UserProfileService.getInstance();
    _updateFromProfile(profile);
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
