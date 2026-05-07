import 'package:flutter/material.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker_with_button.dart';
import 'package:flutter_clubapp/features/onboarding/widgets/onboarding_wizard.dart';

class NicknameStep implements OnboardingStep {
  final TextEditingController nicknameController;

  NicknameStep({required this.nicknameController});

  @override
  Widget build(BuildContext context, VoidCallback onStateRefresh) {
    return NicknamePickerWithButton(
      nicknameController: nicknameController,
      onStateRefresh: onStateRefresh,
      showGenerateButton: false,
    );
  }

  @override
  String? validate(BuildContext context) {
    final nickname = nicknameController.text.trim();
    if (nickname.isEmpty) {
      return null;
    }
    return null;
  }

  @override
  VoidCallback? onNextPressed;

  @override
  void setOnNextCallback(VoidCallback? callback) {
    onNextPressed = callback;
  }
}
