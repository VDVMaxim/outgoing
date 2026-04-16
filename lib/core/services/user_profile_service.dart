import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class UserProfileService {
  static UserProfileService? _instance;
  static SharedPreferences? _prefs;

  static const String _keyUserId = 'user_id';
  static const String _keyNickname = 'nickname';
  static const String _keyAvatarUrl = 'avatar_url';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyEmail = 'email';

  UserProfileService._();

  static Future<UserProfileService> getInstance() async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = UserProfileService._();
    }
    return _instance!;
  }

  String get userId {
    var id = _prefs?.getString(_keyUserId);
    if (id == null || id.isEmpty) {
      id = _generateUserId();
      _prefs?.setString(_keyUserId, id);
    }
    return id;
  }

  String _generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    return '$timestamp$random';
  }

  String? get nickname => _prefs?.getString(_keyNickname);

  set nickname(String? value) {
    if (value != null && value.isNotEmpty) {
      _prefs?.setString(_keyNickname, value);
    } else {
      _prefs?.remove(_keyNickname);
    }
  }

  bool get hasNickname {
    final n = nickname;
    return n != null && n.isNotEmpty;
  }

  String? get avatarUrl => _prefs?.getString(_keyAvatarUrl);

  set avatarUrl(String? value) {
    if (value != null && value.isNotEmpty) {
      _prefs?.setString(_keyAvatarUrl, value);
    } else {
      _prefs?.remove(_keyAvatarUrl);
    }
  }

  bool get hasCompletedOnboarding {
    return _prefs?.getBool(_keyHasCompletedOnboarding) ?? false;
  }

  set hasCompletedOnboarding(bool value) {
    _prefs?.setBool(_keyHasCompletedOnboarding, value);
  }

  bool get isAuthenticated {
    return Supabase.instance.client.auth.currentUser != null;
  }

  String? get authUserId => Supabase.instance.client.auth.currentUser?.id;

  String? get firstName => _prefs?.getString(_keyFirstName);

  set firstName(String? value) {
    if (value != null && value.isNotEmpty) {
      _prefs?.setString(_keyFirstName, value);
    } else {
      _prefs?.remove(_keyFirstName);
    }
  }

  String? get lastName => _prefs?.getString(_keyLastName);

  set lastName(String? value) {
    if (value != null && value.isNotEmpty) {
      _prefs?.setString(_keyLastName, value);
    } else {
      _prefs?.remove(_keyLastName);
    }
  }

  String? get email => _prefs?.getString(_keyEmail);

  set email(String? value) {
    if (value != null && value.isNotEmpty) {
      _prefs?.setString(_keyEmail, value);
    } else {
      _prefs?.remove(_keyEmail);
    }
  }

  String get initials {
    final fName = firstName;
    final lName = lastName;
    if (fName != null &&
        fName.isNotEmpty &&
        lName != null &&
        lName.isNotEmpty) {
      return '${fName[0]}${lName[0]}'.toUpperCase();
    }
    final n = nickname;
    if (n != null && n.isNotEmpty) {
      return n.substring(0, n.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '?';
  }

  String? get displayName {
    if (isAuthenticated && firstName != null && firstName!.isNotEmpty) {
      final ln = lastName;
      return '$firstName${ln != null && ln.isNotEmpty ? ' $ln' : ''}';
    }
    return nickname;
  }

  void setProfileData({
    String? firstName,
    String? lastName,
    String? email,
    String? nickname,
  }) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (email != null) this.email = email;
    if (nickname != null) this.nickname = nickname;
  }

  Future<void> syncNicknameToProfile() async {
    if (isAuthenticated && nickname != null && authUserId != null) {
      await Supabase.instance.client
          .from('profiles')
          .update({
            'nickname': nickname,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', authUserId!);
    }
  }

  Future<String?> syncNicknameFromProfile() async {
    if (!isAuthenticated || authUserId == null) return null;

    final profile = await Supabase.instance.client
        .from('profiles')
        .select('nickname')
        .eq('user_id', authUserId!)
        .maybeSingle();

    if (profile != null && profile['nickname'] != null) {
      nickname = profile['nickname'];
      return profile['nickname'];
    }
    return null;
  }

  Future<void> loadProfileFromSupabase() async {
    if (!isAuthenticated || authUserId == null) return;

    final profile = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('user_id', authUserId!)
        .maybeSingle();

    if (profile != null) {
      firstName = profile['first_name'];
      lastName = profile['last_name'];
      email = profile['email'];
      nickname = profile['nickname'];
    }
  }

  void clearProfile() {
    _prefs?.remove(_keyNickname);
    _prefs?.remove(_keyAvatarUrl);
    _prefs?.remove(_keyFirstName);
    _prefs?.remove(_keyLastName);
    _prefs?.remove(_keyEmail);
  }

  void clearAuthData() {
    _prefs?.remove(_keyFirstName);
    _prefs?.remove(_keyLastName);
    _prefs?.remove(_keyEmail);
  }

  void resetOnboarding() {
    _prefs?.setBool(_keyHasCompletedOnboarding, false);
  }

  static List<String> get _nicknameAdjectives => [
    'Swift',
    'Mystic',
    'Cosmic',
    'Shadow',
    'Electric',
    'Silent',
    'Golden',
    'Silver',
    'Neon',
    'Phantom',
    'Thunder',
    'Crystal',
    'Midnight',
    'Starlight',
    'Wild',
    'Gentle',
    'Brave',
    'Lucky',
    'Lucky',
    'Happy',
  ];

  static List<String> get _nicknameNouns => [
    'Ghoul',
    'Wolf',
    'Phantom',
    'Raven',
    'Storm',
    'Phoenix',
    'Dragon',
    'Hawk',
    'Tiger',
    'Panther',
    'Ninja',
    'Knight',
    'Wizard',
    'Sorcerer',
    'Mage',
    'Spirit',
    'Ghost',
    'Specter',
    'Wraith',
    'Demon',
  ];

  String generateRandomNickname() {
    final random = Random();
    final adjective =
        _nicknameAdjectives[random.nextInt(_nicknameAdjectives.length)];
    final noun = _nicknameNouns[random.nextInt(_nicknameNouns.length)];
    final number = (1000 + random.nextInt(9000)).toString();
    return '$adjective $noun #$number';
  }

  static UserProfileService? get instance => _instance;
}
