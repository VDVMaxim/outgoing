import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/widgets/app_text_field.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/auth/screens/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const LoginScreen({super.key, this.onSuccess, this.onCancel});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  void _checkIfAlreadyLoggedIn() {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      widget.onSuccess?.call();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      if (_emailController.text.isEmpty) {
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

      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
        isValid = false;
      } else {
        _passwordError = null;
      }
    });
    return isValid;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) return;
    final result = await ref
        .read(authProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;

    if (result) {
      widget.onSuccess?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(authProvider).errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
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
        leading: widget.onCancel != null
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: widget.onCancel,
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.loginTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              AppTextField(
                controller: _emailController,
                placeholder: l10n.loginEmail,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _passwordController,
                placeholder: l10n.loginPassword,
                obscureText: _obscurePassword,
                errorText: _passwordError,
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
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleLogin,
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
                          l10n.loginButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.loginNoAccount,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterScreen(
                            onSuccess: widget.onSuccess,
                            onCancel: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                    child: Text(l10n.loginRegister),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}