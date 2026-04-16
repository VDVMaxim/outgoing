class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class AppConfig {
  static const String appVersion = '1.0.0';

  static const String termsOfServiceUrl = 'https://clubapp.be/terms';
  static const String privacyPolicyUrl = 'https://clubapp.be/privacy';

  static const String locationPermissionTitle = 'Location Access';
  static const String locationPermissionMessage =
      'Location is necessary to use Squad Mode and check the vibe of clubs nearby. '
      'Your location is only shared when you are in an active squad and automatically '
      'stops at 6 AM.';

  static const String notificationPermissionTitle = 'Notifications';
  static const String notificationPermissionMessage =
      'Enable notifications to receive Flash Promos and Squad alerts when you\'re '
      'away from your phone.';

  static const List<FaqItem> faqItems = [
    FaqItem(
      question: 'How does Squad Mode work?',
      answer:
          'Squad Mode allows you to share your location with your friends in real-time. '
          'Create a squad and share the PIN code with your friends. Everyone in the squad '
          'can see each other on the map until 6 AM, when it automatically disappears.',
    ),
    FaqItem(
      question: 'Is my location being tracked?',
      answer:
          'Your location is only shared when you actively join a Squad. At 6 AM, all '
          'Squads automatically disappear for everyone\'s privacy. You can leave a Squad '
          'at any time from the Squad screen.',
    ),
    FaqItem(
      question: 'How do I check the vibe of a club?',
      answer:
          'The Vibe feature lets you confirm the atmosphere of a club in real-time. '
          'To update the vibe, you need to be within 50 meters of the club. Other users '
          'will see when the vibe was last confirmed.',
    ),
    FaqItem(
      question: 'Can I use the app without an account?',
      answer:
          'Yes! You can use the app anonymously with just a nickname. Your data is '
          'linked to your device. You can create an account later to sync your profile '
          'across devices.',
    ),
    FaqItem(
      question: 'How do I create a Squad?',
      answer:
          'Go to the Map screen and tap the Squad button. Enter a nickname if you '
          'haven\'t already, and tap "Create New Squad". Share the PIN code with your '
          'friends so they can join.',
    ),
    FaqItem(
      question: 'What happens at 6 AM?',
      answer:
          'All active Squads automatically end at 6 AM for everyone\'s privacy. '
          'Location sharing stops and the Squad disappears. You\'ll need to create a '
          'new Squad if you want to continue sharing locations.',
    ),
    FaqItem(
      question: 'How accurate is the club location?',
      answer:
          'Club locations are based on publicly available information and user reports. '
          'We continuously update this data, but locations may not always be 100% accurate. '
          'If you notice an issue, you can report it through the feedback form.',
    ),
    FaqItem(
      question: 'Why do I need to allow location access?',
      answer:
          'Location access is essential for the core features of the app: seeing which '
          'clubs are nearby, checking and confirming the vibe, and sharing your location '
          'with your Squad. Without it, these features won\'t work.',
    ),
    FaqItem(
      question: 'How do I delete my account?',
      answer:
          'Go to Settings > Account > Delete Account. All your personal data will be '
          'permanently deleted. Your anonymous data (vibes you confirmed, club reports) '
          'will remain but will no longer be linked to you.',
    ),
    FaqItem(
      question: 'Can I change my nickname?',
      answer:
          'Yes! Go to Settings > Account and tap on your nickname to change it. '
          'Your new nickname will be visible to your Squad members immediately.',
    ),
  ];
}
