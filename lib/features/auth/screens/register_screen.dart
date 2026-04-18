import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/auth_provider.dart';
import 'package:flutter_clubapp/core/widgets/app_text_field.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker.dart';
import 'package:flutter_clubapp/core/utils/nickname_generator.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/auth/screens/success_screen.dart';

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

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _birthday;
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _firstNameError;
  String? _lastNameError;
  String? _birthdayError;
  String? _emailError;
  String? _nicknameError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_validateCurrentPage()) {
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

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _validateFirstName();
      case 1:
        return _validateLastName();
      case 2:
        return _validateBirthday();
      case 3:
        return _validateNickname();
      case 4:
        return _validateEmail();
      case 5:
        return _validatePassword();
      default:
        return true;
    }
  }

  bool _validateFirstName() {
    bool isValid = true;
    setState(() {
      if (_firstNameController.text.trim().isEmpty) {
        _firstNameError = 'First name is required';
        isValid = false;
      } else {
        _firstNameError = null;
      }
    });
    return isValid;
  }

  bool _validateLastName() {
    bool isValid = true;
    setState(() {
      if (_lastNameController.text.trim().isEmpty) {
        _lastNameError = 'Last name is required';
        isValid = false;
      } else {
        _lastNameError = null;
      }
    });
    return isValid;
  }

  bool _validateBirthday() {
    bool isValid = true;
    setState(() {
      if (_birthday == null) {
        _birthdayError = 'Please select your birthday';
        isValid = false;
      } else {
        _birthdayError = null;
      }
    });
    return isValid;
  }

  bool _validateNickname() {
    bool isValid = true;
    setState(() {
      if (_nicknameController.text.trim().isEmpty) {
        _nicknameError = 'Nickname is required';
        isValid = false;
      } else if (_nicknameController.text.length < 3) {
        _nicknameError = 'Nickname must be at least 3 characters';
        isValid = false;
      } else {
        _nicknameError = null;
      }
    });
    return isValid;
  }

  bool _validateEmail() {
    bool isValid = true;
    setState(() {
      if (_emailController.text.trim().isEmpty) {
        _emailError = 'Email is required';
        isValid = false;
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(_emailController.text)) {
        _emailError = 'Invalid email address';
        isValid = false;
      } else {
        _emailError = null;
      }
    });
    return isValid;
  }

  bool _validatePassword() {
    bool isValid = true;
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        isValid = false;
      } else {
        _passwordError = null;
      }

      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
        isValid = false;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }
    });
    return isValid;
  }

  Future<void> _handleRegister() async {
    final result = await ref
        .read(authProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          birthday: _birthday!,
          nickname: _nicknameController.text.trim(),
        );

    if (!mounted) return;

    if (result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AuthSuccessScreen(
            title: 'Welcome, ${_firstNameController.text}!',
            subtitle: 'Your profile has been created',
            onContinue: widget.onSuccess,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(authProvider).errorMessage ?? 'Registration failed',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 13),
    );
    if (picked != null) {
      setState(() {
        _birthday = picked;
        _birthdayError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(authProvider).isLoading;

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
                  _buildFirstNamePage(isDark, l10n),
                  _buildLastNamePage(isDark, l10n),
                  _buildBirthdayPage(isDark, l10n),
                  _buildNicknamePage(isDark, l10n),
                  _buildEmailPage(isDark, l10n),
                  _buildPasswordPage(isDark, l10n),
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

  Widget _buildPersonalInfoPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountFormPersonalInfo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountFormPersonalInfoDesc,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          AppTextField(
            controller: _firstNameController,
            placeholder: l10n.accountFormFirstName,
            errorText: _firstNameError,
            onChanged: (_) {
              if (_firstNameError != null) {
                setState(() => _firstNameError = null);
              }
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _lastNameController,
            placeholder: l10n.accountFormLastName,
            errorText: _lastNameError,
            onChanged: (_) {
              if (_lastNameError != null) {
                setState(() => _lastNameError = null);
              }
            },
          ),
          const SizedBox(height: 20),
          Text(
            l10n.accountFormBirthday,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selectBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
                border: Border.all(
                  color: _birthdayError != null
                      ? Colors.red
                      : (isDark ? Colors.white24 : Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _birthday != null
                        ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                        : l10n.accountFormBirthdaySelect,
                    style: TextStyle(
                      color: _birthday != null
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                ],
              ),
            ),
          ),
          if (_birthdayError != null) ...[
            const SizedBox(height: 4),
            Text(
              _birthdayError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFirstNamePage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'What\'s your first name?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your first name to get started',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            controller: _firstNameController,
            placeholder: l10n.accountFormFirstName,
            errorText: _firstNameError,
            autofocus: true,
            onChanged: (_) {
              if (_firstNameError != null) {
                setState(() => _firstNameError = null);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLastNamePage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'What\'s your last name?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your last name to continue',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            controller: _lastNameController,
            placeholder: l10n.accountFormLastName,
            errorText: _lastNameError,
            autofocus: true,
            onChanged: (_) {
              if (_lastNameError != null) {
                setState(() => _lastNameError = null);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'When were you born?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We need this to verify your age',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: _selectBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
                border: Border.all(
                  color: _birthdayError != null
                      ? Colors.red
                      : (isDark ? Colors.white24 : Colors.black12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 24),
                  const SizedBox(width: 12),
                  Text(
                    _birthday != null
                        ? '${_birthday!.day}/${_birthday!.month}/${_birthday!.year}'
                        : l10n.accountFormBirthdaySelect,
                    style: TextStyle(
                      fontSize: 18,
                      color: _birthday != null
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_birthdayError != null) ...[
            const SizedBox(height: 8),
            Text(
              _birthdayError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'What\'s your email?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll send you a verification link',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            controller: _emailController,
            placeholder: l10n.loginEmail,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            autofocus: true,
            onChanged: (_) {
              if (_emailError != null) {
                setState(() => _emailError = null);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNicknamePage(bool isDark, AppLocalizations l10n) {
    return NicknamePicker(
      nicknameController: _nicknameController,
      onGenerate: () {
        _nicknameController.text = NicknameGenerator.generate();
        setState(() {});
      },
      errorText: _nicknameError,
    );
  }

  Widget _buildPasswordPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Create a password',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure it\'s at least 6 characters',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          AppTextField(
            controller: _passwordController,
            placeholder: l10n.accountFormPassword,
            obscureText: _obscurePassword,
            errorText: _passwordError,
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
            onChanged: (_) {
              if (_passwordError != null) {
                setState(() => _passwordError = null);
              }
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _confirmPasswordController,
            placeholder: l10n.accountFormConfirmPassword,
            obscureText: _obscureConfirmPassword,
            errorText: _confirmPasswordError,
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
            onChanged: (_) {
              if (_confirmPasswordError != null) {
                setState(() => _confirmPasswordError = null);
              }
            },
          ),
        ],
      ),
    );
  }
}
