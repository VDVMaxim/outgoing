import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/user_profile_service.dart';
import '../services/analytics_service.dart';
import '../services/follow_service.dart';
import '../services/push_notification_service.dart';

export '../services/user_profile_service.dart' show userProfileServiceProvider;

// OPMERKING: instellingen zijn nu verplaatst, vandaar is deze export tijdelijk weggehaald 
// We gebruiken ref.watch(settingsProvider) direct in de bestanden.

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.read(userProfileServiceProvider));
});

final followServiceProvider = Provider<FollowService>((ref) {
  return FollowService();
});

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
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
  final String? userId;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.nickname,
    this.email,
    this.displayName,
    this.errorMessage,
    this.userId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? nickname,
    String? email,
    String? displayName,
    String? errorMessage,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
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
       
       if (event.event == AuthChangeEvent.signedOut) {
         p.clearProfile();
       } else if (event.session != null) {
         await p.loadProfileFromSupabase();
       }
       
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
      userId: profile.authUserId,
    );

    final pushService = _ref.read(pushNotificationServiceProvider);
    if (profile.isAuthenticated && profile.authUserId != null) {
      pushService.login(profile.authUserId!);
    } else {
      pushService.logout();
    }
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
    required String nickname,
    String? bio,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _ref.read(authServiceProvider).signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
      bio: bio,
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