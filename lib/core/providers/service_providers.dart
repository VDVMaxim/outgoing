import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/settings_service.dart';
import '../services/user_profile_service.dart';
import '../services/analytics_service.dart';

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService.instance;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService.instance;
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('settingsServiceProvider moet in main.dart worden overschreven');
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.read(userProfileServiceProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? nickname;
  final String? email;
  final String? displayName;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
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
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _init();
  }

  void _init() {
    final profile = _ref.read(userProfileServiceProvider);
    _updateFromProfile(profile);

    Supabase.instance.client.auth.onAuthStateChange.listen((event) async {
       final p = _ref.read(userProfileServiceProvider);
       await p.loadProfileFromSupabase();
      _updateFromProfile(p);
    });
  }

  void _updateFromProfile(UserProfileService profile) {
    state = state.copyWith(
      isAuthenticated: profile.isAuthenticated,
      isLoading: false,
      nickname: profile.nickname,
      email: profile.email,
      displayName: profile.displayName,
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _ref.read(authServiceProvider).signIn(email: email, password: password);

    if (result.status == AuthResultStatus.success) {
      final profile = _ref.read(userProfileServiceProvider);
      await profile.loadProfileFromSupabase();
      _updateFromProfile(profile);
      _ref.read(analyticsServiceProvider).logEvent('login_success');
      return true;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.errorMessage);
      _ref.read(analyticsServiceProvider).logEvent('login_error', parameters: {'error': result.errorMessage});
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

    final result = await _ref.read(authServiceProvider).signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      nickname: nickname,
    );

    if (result.status == AuthResultStatus.success) {
      final profile = _ref.read(userProfileServiceProvider);
      await profile.loadProfileFromSupabase();
      _updateFromProfile(profile);
      _ref.read(analyticsServiceProvider).logEvent('signup_success');
      return true;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.errorMessage);
      _ref.read(analyticsServiceProvider).logEvent('signup_error', parameters: {'error': result.errorMessage});
      return false;
    }
  }

  void refresh() {
     _updateFromProfile(_ref.read(userProfileServiceProvider));
  }
}