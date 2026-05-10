import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/follow_provider.dart';
import 'package:flutter_clubapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/settings/screens/settings_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // We kijken in beide caches om te garanderen dat we de bio te pakken hebben
    final authId = ref.read(authProvider).userId;
    final profileStats = authId != null ? ref.read(profileStatsProvider(authId)).valueOrNull : null;
    final profileState = ref.read(userProfileProvider);
    
    _bioController = TextEditingController(text: profileState.bio ?? profileStats?.bio ?? '');
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(userProfileProvider.notifier)
            .uploadAvatar(File(pickedFile.path));
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profilePhotoUpdated)));
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profilePhotoUploadError)));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removeImage() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(userProfileProvider.notifier).deleteAvatar();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profilePhotoRemoved)));
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profilePhotoRemoveError)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(userProfileProvider.notifier)
          .updateProfile(
            nickname: ref.read(userProfileProvider).nickname ?? '',
            bio: _bioController.text.trim(),
          );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaveError)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.editProfileTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          UserAvatar(
                            name: profileState.nickname ?? '?',
                            imageUrl: profileState.avatarUrl,
                            size: 100,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (profileState.avatarUrl != null) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _removeImage,
                        child: Text(
                          AppLocalizations.of(context)!.editProfileRemovePhoto,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ] else
                      const SizedBox(height: 32),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            AppLocalizations.of(context)!.settingsNickname,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profileState.nickname ?? AppLocalizations.of(context)!.settingsNoNickname,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditNicknameScreen(
                                        initialNickname: profileState.nickname,
                                        isAuthenticated: profileState.isAuthenticated,
                                        onSaved: () {},
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      maxLength: 150,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.bio,
                        labelStyle: const TextStyle(color: Colors.grey),
                        alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ShadButton(
                        onPressed: _saveProfile,
                        child: Text(AppLocalizations.of(context)!.settingsSave),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}