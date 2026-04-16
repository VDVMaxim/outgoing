// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Club App';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navActivities => 'Events';

  @override
  String get navSettings => 'Settings';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboarding1Title => 'Discover Your City';

  @override
  String get onboarding1Desc =>
      'See at a glance which neighborhoods are buzzing, find your favorite clubs and plan your night out with our interactive map.';

  @override
  String get onboarding2Title => 'Squad Mode';

  @override
  String get onboarding2Desc =>
      'Never lose your friends again. Create a Squad with a PIN code and temporarily share your location on the map. Stops automatically at 6 AM.';

  @override
  String get onboarding3Title => 'Comfort & Safety';

  @override
  String get onboarding3Desc =>
      'Search specifically for clubs with free water, safe chill zones and check real-time \'Vibes\' confirmed by fellow visitors.';

  @override
  String get onboarding4Title => 'Your Voice Matters';

  @override
  String get onboarding4Desc =>
      'This app is developed weekly for and by students. Send bugs or feedback in 1 click from the settings.';

  @override
  String get onboardingNicknameTitle => 'What\'s your name?';

  @override
  String get onboardingNicknameDesc =>
      'Choose a nickname so your squad mates know who you are.';

  @override
  String get onboardingNicknameHint => 'Your nickname...';

  @override
  String get onboardingNicknameGenerate => 'Generate random nickname';

  @override
  String get onboardingLocationTitle => 'Discover the Vibe';

  @override
  String get onboardingLocationDesc =>
      'We use your location to show live which clubs are nearby and what the current atmosphere is. No account needed, stay anonymous.';

  @override
  String get onboardingLocationAllow => 'Allow Location';

  @override
  String get onboardingLocationSkip => 'Maybe Later';

  @override
  String get homeHighlightsTitle => 'Top 3 Highlights';

  @override
  String get homeTrendingTitle => 'Trending: Most Popular';

  @override
  String get homeAlertTitle => 'Warning: Police Check';

  @override
  String get homeAlertDesc =>
      'Heavy crowds and a police control have been reported at the start of Overpoortstraat. Be careful.';

  @override
  String get activitiesTitle => 'Events & Promotions';

  @override
  String get activitiesSearchHint => 'Search by association, club, theme...';

  @override
  String get activitiesEmpty => 'No events found.';

  @override
  String get activitiesDetails => 'Details';

  @override
  String get activitiesUnknownCrowd => 'Unknown';

  @override
  String get mapSearchHint => 'Search by district or club...';

  @override
  String get mapFood => 'Food';

  @override
  String get mapFilters => 'Filters';

  @override
  String get mapClearAll => 'Clear all';

  @override
  String get mapCategories => 'Categories';

  @override
  String mapOpenClubs(int count) {
    return '$count clubs open';
  }

  @override
  String get mapOnline => 'Online';

  @override
  String get mapLastSeen => 'Last seen';

  @override
  String get mapJustNow => 'just now';

  @override
  String get mapMinuteAgo => '1 minute ago';

  @override
  String mapMinutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String get mapHourAgo => '1 hour ago';

  @override
  String mapHoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get clubVibeTitle => 'Vibe';

  @override
  String clubVibeConfirmed(int minutes) {
    return 'confirmed $minutes min ago';
  }

  @override
  String get clubVibeUpdate => 'Update';

  @override
  String get clubRoute => 'Route';

  @override
  String get clubTaxi => 'Taxi';

  @override
  String get clubUnknownCrowd => 'Unknown';

  @override
  String get toastLocationUnknown => 'Location unknown, cannot check Vibe.';

  @override
  String toastTooFarAway(int distance) {
    return 'You are ${distance}m away. You must be within 50m.';
  }

  @override
  String get squadTitle => 'Squad Mode';

  @override
  String get squadSubtitle => 'Don\'t lose sight of each other.';

  @override
  String get squadDesc =>
      'See where your friends are on the map until 06:00. Then the Squad automatically disappears for everyone\'s privacy.';

  @override
  String get squadCreate => 'Create New Squad';

  @override
  String get squadJoin => 'Join';

  @override
  String get squadOr => 'OR JOIN';

  @override
  String get squadPinHint => 'Enter 6-digit PIN';

  @override
  String get squadPinLabel => 'YOUR SQUAD PIN';

  @override
  String squadMembers(int count) {
    return 'Active Members ($count/10)';
  }

  @override
  String get squadYou => 'You (Anonymous)';

  @override
  String get squadSharingOn => 'Location sharing is on';

  @override
  String get squadSharingLive => 'Live location is being shared';

  @override
  String get squadLeave => 'Leave Squad';

  @override
  String get squadWrongPin => 'PIN is incorrect or session does not exist.';

  @override
  String get squadLocationRequired => 'Location Required';

  @override
  String get squadLocationDesc =>
      'Squad mode needs your location to share your position with squad members. Your location is only shared while in an active squad.';

  @override
  String get squadEnableLocation => 'Enable Location';

  @override
  String get squadNicknameRequired => 'Nickname Required';

  @override
  String get squadNicknameRequiredDesc =>
      'You need to set a nickname before joining a squad. Go to Settings to set your nickname.';

  @override
  String get squadError => 'Error';

  @override
  String get squadPinCopied => 'PIN copied';

  @override
  String get squadCopyPin => 'Copy PIN';

  @override
  String get squadScanQR => 'Scan QR code';

  @override
  String get squadOffline => 'Offline';

  @override
  String get squadOnline => 'Online';

  @override
  String get squadFailedToJoin => 'Failed to join squad';

  @override
  String get squadFailedToCreate => 'Failed to create squad';

  @override
  String get squadNicknameFirst => 'Please set a nickname in Settings first';

  @override
  String get squadLocationRequiredToast =>
      'Location permission is required for squad mode';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSquadProfile => 'Squad Profile';

  @override
  String get settingsNickname => 'Nickname';

  @override
  String get settingsNoNickname => 'No nickname set';

  @override
  String get settingsNicknameHint => 'Set a nickname for squad mode';

  @override
  String get settingsChangeNickname => 'Change Nickname';

  @override
  String settingsNicknameSet(String nickname) {
    return 'Nickname set to: $nickname';
  }

  @override
  String get settingsSetNickname => 'Set Nickname';

  @override
  String get settingsSave => 'Save';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsNotifications => 'Notifications & Privacy';

  @override
  String get settingsPushNotifs => 'Push Notifications';

  @override
  String get settingsPushNotifsSub => 'For Flash Promos and Squad alerts';

  @override
  String get settingsAnonSession => 'Anonymous Session';

  @override
  String get settingsAnonSessionSub => 'Device ID linked';

  @override
  String get settingsDestroySession => 'Destroy Session';

  @override
  String get settingsDestroySessionTitle => 'Clear session?';

  @override
  String get settingsDestroySessionDesc =>
      'This will clear your anonymous session. You are not permanently logged in anywhere.';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDelete => 'Clear';

  @override
  String get settingsAbout => 'About Club App';

  @override
  String get settingsFeedback => 'Report Bugs & Feedback';

  @override
  String get settingsFeedbackSub => 'Help make the app better';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageNl => 'Nederlands';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get splashSetupVerifying => 'Verifying services and data…';

  @override
  String get splashSetupReady => 'You\'re ready';

  @override
  String get splashSetupErrorTitle => 'We couldn\'t verify setup';

  @override
  String get splashSetupErrorTimeout =>
      'The connection timed out. Check your network and try again.';

  @override
  String get splashSetupErrorGeneric =>
      'Something went wrong. Check your connection and try again.';

  @override
  String get splashRetry => 'Try again';

  @override
  String get optionScreenTitle => 'How do you want to start?';

  @override
  String get optionScreenAnonymous => 'Stay anonymous';

  @override
  String get optionScreenAnonymousDesc =>
      'You can always create an account later';

  @override
  String get optionScreenCreateAccount => 'Create account';

  @override
  String get optionScreenCreateAccountDesc =>
      'Save your profile and sync across devices';

  @override
  String get accountFormTitle => 'Create account';

  @override
  String get accountFormFirstName => 'First name';

  @override
  String get accountFormLastName => 'Last name';

  @override
  String get accountFormEmail => 'Email';

  @override
  String get accountFormBirthday => 'Birthday';

  @override
  String get accountFormBirthdayRequired => 'Please select your birthday';

  @override
  String get accountFormBirthdaySelect => 'Select date';

  @override
  String get accountFormPersonalInfo => 'About you';

  @override
  String get accountFormPersonalInfoDesc => 'Tell us who you are';

  @override
  String get accountFormEmailDesc => 'Your email is only used to log in';

  @override
  String get accountFormNickname => 'Nickname for Squad';

  @override
  String get accountFormNicknameHint =>
      'Your nickname is only visible to squad members';

  @override
  String get accountFormPassword => 'Password';

  @override
  String get accountFormPasswordHint => 'At least 6 characters';

  @override
  String get accountFormConfirmPassword => 'Confirm password';

  @override
  String get accountFormPasswordMismatch => 'Passwords do not match';

  @override
  String get accountFormNext => 'Next';

  @override
  String get accountFormCreate => 'Create Account';

  @override
  String get accountFormAlreadyHave => 'Already have an account?';

  @override
  String get accountFormLogin => 'Log in';

  @override
  String get accountFormRequired => 'This field is required';

  @override
  String get accountFormInvalidEmail => 'Invalid email address';

  @override
  String get accountFormEmailTaken => 'This email is already in use';

  @override
  String get accountFormMinPassword => 'Password must be at least 6 characters';

  @override
  String get creatingTitle => 'Creating account...';

  @override
  String get creatingError => 'Something went wrong. Try again.';

  @override
  String accountSuccessTitle(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get accountSuccessSubtitle => 'Your profile has been created';

  @override
  String get accountSuccessContinue => 'Continue';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginInvalidCredentials => 'Email or password is incorrect';

  @override
  String get loginNoAccount => 'No account yet?';

  @override
  String get loginRegister => 'Register';

  @override
  String get settingsAnonymous => 'Anonymous';

  @override
  String get settingsLogin => 'Log in';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get settingsLogoutConfirm =>
      'Are you sure? Your nickname will be saved.';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountDesc =>
      'All data will be permanently deleted';

  @override
  String get settingsDeleteAccountConfirm => 'Delete account?';

  @override
  String get settingsDeleteAccountWarning =>
      'All your data will be permanently deleted. This action cannot be undone.';

  @override
  String get settingsOk => 'OK';

  @override
  String get settingsYes => 'Yes';

  @override
  String get settingsNo => 'No';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsReportBug => 'Report a bug';

  @override
  String get settingsRateApp => 'Rate the app';

  @override
  String get settingsShareApp => 'Share the app';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';
}
