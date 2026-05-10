// lib/features/auth/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/features/auth/presentation/providers/auth_provider.dart';

import 'package:flutter_clubapp/core/widgets/app_text_field.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker.dart';
import 'package:flutter_clubapp/core/utils/nickname_generator.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/auth/screens/success_screen.dart';
import 'package:flutter_clubapp/features/auth/providers/auth_form_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const RegisterScreen({super.key, this.onSuccess, this.onCancel});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 6;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final formNotifier = ref.read(authFormProvider.notifier);

    if (formNotifier.validateRegistrationPage(_currentPage)) {
      if (_currentPage < _totalPages - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _handleRegister();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleRegister() async {
    final success = await ref.read(authFormProvider.notifier).register();

    if (!mounted) return;

    if (success) {
      final firstName = ref.read(authFormProvider).firstName;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AuthSuccessScreen(
            title: AppLocalizations.of(context)!.registerWelcome(firstName),
            subtitle: AppLocalizations.of(context)!.registerProfileCreated,
            onContinue: widget.onSuccess,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(authProvider).errorMessage ??
                AppLocalizations.of(context)!.errorRegistrationFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final formState = ref.watch(authFormProvider);
    final formNotifier = ref.read(authFormProvider.notifier);
    final isLoading = formState.submissionStatus is AsyncLoading;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: _previousPage,
        ),
        title: Text(
          l10n.accountFormTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(_totalPages, (index) {
                  final isCompleted = index < _currentPage;
                  final isCurrent = index == _currentPage;

                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < _totalPages - 1 ? 4 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildFirstNamePage(isDark, l10n, formState, formNotifier),
                  _buildLastNamePage(isDark, l10n, formState, formNotifier),
                  _buildNicknamePage(isDark, l10n, formState, formNotifier),
                  _buildBioPage(isDark, formState, formNotifier),
                  _buildEmailPage(isDark, l10n, formState, formNotifier),
                  _buildPasswordPage(isDark, l10n, formState, formNotifier),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _currentPage == _totalPages - 1
                              ? l10n.accountFormCreate
                              : l10n.accountFormNext,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNamePage(
    bool isDark,
    AppLocalizations l10n,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            l10n.registerFirstNameTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.registerFirstNameDesc,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            initialValue: state.firstName,
            placeholder: l10n.accountFormFirstName,
            errorText: _translateError(state.firstNameError, l10n),
            autofocus: true,
            onChanged: notifier.updateFirstName,
          ),
        ],
      ),
    );
  }

  Widget _buildLastNamePage(
    bool isDark,
    AppLocalizations l10n,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            l10n.registerLastNameTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.registerLastNameDesc,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            initialValue: state.lastName,
            placeholder: l10n.accountFormLastName,
            errorText: _translateError(state.lastNameError, l10n),
            autofocus: true,
            onChanged: notifier.updateLastName,
          ),
        ],
      ),
    );
  }

  Widget _buildNicknamePage(
    bool isDark,
    AppLocalizations l10n,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    final tempController = TextEditingController(text: state.nickname);

    return NicknamePicker(
      nicknameController: tempController,
      onGenerate: () {
        final generated = NicknameGenerator.generate();
        tempController.text = generated;
        notifier.updateNickname(generated);
      },
      errorText: _translateError(state.nicknameError, l10n),
    );
  }

  Widget _buildBioPage(
    bool isDark,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Text(
            AppLocalizations.of(context)!.registerBioTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.registerBioDesc,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            initialValue: state.bio,
            placeholder: AppLocalizations.of(context)!.registerBioHint,
            maxLines: 4,
            maxLength: 150,
            autofocus: true,
            onChanged: notifier.updateBio,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPage(
    bool isDark,
    AppLocalizations l10n,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            l10n.registerEmailTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.registerEmailDesc,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            initialValue: state.email,
            placeholder: l10n.loginEmail,
            keyboardType: TextInputType.emailAddress,
            errorText: _translateError(state.emailError, l10n),
            autofocus: true,
            onChanged: notifier.updateEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPage(
    bool isDark,
    AppLocalizations l10n,
    AuthFormState state,
    AuthFormNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            l10n.registerPasswordTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.registerPasswordDesc,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            initialValue: state.password,
            placeholder: l10n.accountFormPassword,
            obscureText: _obscurePassword,
            errorText: _translateError(state.passwordError, l10n),
            autofocus: true,
            trailing: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            onTrailingTap: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            onChanged: notifier.updatePassword,
          ),
          const SizedBox(height: 20),
          AppTextField(
            initialValue: state.confirmPassword,
            placeholder: l10n.accountFormConfirmPassword,
            obscureText: _obscureConfirmPassword,
            errorText: _translateError(state.confirmPasswordError, l10n),
            trailing: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            onTrailingTap: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
            onChanged: notifier.updateConfirmPassword,
          ),
        ],
      ),
    );
  }

  String? _translateError(String? key, AppLocalizations l10n) {
    if (key == null) return null;
    switch (key) {
      case 'errorFirstNameRequired':
        return l10n.errorFirstNameRequired;
      case 'errorLastNameRequired':
        return l10n.errorLastNameRequired;
      case 'errorEmailRequired':
        return l10n.errorEmailRequired;
      case 'errorInvalidEmail':
        return l10n.errorInvalidEmail;
      case 'errorPasswordRequired':
        return l10n.errorPasswordRequired;
      case 'errorPasswordLength':
        return l10n.errorPasswordLength;
      case 'errorConfirmPasswordRequired':
        return l10n.errorConfirmPasswordRequired;
      case 'errorPasswordMismatch':
        return l10n.errorPasswordMismatch;
      case 'errorNicknameRequired':
        return l10n.errorNicknameRequired;
      case 'errorNicknameLength':
        return l10n.errorNicknameLength;
      case 'errorEmailInUse':
        return l10n.errorEmailInUse;
      default:
        return key;
    }
  }
}
