import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';
import 'package:flutter_clubapp/core/widgets/app_text_field.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/auth/screens/register_screen.dart';
import 'package:flutter_clubapp/features/auth/providers/auth_form_provider.dart';

class LoginScreen extends ConsumerWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const LoginScreen({super.key, this.onSuccess, this.onCancel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final formState = ref.watch(authFormProvider);
    final formNotifier = ref.read(authFormProvider.notifier);
    
    final isLoading = formState.submissionStatus is AsyncLoading;

    // We can't do this in build cleanly without a post-frame callback, 
    // but the original code had _checkIfAlreadyLoggedIn. We can use a listener for side effects.
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        onSuccess?.call();
      }
    });
    
    ref.listen(authFormProvider, (previous, next) {
      next.submissionStatus.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (data) {
          if (previous?.submissionStatus is AsyncLoading && next.submissionStatus is AsyncData) {
            // Success is handled by the authProvider listener above since auth state changes
          }
        }
      );
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: onCancel != null
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: onCancel,
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
                l10n.loginSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              AppTextField(
                initialValue: formState.email,
                placeholder: l10n.loginEmail,
                keyboardType: TextInputType.emailAddress,
                errorText: _translateError(formState.emailError, l10n),
                onChanged: formNotifier.updateEmail,
              ),
              const SizedBox(height: 20),
              // We'll use a local state for obscuring password to keep it simple, 
              // or just store it in the form provider. Let's use a Hook or simple ConsumerStatefulWidget just for obscure?
              // The prompt asked for ConsumerWidget. We can add obscure to the provider or just use a StateProvider.
              Consumer(
                builder: (context, ref, child) {
                  final obscurePassword = ref.watch(_obscurePasswordProvider);
                  return AppTextField(
                    initialValue: formState.password,
                    placeholder: l10n.loginPassword,
                    obscureText: obscurePassword,
                    errorText: _translateError(formState.passwordError, l10n),
                    trailing: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onTrailingTap: () {
                      ref.read(_obscurePasswordProvider.notifier).state = !obscurePassword;
                    },
                    onChanged: formNotifier.updatePassword,
                  );
                }
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : formNotifier.login,
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
                            onSuccess: onSuccess,
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
  String? _translateError(String? key, AppLocalizations l10n) {
    if (key == null) return null;
    switch (key) {
      case 'errorEmailRequired': return l10n.errorEmailRequired;
      case 'errorInvalidEmail': return l10n.errorInvalidEmail;
      case 'errorPasswordRequired': return l10n.errorPasswordRequired;
      case 'errorEmailInUse': return l10n.errorEmailInUse;
      default: return key;
    }
  }
}

final _obscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);