import 'package:flutter/material.dart';
import 'package:flutter_clubapp/core/utils/nickname_generator.dart';
import 'package:flutter_clubapp/core/widgets/nickname_picker.dart';

class NicknamePickerWithButton extends StatelessWidget {
  final TextEditingController nicknameController;
  final VoidCallback? onStateRefresh;
  final String? errorText;
  final bool showGenerateButton;

  const NicknamePickerWithButton({
    super.key,
    required this.nicknameController,
    this.onStateRefresh,
    this.errorText,
    this.showGenerateButton = true,
  });

  void _generateRandomNickname() {
    nicknameController.text = NicknameGenerator.generate();
    onStateRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return NicknamePicker(
      nicknameController: nicknameController,
      onGenerate: _generateRandomNickname,
      errorText: errorText,
      showGenerateButton: showGenerateButton,
    );
  }
}
