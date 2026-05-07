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
  String get navMap => 'Map';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navProfile => 'Profile';

  @override
  String get navEvents => 'Deals';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSettings => 'Settings';

  @override
  String get feedViewEvents => 'View Events';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboarding1Title => 'Discover your city';

  @override
  String get onboarding1Desc =>
      'See at a glance which neighborhoods are buzzing, find your favorite clubs and plan your nightlife with our interactive map.';

  @override
  String get onboarding2Title => 'Squad Mode';

  @override
  String get onboarding2Desc =>
      'Never lose your friends again. Create a Squad with a PIN code and temporarily share your locations on the map. Automatically stops at 6 AM.';

  @override
  String get onboarding3Title => 'Comfort & Safety';

  @override
  String get onboarding3Desc =>
      'Search specifically for clubs with free water, safe chill zones and check real-time \'Vibes\' confirmed by other visitors.';

  @override
  String get onboarding4Title => 'Your Voice Matters';

  @override
  String get onboarding4Desc =>
      'This app is developed weekly for and by students. Send bugs or feedback in one click through the settings.';

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
      'We use your location to show nearby clubs live and display the current atmosphere. No account required, stay anonymous.';

  @override
  String get onboardingLocationAllow => 'Allow Location';

  @override
  String get onboardingLocationSkip => 'Maybe Later';

  @override
  String get onboardingSetupTitle => 'Setup';

  @override
  String get onboardingStartExploring => 'Explore';

  @override
  String get onboardingAllSet => 'You\'re all set!';

  @override
  String get onboardingExploreNearby =>
      'Let\'s discover what\'s happening nearby.';

  @override
  String get onboardingSettingUp => 'Setting up account...';

  @override
  String get onboardingNicknameRequired => 'Enter a nickname';

  @override
  String get onboardingNicknameMinLength =>
      'Nickname must be at least 3 characters';

  @override
  String get eventsTitle => 'Activities & Deals';

  @override
  String get eventsSearchHint => 'Search association, club, theme...';

  @override
  String get eventsEmpty => 'No deals found.';

  @override
  String get eventsDetails => 'Details';

  @override
  String get eventsUnknownCrowd => 'Unknown';

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
    return 'Confirmed $minutes min ago';
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
  String get squadSubtitle => 'Don\'t lose track of each other.';

  @override
  String get squadDesc =>
      'See where your friends are on the map until 06:00. After that, the Squad disappears automatically for everyone\'s privacy.';

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
  String get squadSharingOn => 'Location sharing is enabled';

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
      'Squad mode needs your location to share your position with squad members. Your location is only shared during an active squad.';

  @override
  String get squadEnableLocation => 'Enable Location';

  @override
  String get squadNicknameRequired => 'Nickname Required';

  @override
  String get squadNicknameRequiredDesc =>
      'You must set a nickname before joining a squad. Go to Settings to set your nickname.';

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
  String get squadNicknameFirst => 'Set a nickname first in Settings';

  @override
  String get squadLocationRequiredToast =>
      'Location permission is required for squad mode';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsFeedback => 'Your feedback';

  @override
  String get settingsReportBug => 'Report a bug';

  @override
  String get settingsRateApp => 'Rate the App';

  @override
  String get settingsShareApp => 'Share the App';

  @override
  String get settingsAbout => 'About the App';

  @override
  String get settingsTerms => 'Terms & Conditions';

  @override
  String get settingsPrivacy => 'Privacy Policy';

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
  String get settingsAnonSessionSub => 'Linked to device ID';

  @override
  String get settingsDestroySession => 'Destroy Session';

  @override
  String get settingsDestroySessionTitle => 'Delete session?';

  @override
  String get settingsDestroySessionDesc =>
      'This deletes your anonymous session. You are not permanently logged in anywhere.';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDelete => 'Delete Account';

  @override
  String get settingsFeedbackSub => 'Help improve the app';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageNl => 'Dutch';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get splashSetupVerifying => 'Checking services and data…';

  @override
  String get splashSetupReady => 'Everything is ready';

  @override
  String get splashSetupErrorTitle => 'Setup could not be verified';

  @override
  String get splashSetupErrorTimeout =>
      'Timeout. Check your network and try again.';

  @override
  String get splashSetupErrorGeneric =>
      'Something went wrong. Check your connection and try again.';

  @override
  String get splashRetry => 'Retry';

  @override
  String get optionScreenTitle => 'How would you like to start?';

  @override
  String get optionScreenAnonymous => 'Stay Anonymous';

  @override
  String get optionScreenAnonymousDesc =>
      'You can always create an account later';

  @override
  String get optionScreenCreateAccount => 'Create Account';

  @override
  String get optionScreenCreateAccountDesc =>
      'Save your profile and sync across devices';

  @override
  String get optionScreenLogin => 'Log In';

  @override
  String get optionScreenLoginDesc =>
      'Already have an account? Log in to sync your progress.';

  @override
  String get accountFormTitle => 'Create Account';

  @override
  String get accountFormFirstName => 'First Name';

  @override
  String get accountFormLastName => 'Last Name';

  @override
  String get accountFormEmail => 'Email';

  @override
  String get accountFormBirthday => 'Date of Birth';

  @override
  String get accountFormBirthdayRequired => 'Select your date of birth';

  @override
  String get accountFormBirthdaySelect => 'Select date';

  @override
  String get accountFormPersonalInfo => 'About You';

  @override
  String get accountFormPersonalInfoDesc => 'Tell us who you are';

  @override
  String get accountFormEmailDesc => 'Your email is only used for login';

  @override
  String get accountFormNickname => 'Squad Nickname';

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
  String get accountFormLogin => 'Log In';

  @override
  String get accountFormRequired => 'This field is required';

  @override
  String get accountFormInvalidEmail => 'Invalid email address';

  @override
  String get accountFormEmailTaken => 'This email address is already in use';

  @override
  String get accountFormMinPassword => 'Password must be at least 6 characters';

  @override
  String get creatingTitle => 'Creating account...';

  @override
  String get creatingError => 'Something went wrong. Please try again.';

  @override
  String accountSuccessTitle(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get accountSuccessSubtitle => 'Your profile has been created';

  @override
  String get accountSuccessContinue => 'Continue';

  @override
  String get loginTitle => 'Log In';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Log In';

  @override
  String get loginInvalidCredentials => 'Email or password is incorrect';

  @override
  String get loginNoAccount => 'Don\'t have an account yet?';

  @override
  String get loginRegister => 'Register';

  @override
  String get settingsAnonymous => 'Anonymous';

  @override
  String get settingsLogin => 'Log In';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsLogoutConfirm =>
      'Are you sure? Your nickname will remain saved.';

  @override
  String get settingsDeleteAccount => 'Delete Account';

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
  String get loginSubtitle => 'Log in to continue';

  @override
  String get registerFirstNameTitle => 'What\'s your first name?';

  @override
  String get registerFirstNameDesc => 'Enter your first name to get started';

  @override
  String get registerLastNameTitle => 'What\'s your last name?';

  @override
  String get registerLastNameDesc => 'Enter your last name to continue';

  @override
  String get registerBirthdayTitle => 'When were you born?';

  @override
  String get registerBirthdayDesc => 'We need this to verify your age';

  @override
  String get registerEmailTitle => 'What\'s your email address?';

  @override
  String get registerEmailDesc => 'We\'ll send you a verification link';

  @override
  String get registerPasswordTitle => 'Create a password';

  @override
  String get registerPasswordDesc =>
      'Make sure it\'s at least 6 characters long';

  @override
  String get errorFirstNameRequired => 'First name is required';

  @override
  String get errorLastNameRequired => 'Last name is required';

  @override
  String get errorEmailRequired => 'Email address is required';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorPasswordLength => 'Password must be at least 6 characters';

  @override
  String get errorConfirmPasswordRequired => 'Confirm your password';

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get errorNicknameRequired => 'Please enter a nickname';

  @override
  String get errorNicknameLength => 'Nickname must be at least 3 characters';

  @override
  String get errorEmailInUse => 'This email address is already in use';

  @override
  String get mapApply => 'Apply';

  @override
  String get mapSetTime => 'Set target time';

  @override
  String get mapCancel => 'Cancel';

  @override
  String get mapPlacePin => 'Place Pin';

  @override
  String get mapJoin => 'I\'m joining';

  @override
  String get vibeCheckTitle => 'How\'s the Vibe?';

  @override
  String get vibeHot => '🔥 Hot';

  @override
  String get vibeCold => '🧊 Cold';

  @override
  String get vibeCancel => 'Cancel';

  @override
  String get vibeUpdated => 'Vibe updated! +20 VP';

  @override
  String get placeOpeningHours => 'Opening Hours';

  @override
  String get placeNoOpeningHours => 'No opening hours available';

  @override
  String get placeNoVibes => 'No vibes yet tonight';

  @override
  String get placeUpdate => 'Update';

  @override
  String get placeRoute => 'Route to location';

  @override
  String get placeCheckIn => 'Check In (+10 VP)';

  @override
  String get eventsFallback => 'Event';

  @override
  String get eventsError => 'An error occurred';

  @override
  String get assocSearchTitle => 'Search Associations';

  @override
  String get assocSearchHint => 'Search by name...';

  @override
  String get assocPending => 'Pending approval';

  @override
  String get assocActive => 'Active member';

  @override
  String get assocLeave => 'Leave association';

  @override
  String get assocCancel => 'Cancel';

  @override
  String get assocSendRequest => 'Send request';

  @override
  String get pushTitle => 'Push Notifications';

  @override
  String get pushEnable => 'Enable Notifications';

  @override
  String get pushReceive => 'Receive notifications from Club App';

  @override
  String get pushPromos => 'Flash Promos';

  @override
  String get pushSquad => 'Squad Alerts';

  @override
  String get pushQuiet => 'Quiet Hours';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get accountAssoc => 'My Associations';

  @override
  String get eventHostedBy => 'Hosted by';

  @override
  String get eventStartsAt => 'Starts at';

  @override
  String get eventRoute => 'Route to location';

  @override
  String get eventCheckIn => 'Check In (+10 VP)';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileRemovePhoto => 'Remove photo';

  @override
  String get editProfileBioHint => 'Tell something about yourself...';

  @override
  String get settingsAccountDetails => 'Account Details';

  @override
  String get guestTitle => 'Welcome as Guest';

  @override
  String get guestSubtitle =>
      'Create an account or log in to vibe with your squad, earn VP and customize your profile.';

  @override
  String get guestLogin => 'Log In';

  @override
  String get guestRegister => 'Create Account';

  @override
  String get ok => 'OK';

  @override
  String get errorCouldNotOpenLink => 'Could not open link';

  @override
  String get settingsAppStoreComingSoon => 'App store link coming soon';

  @override
  String get errorCouldNotOpenEmail => 'Could not open email app';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get profilePhotoUploadError => 'Error uploading photo';

  @override
  String get profilePhotoRemoved => 'Profile photo removed';

  @override
  String get profilePhotoRemoveError => 'Error removing photo';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveError => 'Error saving profile';

  @override
  String get errorLoadingFollowers => 'Error loading followers';

  @override
  String get errorLoadingFollowing => 'Error loading following';

  @override
  String get checkInSuccess => '+10 VP! Check-in confirmed';

  @override
  String get error => 'Error';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get follow => 'Follow';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get searchAssociations => 'Search Associations';

  @override
  String get errorLoadingPlaces => 'Error loading places';

  @override
  String get errorLoadingPlacesDesc =>
      'Please check your connection and try again.';

  @override
  String get errorLoadingDetails => 'Error loading details';

  @override
  String get errorLoadingDetailsDesc => 'Could not load place details.';

  @override
  String get notNow => 'Not now';

  @override
  String get squads => 'Squads';

  @override
  String get cities => 'Cities';

  @override
  String get searchNicknamePlaceholder => 'Type a nickname...';

  @override
  String get achievements => 'Achievements';

  @override
  String get activity => 'Activity';

  @override
  String get circles => 'Circles';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get bioPlaceholder => 'I love techno and long nights...';

  @override
  String get daySun => 'Sun';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get bio => 'Bio';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get noFollowers => 'No followers yet.';

  @override
  String get followingNone => 'You are not following anyone yet.';

  @override
  String get remove => 'Remove';

  @override
  String get userNotFound => 'User not found';

  @override
  String guestWelcomeMessage(String nickname) {
    return 'Hi $nickname,\nCreate an account or log in to unlock your Vibe Level, Badges and Associations.';
  }

  @override
  String get badgeVault => 'Badge Vault';

  @override
  String get badgeVaultSubtitle => 'View your collected badges';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get leaderboardSubtitle => 'View the rankings';

  @override
  String get challenges => 'Challenges';

  @override
  String get challengesSubtitle => 'Complete missions with your squad';

  @override
  String get noRecentActivity => 'No recent activity found.';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get vibeUpdatedTitle => 'Vibe updated';

  @override
  String get noAssociations => 'You are not a member of any association yet.';

  @override
  String get errorConnection => 'Please check your connection and try again.';

  @override
  String get errorLoadingPlaceDetails => 'Could not load place details.';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get apply => 'Apply';

  @override
  String get setTargetTime => 'Set target time';

  @override
  String get placePin => 'Place Pin';

  @override
  String get imIn => 'I\'m in';

  @override
  String get notifStepTitle => 'Don\'t miss any action';

  @override
  String get notifStepDesc =>
      'Turn on push notifications to know immediately when your squad is active or when there\'s a flash promo.';

  @override
  String get notifStepEnable => 'Enable notifications';

  @override
  String get notifStepLater => 'Maybe later';

  @override
  String get registerBioTitle => 'What is your Bio?';

  @override
  String get registerBioDesc => 'Tell something about yourself (Optional)';

  @override
  String get registerBioHint => 'I love techno and long nights...';

  @override
  String registerWelcome(String firstName) {
    return 'Welcome, $firstName!';
  }

  @override
  String get registerProfileCreated => 'Your profile has been created';

  @override
  String get errorRegistrationFailed => 'Registration failed';

  @override
  String get badgeVaultTitle => 'Badge Vault';

  @override
  String get quickStats => 'Quick Stats';

  @override
  String get explorerBadges => 'Explorer Badges';

  @override
  String get socialBadges => 'Social Badges';

  @override
  String get safetyBadges => 'Safety Badges';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get yourSquad => 'Your Squad';

  @override
  String get squadChallenges => 'Squad Challenges';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed!';

  @override
  String locationsCount(int current, int required) {
    return '$current/$required locations';
  }

  @override
  String get settingsHaptics => 'Haptic Feedback';

  @override
  String get settingsRateAppSoon => 'App Store link coming soon';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get errorNoEmailApp =>
      'No email app found. Please email us at info@clubapp.be';

  @override
  String get errorEmailGeneric => 'Could not open email app';

  @override
  String get errorDeleteAccount =>
      'Something went wrong while deleting account';

  @override
  String get pushNotificationsTitle => 'Push Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsDesc => 'Receive notifications from Club App';

  @override
  String get notificationTypes => 'Notification Types';

  @override
  String get flashPromos => 'Flash Promos';

  @override
  String get flashPromosDesc => 'Get notified about last-minute deals';

  @override
  String get squadAlerts => 'Squad Alerts';

  @override
  String get squadAlertsDesc =>
      'Notifications when you\'re away from your Squad';

  @override
  String get chatMessages => 'Chat Messages';

  @override
  String get chatMessagesDesc => 'New messages from your Squad';

  @override
  String get newFeatures => 'New Features';

  @override
  String get newFeaturesDesc => 'Updates about new app features';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get dontDisturb => 'Don\'t disturb';

  @override
  String get dontDisturbDesc => 'Silence notifications during set hours';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get assocActiveMember => 'Active member';

  @override
  String get assocPendingRequest => 'Request pending';

  @override
  String get assocAboutTitle => 'About the association';

  @override
  String get assocNoDescription =>
      'This association has not added a description yet.';

  @override
  String get assocCancelRequest => 'Cancel request';

  @override
  String get assocRequestMembership => 'Request membership';

  @override
  String get allBadges => 'All Badges';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$count of $total badges unlocked';
  }

  @override
  String vpToNextLevel(int count) {
    return '$count VP to next level';
  }

  @override
  String weekendStreakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Weekends',
      one: '$count Weekend',
    );
    return '$_temp0';
  }

  @override
  String get levelNewbie => 'Newbie';

  @override
  String get levelClubHopper => 'Club Hopper';

  @override
  String get levelVibeMaster => 'Vibe Master';

  @override
  String get levelLegend => 'Legend';

  @override
  String get locationPermissionTitle => 'Location Access';

  @override
  String get locationPermissionMessage =>
      'Location is necessary to use Squad Mode and check the vibe of clubs nearby. Your location is only shared when you are in an active squad and automatically stops at 6 AM.';

  @override
  String get notificationPermissionTitle => 'Notifications';

  @override
  String get notificationPermissionMessage =>
      'Enable notifications to receive Flash Promos and Squad alerts when you\'re away from your phone.';

  @override
  String get club => 'Club';

  @override
  String get event => 'Event';
}
