import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';

class AuthFormState {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String nickname;
  final String bio;
  
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? firstNameError;
  final String? lastNameError;
  final String? nicknameError;
  
  final AsyncValue<void> submissionStatus;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.firstName = '',
    this.lastName = '',
    this.nickname = '',
    this.bio = '',
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.firstNameError,
    this.lastNameError,
    this.nicknameError,
    this.submissionStatus = const AsyncData(null),
  });

  AuthFormState copyWith({
    String? email, String? password, String? confirmPassword,
    String? firstName, String? lastName, String? nickname, String? bio,
    String? emailError, String? passwordError, String? confirmPasswordError,
    String? firstNameError, String? lastNameError, String? nicknameError,
    AsyncValue<void>? submissionStatus,
    bool clearErrors = false,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      bio: bio ?? this.bio,
      emailError: clearErrors ? null : (emailError ?? this.emailError),
      passwordError: clearErrors ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearErrors ? null : (confirmPasswordError ?? this.confirmPasswordError),
      firstNameError: clearErrors ? null : (firstNameError ?? this.firstNameError),
      lastNameError: clearErrors ? null : (lastNameError ?? this.lastNameError),
      nicknameError: clearErrors ? null : (nicknameError ?? this.nicknameError),
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}

class AuthFormNotifier extends AutoDisposeNotifier<AuthFormState> {
  @override
  AuthFormState build() {
    // We lezen de huidige nickname uit (anoniem of eerder opgeslagen)
    // en stellen deze meteen in als startwaarde voor het formulier!
    final profile = ref.read(userProfileServiceProvider);
    
    return AuthFormState(
      nickname: profile.nickname ?? '',
    );
  }

  void updateEmail(String value) => state = state.copyWith(email: value.trim(), clearErrors: true);
  void updatePassword(String value) => state = state.copyWith(password: value, clearErrors: true);
  void updateConfirmPassword(String value) => state = state.copyWith(confirmPassword: value, clearErrors: true);
  void updateFirstName(String value) => state = state.copyWith(firstName: value.trim(), clearErrors: true);
  void updateLastName(String value) => state = state.copyWith(lastName: value.trim(), clearErrors: true);
  void updateNickname(String value) => state = state.copyWith(nickname: value.trim(), clearErrors: true);
  void updateBio(String value) => state = state.copyWith(bio: value.trim());

  bool validateRegistrationPage(int page) {
    bool isValid = true;
    String? fNameErr, lNameErr, nickErr, emailErr, passErr, confPassErr;

    if (page == 0 && state.firstName.isEmpty) { fNameErr = 'errorFirstNameRequired'; isValid = false; }
    if (page == 1 && state.lastName.isEmpty) { lNameErr = 'errorLastNameRequired'; isValid = false; }
    if (page == 2 && state.nickname.length < 3) { nickErr = 'errorNicknameLength'; isValid = false; }
    if (page == 4 && (!state.email.contains('@') || state.email.isEmpty)) { emailErr = 'errorInvalidEmail'; isValid = false; }
    if (page == 5) {
      if (state.password.length < 6) { passErr = 'errorPasswordLength'; isValid = false; }
      if (state.password != state.confirmPassword) { confPassErr = 'errorPasswordMismatch'; isValid = false; }
    }

    state = state.copyWith(
      firstNameError: fNameErr, lastNameError: lNameErr,
      nicknameError: nickErr, emailError: emailErr,
      passwordError: passErr, confirmPasswordError: confPassErr,
    );
    return isValid;
  }

  Future<void> login() async {
    if (state.email.isEmpty || state.password.isEmpty) return;
    state = state.copyWith(submissionStatus: const AsyncLoading());
    final success = await ref.read(authProvider.notifier).signIn(email: state.email, password: state.password);
    state = state.copyWith(submissionStatus: success ? const AsyncData(null) : AsyncError("Login failed", StackTrace.current));
  }

  Future<bool> register() async {
    state = state.copyWith(submissionStatus: const AsyncLoading());
    final success = await ref.read(authProvider.notifier).signUp(
      email: state.email, password: state.password,
      firstName: state.firstName, lastName: state.lastName,
      nickname: state.nickname, bio: state.bio,
    );
    state = state.copyWith(submissionStatus: success ? const AsyncData(null) : AsyncError("Registration failed", StackTrace.current));
    return success;
  }
}

final authFormProvider = NotifierProvider.autoDispose<AuthFormNotifier, AuthFormState>(() => AuthFormNotifier());