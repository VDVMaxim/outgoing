import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/core/services/auth_service.dart';
import 'package:flutter_clubapp/core/services/settings_service.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/auth/screens/success_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const RegisterScreen({super.key, this.onSuccess, this.onCancel});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late SettingsService _settingsService;
  bool _settingsLoaded = false;

  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _birthday;
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _birthdayError;
  String? _emailError;
  String? _nicknameError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.getInstance();
    if (mounted) {
      setState(() {
        _settingsService = settings;
        _settingsLoaded = true;
      });
    }
  }

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
        return _validatePersonalInfo();
      case 1:
        return _validateEmail();
      case 2:
        return _validateNickname();
      case 3:
        return _validatePassword();
      default:
        return true;
    }
  }

  bool _validatePersonalInfo() {
    bool isValid = true;
    setState(() {
      if (_firstNameController.text.trim().isEmpty) {
        _firstNameError = 'First name is required';
        isValid = false;
      } else {
        _firstNameError = null;
      }

      if (_lastNameController.text.trim().isEmpty) {
        _lastNameError = 'Last name is required';
        isValid = false;
      } else {
        _lastNameError = null;
      }

      if (_birthday == null) {
        _birthdayError = 'Please select your birthday';
        isValid = false;
      } else {
        _birthdayError = null;
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
    setState(() => _isLoading = true);

    final result = await AuthService().signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthday: _birthday!,
      nickname: _nicknameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.status == AuthResultStatus.success) {
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
          content: Text(result.errorMessage ?? 'Registration failed'),
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

  void _generateNickname() {
    if (!_settingsLoaded) return;
    _nicknameController.text = _settingsService.generateRandomNickname();
    _validateNickname();
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
                  _buildPersonalInfoPage(isDark, l10n),
                  _buildEmailPage(isDark, l10n),
                  _buildNicknamePage(isDark, l10n),
                  _buildPasswordPage(isDark, l10n),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ShadButton(
                onPressed: _isLoading ? null : _nextPage,
                child: _isLoading
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
                      ),
              ),
            ),
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
          Text(
            l10n.accountFormFirstName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: ShadInput(
              controller: _firstNameController,
              placeholder: Text(l10n.accountFormFirstName),
              onChanged: (_) {
                if (_firstNameError != null) {
                  setState(() => _firstNameError = null);
                }
              },
            ),
          ),
          if (_firstNameError != null) ...[
            const SizedBox(height: 4),
            Text(
              _firstNameError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.accountFormLastName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: ShadInput(
              controller: _lastNameController,
              placeholder: Text(l10n.accountFormLastName),
              onChanged: (_) {
                if (_lastNameError != null) {
                  setState(() => _lastNameError = null);
                }
              },
            ),
          ),
          if (_lastNameError != null) ...[
            const SizedBox(height: 4),
            Text(
              _lastNameError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
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

  Widget _buildEmailPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.loginEmail,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountFormEmailDesc,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: ShadInput(
              controller: _emailController,
              placeholder: Text(l10n.loginEmail),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {
                if (_emailError != null) {
                  setState(() => _emailError = null);
                }
              },
            ),
          ),
          if (_emailError != null) ...[
            const SizedBox(height: 4),
            Text(
              _emailError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNicknamePage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            "What's your name?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a nickname so your squad mates know who you are.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Center(
            child: UserAvatar(
              name: _nicknameController.text.isEmpty
                  ? '?'
                  : _nicknameController.text,
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: 'Your nickname...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              onChanged: (_) {
                if (_nicknameError != null) {
                  setState(() => _nicknameError = null);
                }
                setState(() {});
              },
            ),
          ),
          if (_nicknameError != null) ...[
            const SizedBox(height: 4),
            Text(
              _nicknameError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: _generateNickname,
            child: const Text(
              'Generate random nickname',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPasswordPage(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountFormPassword,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountFormPasswordHint,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.accountFormPassword,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ShadInput(
                    controller: _passwordController,
                    placeholder: Text(l10n.accountFormPassword),
                    obscureText: _obscurePassword,
                    onChanged: (_) {
                      if (_passwordError != null) {
                        setState(() => _passwordError = null);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ],
            ),
          ),
          if (_passwordError != null) ...[
            const SizedBox(height: 4),
            Text(
              _passwordError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.accountFormConfirmPassword,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ShadInput(
                    controller: _confirmPasswordController,
                    placeholder: Text(l10n.accountFormConfirmPassword),
                    obscureText: _obscureConfirmPassword,
                    onChanged: (_) {
                      if (_confirmPasswordError != null) {
                        setState(() => _confirmPasswordError = null);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                ),
              ],
            ),
          ),
          if (_confirmPasswordError != null) ...[
            const SizedBox(height: 4),
            Text(
              _confirmPasswordError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
