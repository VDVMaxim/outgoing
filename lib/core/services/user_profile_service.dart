import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/shared_prefs_provider.dart';
import '../config/supabase_client.dart';

class UserProfileState {
  final String? authUserId;
  final String? email; 
  final String? nickname;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? avatarUrl;
  final bool hasCompletedOnboarding;
  
  bool get isAuthenticated => authUserId != null;
  String? get displayName => nickname ?? firstName ?? 'Gebruiker';
  bool get hasNickname => nickname != null && nickname!.trim().isNotEmpty;

  const UserProfileState({
    this.authUserId,
    this.email, 
    this.nickname,
    this.firstName,
    this.lastName,
    this.bio,
    this.avatarUrl,
    this.hasCompletedOnboarding = false,
  });

  UserProfileState copyWith({
    String? authUserId,
    String? email, 
    String? nickname,
    String? firstName,
    String? lastName,
    String? bio,
    String? avatarUrl,
    bool? hasCompletedOnboarding,
    bool clearAuthUserId = false,
    bool clearEmail = false, 
    bool clearNickname = false,
    bool clearFirstName = false,
    bool clearLastName = false,
    bool clearBio = false,
    bool clearAvatarUrl = false,
  }) {
    return UserProfileState(
      authUserId: clearAuthUserId ? null : (authUserId ?? this.authUserId),
      email: clearEmail ? null : (email ?? this.email), 
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      firstName: clearFirstName ? null : (firstName ?? this.firstName),
      lastName: clearLastName ? null : (lastName ?? this.lastName),
      bio: clearBio ? null : (bio ?? this.bio),
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfileState> {
  late SupabaseClient _supabase;
  late SharedPreferences _prefs;

  @override
  UserProfileState build() {
    _supabase = ref.watch(supabaseClientProvider);
    _prefs = ref.watch(sharedPreferencesProvider);
    
    final hasCompleted = _prefs.getBool('hasCompletedOnboarding') ?? false;
    final anonNickname = _prefs.getString('anonymous_nickname');
    final currentUserId = _supabase.auth.currentUser?.id;
    final currentUserEmail = _supabase.auth.currentUser?.email; 
    
    return UserProfileState(
      authUserId: currentUserId,
      email: currentUserEmail,
      nickname: anonNickname,
      hasCompletedOnboarding: hasCompleted,
    );
  }

  void clearProfile() {
    // Behoud de nickname en onboarding status wanneer je uitlogt!
    final savedNickname = state.nickname;
    final completedOnboarding = state.hasCompletedOnboarding;
    
    state = UserProfileState(
      nickname: savedNickname,
      hasCompletedOnboarding: completedOnboarding,
    );
  }

  Future<void> setHasCompletedOnboarding(bool value) async {
    await _prefs.setBool('hasCompletedOnboarding', value);
    state = state.copyWith(hasCompletedOnboarding: value);
  }

  Future<void> setNickname(String? value) async {
    if (value != null) {
      await _prefs.setString('anonymous_nickname', value);
    } else {
      await _prefs.remove('anonymous_nickname');
    }
    state = state.copyWith(nickname: value, clearNickname: value == null);
  }

  Future<void> loadProfileFromSupabase() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId != null) {
      await loadProfile(currentUserId);
    }
  }

  Future<void> syncNicknameToProfile() async {
    if (state.authUserId == null || state.nickname == null) return;
    try {
      await _supabase.from('profiles').update({'nickname': state.nickname}).eq('user_id', state.authUserId!);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> loadProfile(String targetUserId) async {
    try {
      final data = await _supabase.from('profiles').select().eq('user_id', targetUserId).maybeSingle();
      if (data != null) {
        final dbNickname = data['nickname'] as String?;
        final hasCompleted = state.hasCompletedOnboarding || (dbNickname != null && dbNickname.trim().isNotEmpty);
        
        if (hasCompleted && !state.hasCompletedOnboarding) {
          await _prefs.setBool('hasCompletedOnboarding', true);
        }

        // Overschrijf de lokale anonieme nickname met de account nickname zodat we die onthouden bij uitloggen
        if (dbNickname != null && dbNickname.trim().isNotEmpty) {
          await _prefs.setString('anonymous_nickname', dbNickname);
        }

        state = state.copyWith(
          authUserId: targetUserId,
          email: data['email'] ?? _supabase.auth.currentUser?.email, 
          nickname: dbNickname ?? state.nickname, // Als dbNickname null is, behoud dan de lokale
          firstName: data['first_name'],
          lastName: data['last_name'],
          bio: data['bio'],
          avatarUrl: data['avatar_url'],
          hasCompletedOnboarding: hasCompleted,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String nickname,
    String? bio,
  }) async {
    final targetId = state.authUserId;
    if (targetId == null) return;
    try {
      await _supabase.from('profiles').update({
        'first_name': firstName,
        'last_name': lastName,
        'nickname': nickname,
        'bio': bio,
      }).eq('user_id', targetId);
      
      // Update ook de lokale opslag met de nieuwe nickname
      await _prefs.setString('anonymous_nickname', nickname);
      
      state = state.copyWith(
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
        bio: bio,
        clearBio: bio == null,
      );
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<String?> uploadAvatar(File imageFile) async {
    final targetId = state.authUserId;
    if (targetId == null) return null;
    try {
      final currentAvatar = state.avatarUrl;
      if (currentAvatar != null && currentAvatar.isNotEmpty) {
        try {
          final uri = Uri.parse(currentAvatar);
          final pathSegments = uri.pathSegments;
          final fileName = pathSegments.last;
          await _supabase.storage.from('avatars').remove(['$targetId/$fileName']);
        } catch (e) {
          debugPrint('Error: $e');
        }
      }

      final fileExtension = p.extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = '$targetId/$fileName';

      await _supabase.storage.from('avatars').upload(filePath, imageFile);
      final newAvatarUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);

      await _supabase.from('profiles').update({'avatar_url': newAvatarUrl}).eq('user_id', targetId);
      
      state = state.copyWith(avatarUrl: newAvatarUrl);
      return newAvatarUrl;
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<void> deleteAvatar() async {
    final targetId = state.authUserId;
    final currentAvatar = state.avatarUrl;
    if (targetId == null || currentAvatar == null) return;
    try {
      final uri = Uri.parse(currentAvatar);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.last;
      
      await _supabase.storage.from('avatars').remove(['$targetId/$fileName']);
      await _supabase.from('profiles').update({'avatar_url': null}).eq('user_id', targetId);
      
      state = state.copyWith(clearAvatarUrl: true);
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfileState>(() {
  return UserProfileNotifier();
});

// --- Legacy Wrapper voor UI Compatibiliteit in Fase 2 ---
class UserProfileService {
  final Ref _ref;
  UserProfileService(this._ref);

  UserProfileState get _state => _ref.read(userProfileProvider);
  UserProfileNotifier get _notifier => _ref.read(userProfileProvider.notifier);

  String? get authUserId => _state.authUserId;
  String? get email => _state.email; 
  String? get nickname => _state.nickname;
  String? get firstName => _state.firstName;
  String? get lastName => _state.lastName;
  String? get bio => _state.bio;
  String? get avatarUrl => _state.avatarUrl;
  
  String? get userId => _state.authUserId;
  bool get isAuthenticated => _state.isAuthenticated;
  String? get displayName => _state.displayName;
  bool get hasNickname => _state.hasNickname;
  bool get hasCompletedOnboarding => _state.hasCompletedOnboarding;

  set hasCompletedOnboarding(bool value) => _notifier.setHasCompletedOnboarding(value);
  set nickname(String? value) => _notifier.setNickname(value);

  void clearProfile() => _notifier.clearProfile();
  Future<void> loadProfileFromSupabase() => _notifier.loadProfileFromSupabase();
  Future<void> syncNicknameToProfile() => _notifier.syncNicknameToProfile();
  Future<void> loadProfile(String targetUserId) => _notifier.loadProfile(targetUserId);
  Future<void> updateProfile({required String firstName, required String lastName, required String nickname, String? bio}) => _notifier.updateProfile(firstName: firstName, lastName: lastName, nickname: nickname, bio: bio);
  Future<String?> uploadAvatar(File imageFile) => _notifier.uploadAvatar(imageFile);
  Future<void> deleteAvatar() => _notifier.deleteAvatar();
}

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(ref);
});