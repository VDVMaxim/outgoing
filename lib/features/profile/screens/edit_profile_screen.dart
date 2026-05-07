import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/settings/screens/settings_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profileService = ref.read(userProfileServiceProvider);
    _firstNameController = TextEditingController(text: profileService.firstName ?? '');
    _lastNameController = TextEditingController(text: profileService.lastName ?? '');
    _bioController = TextEditingController(text: profileService.bio ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    
    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        await ref.read(userProfileServiceProvider).uploadAvatar(File(pickedFile.path));
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
      await ref.read(userProfileServiceProvider).deleteAvatar();
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
      await ref.read(userProfileServiceProvider).updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        nickname: ref.read(userProfileServiceProvider).nickname ?? '', 
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
    final profileService = ref.watch(userProfileServiceProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.editProfileTitle, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
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
                            name: profileService.nickname ?? '?',
                            imageUrl: profileService.avatarUrl,
                            size: 100,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                    if (profileService.avatarUrl != null) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _removeImage,
                        child: Text(AppLocalizations.of(context)!.editProfileRemovePhoto, style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ] else const SizedBox(height: 32),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(AppLocalizations.of(context)!.settingsNickname, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                                  profileService.nickname ?? AppLocalizations.of(context)!.settingsNoNickname,
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
                                        initialNickname: profileService.nickname,
                                        isAuthenticated: profileService.isAuthenticated,
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
                      maxLines: 3,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.bio,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Divider(color: isDark ? Colors.white24 : Colors.black12),
                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.settingsAccountDetails,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.editProfilePrivateDataDesc,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.accountFormFirstName,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
                      ),
                      validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.errorFirstNameRequired : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.accountFormLastName,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
                      ),
                      validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.errorLastNameRequired : null,
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