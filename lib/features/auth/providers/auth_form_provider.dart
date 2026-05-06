import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/core/providers/service_providers.dart';

class AuthFormState {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime? birthday;
  final String nickname;
  final String confirmPassword;
  
  final String? emailError;
  final String? passwordError;
  final String? firstNameError;
  final String? lastNameError;
  final String? birthdayError;
  final String? nicknameError;
  final String? confirmPasswordError;
  
  final AsyncValue<void> submissionStatus;

  AuthFormState({
    this.email = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.birthday,
    this.nickname = '',
    this.confirmPassword = '',
    this.emailError,
    this.passwordError,
    this.firstNameError,
    this.lastNameError,
    this.birthdayError,
    this.nicknameError,
    this.confirmPasswordError,
    this.submissionStatus = const AsyncValue.data(null),
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? nickname,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? firstNameError,
    String? lastNameError,
    String? birthdayError,
    String? nicknameError,
    String? confirmPasswordError,
    AsyncValue<void>? submissionStatus,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearFirstNameError = false,
    bool clearLastNameError = false,
    bool clearBirthdayError = false,
    bool clearNicknameError = false,
    bool clearConfirmPasswordError = false,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      nickname: nickname ?? this.nickname,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      firstNameError: clearFirstNameError ? null : (firstNameError ?? this.firstNameError),
      lastNameError: clearLastNameError ? null : (lastNameError ?? this.lastNameError),
      birthdayError: clearBirthdayError ? null : (birthdayError ?? this.birthdayError),
      nicknameError: clearNicknameError ? null : (nicknameError ?? this.nicknameError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}

class AuthFormNotifier extends StateNotifier<AuthFormState> {
  final Ref ref;

  AuthFormNotifier(this.ref) : super(AuthFormState());

  void updateEmail(String val) => state = state.copyWith(email: val, clearEmailError: true);
  void updatePassword(String val) => state = state.copyWith(password: val, clearPasswordError: true);
  void updateConfirmPassword(String val) => state = state.copyWith(confirmPassword: val, clearConfirmPasswordError: true);
  void updateFirstName(String val) => state = state.copyWith(firstName: val, clearFirstNameError: true);
  void updateLastName(String val) => state = state.copyWith(lastName: val, clearLastNameError: true);
  void updateNickname(String val) => state = state.copyWith(nickname: val, clearNicknameError: true);
  void updateBirthday(DateTime val) => state = state.copyWith(birthday: val, clearBirthdayError: true);

  bool validateLogin() {
    bool isValid = true;
    String? emailErr;
    String? passErr;

    if (state.email.trim().isEmpty) {
      emailErr = 'errorEmailRequired';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      emailErr = 'errorInvalidEmail';
      isValid = false;
    }

    if (state.password.isEmpty) {
      passErr = 'errorPasswordRequired';
      isValid = false;
    }

    state = state.copyWith(
      emailError: emailErr,
      passwordError: passErr,
      clearEmailError: emailErr == null,
      clearPasswordError: passErr == null,
    );
    return isValid;
  }

  bool validateFirstName() {
    if (state.firstName.trim().isEmpty) {
      state = state.copyWith(firstNameError: 'errorFirstNameRequired');
      return false;
    }
    state = state.copyWith(clearFirstNameError: true);
    return true;
  }

  bool validateLastName() {
    if (state.lastName.trim().isEmpty) {
      state = state.copyWith(lastNameError: 'errorLastNameRequired');
      return false;
    }
    state = state.copyWith(clearLastNameError: true);
    return true;
  }

  bool validateBirthday() {
    if (state.birthday == null) {
      state = state.copyWith(birthdayError: 'errorBirthdayRequired');
      return false;
    }
    state = state.copyWith(clearBirthdayError: true);
    return true;
  }

  bool validateNickname() {
    if (state.nickname.trim().isEmpty) {
      state = state.copyWith(nicknameError: 'errorNicknameRequired');
      return false;
    } else if (state.nickname.length < 3) {
      state = state.copyWith(nicknameError: 'errorNicknameLength');
      return false;
    }
    state = state.copyWith(clearNicknameError: true);
    return true;
  }

  bool validateEmail() {
    if (state.email.trim().isEmpty) {
      state = state.copyWith(emailError: 'errorEmailRequired');
      return false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      state = state.copyWith(emailError: 'errorInvalidEmail');
      return false;
    }
    state = state.copyWith(clearEmailError: true);
    return true;
  }

  bool validatePassword() {
    bool isValid = true;
    String? passErr;
    String? confErr;

    if (state.password.isEmpty) {
      passErr = 'errorPasswordRequired';
      isValid = false;
    } else if (state.password.length < 6) {
      passErr = 'errorPasswordLength';
      isValid = false;
    }

    if (state.confirmPassword.isEmpty) {
      confErr = 'errorConfirmPasswordRequired';
      isValid = false;
    } else if (state.confirmPassword != state.password) {
      confErr = 'errorPasswordMismatch';
      isValid = false;
    }

    state = state.copyWith(
      passwordError: passErr,
      confirmPasswordError: confErr,
      clearPasswordError: passErr == null,
      clearConfirmPasswordError: confErr == null,
    );
    return isValid;
  }

  bool validateRegistrationPage(int page) {
    switch (page) {
      case 0: return validateFirstName();
      case 1: return validateLastName();
      case 2: return validateBirthday();
      case 3: return validateNickname();
      case 4: return validateEmail();
      case 5: return validatePassword();
      default: return true;
    }
  }

  Future<bool> login() async {
    if (!validateLogin()) return false;

    state = state.copyWith(submissionStatus: const AsyncValue.loading());
    final success = await ref.read(authProvider.notifier).signIn(
      email: state.email.trim(), 
      password: state.password
    );

    if (success) {
      state = state.copyWith(submissionStatus: const AsyncValue.data(null));
      return true;
    } else {
      state = state.copyWith(
        submissionStatus: AsyncValue.error(
          ref.read(authProvider).errorMessage ?? 'Login failed',
          StackTrace.current,
        ),
      );
      return false;
    }
  }

  Future<bool> register() async {
    if (!validatePassword()) return false; // Last check

    state = state.copyWith(submissionStatus: const AsyncValue.loading());
    final success = await ref.read(authProvider.notifier).signUp(
      email: state.email.trim(),
      password: state.password,
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      birthday: state.birthday!,
      nickname: state.nickname.trim(),
    );

    if (success) {
      state = state.copyWith(submissionStatus: const AsyncValue.data(null));
      return true;
    } else {
      state = state.copyWith(
        submissionStatus: AsyncValue.error(
          ref.read(authProvider).errorMessage ?? 'Registration failed',
          StackTrace.current,
        ),
      );
      return false;
    }
  }
}

final authFormProvider = StateNotifierProvider.autoDispose<AuthFormNotifier, AuthFormState>((ref) {
  return AuthFormNotifier(ref);
});
