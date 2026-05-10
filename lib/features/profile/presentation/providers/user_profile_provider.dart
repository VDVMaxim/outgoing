import 'package:flutter_clubapp/features/profile/presentation/providers/follow_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_clubapp/core/providers/shared_prefs_provider.dart';
import 'package:flutter_clubapp/core/config/supabase_client.dart';

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
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
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
      await _supabase
          .from('profiles')
          .update({'nickname': state.nickname})
          .eq('user_id', state.authUserId!);
      
      ref.invalidate(profileStatsProvider(state.authUserId!));
    } catch (e) {
      debugPrint('Error syncing nickname: $e');
    }
  }

  Future<void> loadProfile(String targetUserId) async {
    state = state.copyWith(authUserId: targetUserId);

    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('user_id', targetUserId)
          .maybeSingle();
      if (data != null) {
        final dbNickname = data['nickname'] as String?;
        final hasCompleted =
            state.hasCompletedOnboarding ||
            (dbNickname != null && dbNickname.trim().isNotEmpty);

        if (hasCompleted && !state.hasCompletedOnboarding) {
          await _prefs.setBool('hasCompletedOnboarding', true);
        }

        if (dbNickname != null && dbNickname.trim().isNotEmpty) {
          await _prefs.setString('anonymous_nickname', dbNickname);
        }

        state = state.copyWith(
          email: data['email'] ?? _supabase.auth.currentUser?.email,
          nickname: dbNickname ?? state.nickname,
          firstName: data['first_name'],
          lastName: data['last_name'],
          bio: data['bio'],
          avatarUrl: data['avatar_url'],
          hasCompletedOnboarding: hasCompleted,
        );
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? nickname,
    String? bio,
    String? email,
  }) async {
    final targetId = state.authUserId;
    if (targetId == null) return;
    try {
      // 1. Update e-mail in auth.users
      if (email != null && email.isNotEmpty && email != state.email) {
        await _supabase.auth.updateUser(UserAttributes(email: email));
      }

      // 2. Bouw update map voor profiles tabel
      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (nickname != null) updates['nickname'] = nickname;
      if (bio != null) updates['bio'] = bio;
      if (email != null && email.isNotEmpty) updates['email'] = email;

      if (updates.isNotEmpty) {
        await _supabase
            .from('profiles')
            .update(updates)
            .eq('user_id', targetId);
      }

      if (nickname != null) {
        await _prefs.setString('anonymous_nickname', nickname);
      }

      state = state.copyWith(
        firstName: firstName ?? state.firstName,
        lastName: lastName ?? state.lastName,
        nickname: nickname ?? state.nickname,
        bio: bio ?? state.bio,
        clearBio: bio != null && bio.isEmpty, // Wis de bio als een lege string is doorgegeven
        email: email ?? state.email,
      );

      ref.invalidate(profileStatsProvider(targetId));
    } catch (e) {
      debugPrint('Error updating profile: $e');
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
          await _supabase.storage.from('avatars').remove([
            '$targetId/$fileName',
          ]);
        } catch (e) {
           debugPrint('Error removing old avatar: $e');
        }
      }

      final fileExtension = p.extension(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = '$targetId/$fileName';

      await _supabase.storage.from('avatars').upload(filePath, imageFile);
      final newAvatarUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);

      await _supabase
          .from('profiles')
          .update({'avatar_url': newAvatarUrl})
          .eq('user_id', targetId);

      state = state.copyWith(avatarUrl: newAvatarUrl);
      ref.invalidate(profileStatsProvider(targetId));
      return newAvatarUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
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
      await _supabase
          .from('profiles')
          .update({'avatar_url': null})
          .eq('user_id', targetId);

      state = state.copyWith(clearAvatarUrl: true);
      ref.invalidate(profileStatsProvider(targetId));
    } catch (e) {
      debugPrint('Error deleting avatar: $e');
      rethrow;
    }
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(() {
      return UserProfileNotifier();
    });