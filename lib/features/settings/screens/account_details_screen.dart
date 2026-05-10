import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:flutter_clubapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/follow_provider.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  bool _isLoading = false;
  bool _isResettingPassword = false;

  @override
  void initState() {
    super.initState();
    final authId = ref.read(authProvider).userId;
    final profileStats = authId != null ? ref.read(profileStatsProvider(authId)).valueOrNull : null;
    final profileState = ref.read(userProfileProvider);
    
    _firstNameController = TextEditingController(text: profileState.firstName ?? profileStats?.firstName ?? '');
    _lastNameController = TextEditingController(text: profileState.lastName ?? profileStats?.lastName ?? '');
    _emailController = TextEditingController(text: profileState.email ?? profileStats?.email ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveAccountDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(userProfileProvider.notifier).updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
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

  Future<void> _requestPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vul een geldig email adres in'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isResettingPassword = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wachtwoord reset link verstuurd naar je email.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij het versturen van reset link: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isResettingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
          l10n.settingsAccountDetails,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.editProfilePrivateDataDesc,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Email is verplicht';
                        if (!val.contains('@')) return 'Ongeldig email adres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: l10n.accountFormFirstName,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? l10n.errorFirstNameRequired : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: l10n.accountFormLastName,
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? l10n.errorLastNameRequired : null,
                    ),

                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      child: ShadButton(
                        onPressed: _saveAccountDetails,
                        child: Text(l10n.settingsSave),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.center,
                      child: ShadButton.outline(
                        onPressed: _isResettingPassword ? null : _requestPasswordReset,
                        child: _isResettingPassword 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Stuur wachtwoord reset link'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}