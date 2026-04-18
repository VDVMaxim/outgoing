import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'base_intro_step.dart';

class VoiceMattersStep extends IntroStep {
  @override
  IconData get icon => Icons.feedback;

  @override
  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.onboarding4Title;
  }

  @override
  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.onboarding4Desc;
  }
}
