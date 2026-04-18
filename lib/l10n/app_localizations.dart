import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// No description provided for @appName.
  ///
  /// In nl, this message translates to:
  /// **'Club App'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In nl, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In nl, this message translates to:
  /// **'Kaart'**
  String get navMap;

  /// No description provided for @navActivities.
  ///
  /// In nl, this message translates to:
  /// **'Acties'**
  String get navActivities;

  /// No description provided for @navSettings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get navSettings;

  /// No description provided for @onboardingSkip.
  ///
  /// In nl, this message translates to:
  /// **'Overslaan'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In nl, this message translates to:
  /// **'Volgende'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In nl, this message translates to:
  /// **'Starten'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In nl, this message translates to:
  /// **'Ontdek je stad'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In nl, this message translates to:
  /// **'Bekijk in één oogopslag welke buurten bruisen, vind je favoriete clubs en plan je nachtleven met onze interactieve kaart.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In nl, this message translates to:
  /// **'Squad Mode'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In nl, this message translates to:
  /// **'Raak nooit meer je vrienden kwijt. Creëer een Squad via een pincode en deel tijdelijk jullie locatie op de kaart. Stopt automatisch om 6 uur \'s ochtends.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In nl, this message translates to:
  /// **'Comfort & Veiligheid'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In nl, this message translates to:
  /// **'Zoek specifiek naar clubs met gratis water, veilige chillzones en bekijk real-time \'Vibes\' die door mede-bezoekers bevestigd zijn.'**
  String get onboarding3Desc;

  /// No description provided for @onboarding4Title.
  ///
  /// In nl, this message translates to:
  /// **'Jouw Stem Telt'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Desc.
  ///
  /// In nl, this message translates to:
  /// **'Deze app is wekelijks in ontwikkeling vóór en dóór de student. Bugs of feedback stuur je in 1 klik in de instellingen door.'**
  String get onboarding4Desc;

  /// No description provided for @onboardingNicknameTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wat is je naam?'**
  String get onboardingNicknameTitle;

  /// No description provided for @onboardingNicknameDesc.
  ///
  /// In nl, this message translates to:
  /// **'Kies een nickname om je squad mates te laten weten wie je bent.'**
  String get onboardingNicknameDesc;

  /// No description provided for @onboardingNicknameHint.
  ///
  /// In nl, this message translates to:
  /// **'Je nickname...'**
  String get onboardingNicknameHint;

  /// No description provided for @onboardingNicknameGenerate.
  ///
  /// In nl, this message translates to:
  /// **'Genereer random nickname'**
  String get onboardingNicknameGenerate;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In nl, this message translates to:
  /// **'Ontdek de Vibe'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationDesc.
  ///
  /// In nl, this message translates to:
  /// **'We gebruiken je locatie om live te tonen welke clubs dichtbij zijn en wat de actuele sfeer is. Geen account nodig, blijf anoniem.'**
  String get onboardingLocationDesc;

  /// No description provided for @onboardingLocationAllow.
  ///
  /// In nl, this message translates to:
  /// **'Locatie Toestaan'**
  String get onboardingLocationAllow;

  /// No description provided for @onboardingLocationSkip.
  ///
  /// In nl, this message translates to:
  /// **'Misschien Later'**
  String get onboardingLocationSkip;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In nl, this message translates to:
  /// **'Setup'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingStartExploring.
  ///
  /// In nl, this message translates to:
  /// **'Ontdekken'**
  String get onboardingStartExploring;

  /// No description provided for @onboardingAllSet.
  ///
  /// In nl, this message translates to:
  /// **'Je bent klaar!'**
  String get onboardingAllSet;

  /// No description provided for @onboardingExploreNearby.
  ///
  /// In nl, this message translates to:
  /// **'Laten we ontdekken wat er in de buurt gebeurt.'**
  String get onboardingExploreNearby;

  /// No description provided for @onboardingSettingUp.
  ///
  /// In nl, this message translates to:
  /// **'Account wordt ingesteld...'**
  String get onboardingSettingUp;

  /// No description provided for @onboardingNicknameRequired.
  ///
  /// In nl, this message translates to:
  /// **'Voer een nickname in'**
  String get onboardingNicknameRequired;

  /// No description provided for @onboardingNicknameMinLength.
  ///
  /// In nl, this message translates to:
  /// **'Nickname moet minimaal 3 tekens zijn'**
  String get onboardingNicknameMinLength;

  /// No description provided for @homeHighlightsTitle.
  ///
  /// In nl, this message translates to:
  /// **'Top 3 Highlights'**
  String get homeHighlightsTitle;

  /// No description provided for @homeTrendingTitle.
  ///
  /// In nl, this message translates to:
  /// **'Trending: Meest Populair'**
  String get homeTrendingTitle;

  /// No description provided for @homeAlertTitle.
  ///
  /// In nl, this message translates to:
  /// **'Let op: Controleactie'**
  String get homeAlertTitle;

  /// No description provided for @homeAlertDesc.
  ///
  /// In nl, this message translates to:
  /// **'Er is momenteel veel drukte en politiecontrole gemeld aan het begin van de Overpoortstraat. Wees voorzichtig.'**
  String get homeAlertDesc;

  /// No description provided for @activitiesTitle.
  ///
  /// In nl, this message translates to:
  /// **'Activiteiten & Acties'**
  String get activitiesTitle;

  /// No description provided for @activitiesSearchHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoek vereniging, club, thema...'**
  String get activitiesSearchHint;

  /// No description provided for @activitiesEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Geen acties gevonden.'**
  String get activitiesEmpty;

  /// No description provided for @activitiesDetails.
  ///
  /// In nl, this message translates to:
  /// **'Details'**
  String get activitiesDetails;

  /// No description provided for @activitiesUnknownCrowd.
  ///
  /// In nl, this message translates to:
  /// **'Onbekend'**
  String get activitiesUnknownCrowd;

  /// No description provided for @mapSearchHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoek op wijk of club...'**
  String get mapSearchHint;

  /// No description provided for @mapFood.
  ///
  /// In nl, this message translates to:
  /// **'Eten'**
  String get mapFood;

  /// No description provided for @mapFilters.
  ///
  /// In nl, this message translates to:
  /// **'Filters'**
  String get mapFilters;

  /// No description provided for @mapClearAll.
  ///
  /// In nl, this message translates to:
  /// **'Alles wissen'**
  String get mapClearAll;

  /// No description provided for @mapCategories.
  ///
  /// In nl, this message translates to:
  /// **'Categorieën'**
  String get mapCategories;

  /// No description provided for @mapOpenClubs.
  ///
  /// In nl, this message translates to:
  /// **'{count} clubs open'**
  String mapOpenClubs(int count);

  /// No description provided for @mapOnline.
  ///
  /// In nl, this message translates to:
  /// **'Online'**
  String get mapOnline;

  /// No description provided for @mapLastSeen.
  ///
  /// In nl, this message translates to:
  /// **'Laatst gezien'**
  String get mapLastSeen;

  /// No description provided for @mapJustNow.
  ///
  /// In nl, this message translates to:
  /// **'zojuist'**
  String get mapJustNow;

  /// No description provided for @mapMinuteAgo.
  ///
  /// In nl, this message translates to:
  /// **'1 minuut geleden'**
  String get mapMinuteAgo;

  /// No description provided for @mapMinutesAgo.
  ///
  /// In nl, this message translates to:
  /// **'{count} minuten geleden'**
  String mapMinutesAgo(int count);

  /// No description provided for @mapHourAgo.
  ///
  /// In nl, this message translates to:
  /// **'1 uur geleden'**
  String get mapHourAgo;

  /// No description provided for @mapHoursAgo.
  ///
  /// In nl, this message translates to:
  /// **'{count} uur geleden'**
  String mapHoursAgo(int count);

  /// No description provided for @clubVibeTitle.
  ///
  /// In nl, this message translates to:
  /// **'Vibe'**
  String get clubVibeTitle;

  /// No description provided for @clubVibeConfirmed.
  ///
  /// In nl, this message translates to:
  /// **'{minutes} min geleden bevestigd'**
  String clubVibeConfirmed(int minutes);

  /// No description provided for @clubVibeUpdate.
  ///
  /// In nl, this message translates to:
  /// **'Update'**
  String get clubVibeUpdate;

  /// No description provided for @clubRoute.
  ///
  /// In nl, this message translates to:
  /// **'Route'**
  String get clubRoute;

  /// No description provided for @clubTaxi.
  ///
  /// In nl, this message translates to:
  /// **'Taxi'**
  String get clubTaxi;

  /// No description provided for @clubUnknownCrowd.
  ///
  /// In nl, this message translates to:
  /// **'Onbekend'**
  String get clubUnknownCrowd;

  /// No description provided for @toastLocationUnknown.
  ///
  /// In nl, this message translates to:
  /// **'Locatie onbekend, kan Vibe niet checken.'**
  String get toastLocationUnknown;

  /// No description provided for @toastTooFarAway.
  ///
  /// In nl, this message translates to:
  /// **'Je bent {distance}m verwijderd. Je moet binnen 50m zijn.'**
  String toastTooFarAway(int distance);

  /// No description provided for @squadTitle.
  ///
  /// In nl, this message translates to:
  /// **'Squad Mode'**
  String get squadTitle;

  /// No description provided for @squadSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Verlies elkaar niet uit het oog.'**
  String get squadSubtitle;

  /// No description provided for @squadDesc.
  ///
  /// In nl, this message translates to:
  /// **'Zien waar je maten zijn op de kaart tot 06:00. Danana verdwijnt de Squad automatisch voor ieders privacy.'**
  String get squadDesc;

  /// No description provided for @squadCreate.
  ///
  /// In nl, this message translates to:
  /// **'Nieuwe Squad Maken'**
  String get squadCreate;

  /// No description provided for @squadJoin.
  ///
  /// In nl, this message translates to:
  /// **'Deelnemen'**
  String get squadJoin;

  /// No description provided for @squadOr.
  ///
  /// In nl, this message translates to:
  /// **'OF DEELNEMEN'**
  String get squadOr;

  /// No description provided for @squadPinHint.
  ///
  /// In nl, this message translates to:
  /// **'Voer 6-cijferige PIN in'**
  String get squadPinHint;

  /// No description provided for @squadPinLabel.
  ///
  /// In nl, this message translates to:
  /// **'JULLIE SQUAD PIN'**
  String get squadPinLabel;

  /// No description provided for @squadMembers.
  ///
  /// In nl, this message translates to:
  /// **'Actieve Leden ({count}/10)'**
  String squadMembers(int count);

  /// No description provided for @squadYou.
  ///
  /// In nl, this message translates to:
  /// **'Jij (Anoniem)'**
  String get squadYou;

  /// No description provided for @squadSharingOn.
  ///
  /// In nl, this message translates to:
  /// **'Locatie delen staat aan'**
  String get squadSharingOn;

  /// No description provided for @squadSharingLive.
  ///
  /// In nl, this message translates to:
  /// **'Live locatie wordt gedeeld'**
  String get squadSharingLive;

  /// No description provided for @squadLeave.
  ///
  /// In nl, this message translates to:
  /// **'Squad Verlaten'**
  String get squadLeave;

  /// No description provided for @squadWrongPin.
  ///
  /// In nl, this message translates to:
  /// **'Pin is onjuist of sessie bestaat niet.'**
  String get squadWrongPin;

  /// No description provided for @squadLocationRequired.
  ///
  /// In nl, this message translates to:
  /// **'Locatie Nodig'**
  String get squadLocationRequired;

  /// No description provided for @squadLocationDesc.
  ///
  /// In nl, this message translates to:
  /// **'Squad mode heeft je locatie nodig om je positie te delen met squad leden. Je locatie wordt alleen gedeeld tijdens een actieve squad.'**
  String get squadLocationDesc;

  /// No description provided for @squadEnableLocation.
  ///
  /// In nl, this message translates to:
  /// **'Locatie Inschakelen'**
  String get squadEnableLocation;

  /// No description provided for @squadNicknameRequired.
  ///
  /// In nl, this message translates to:
  /// **'Nickname Nodig'**
  String get squadNicknameRequired;

  /// No description provided for @squadNicknameRequiredDesc.
  ///
  /// In nl, this message translates to:
  /// **'Je moet een nickname instellen voordat je bij een squad kan. Ga naar Instellingen om je nickname in te stellen.'**
  String get squadNicknameRequiredDesc;

  /// No description provided for @squadError.
  ///
  /// In nl, this message translates to:
  /// **'Fout'**
  String get squadError;

  /// No description provided for @squadPinCopied.
  ///
  /// In nl, this message translates to:
  /// **'PIN gekopieerd'**
  String get squadPinCopied;

  /// No description provided for @squadCopyPin.
  ///
  /// In nl, this message translates to:
  /// **'Kopieer PIN'**
  String get squadCopyPin;

  /// No description provided for @squadScanQR.
  ///
  /// In nl, this message translates to:
  /// **'Scan QR code'**
  String get squadScanQR;

  /// No description provided for @squadOffline.
  ///
  /// In nl, this message translates to:
  /// **'Offline'**
  String get squadOffline;

  /// No description provided for @squadOnline.
  ///
  /// In nl, this message translates to:
  /// **'Online'**
  String get squadOnline;

  /// No description provided for @squadFailedToJoin.
  ///
  /// In nl, this message translates to:
  /// **'Kon niet deelnemen aan squad'**
  String get squadFailedToJoin;

  /// No description provided for @squadFailedToCreate.
  ///
  /// In nl, this message translates to:
  /// **'Kon geen squad maken'**
  String get squadFailedToCreate;

  /// No description provided for @squadNicknameFirst.
  ///
  /// In nl, this message translates to:
  /// **'Stel eerst een nickname in bij Instellingen'**
  String get squadNicknameFirst;

  /// No description provided for @squadLocationRequiredToast.
  ///
  /// In nl, this message translates to:
  /// **'Locatie toestemming is nodig voor squad modus'**
  String get squadLocationRequiredToast;

  /// No description provided for @settingsTitle.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settingsTitle;

  /// No description provided for @settingsSquadProfile.
  ///
  /// In nl, this message translates to:
  /// **'Squad Profiel'**
  String get settingsSquadProfile;

  /// No description provided for @settingsNickname.
  ///
  /// In nl, this message translates to:
  /// **'Nickname'**
  String get settingsNickname;

  /// No description provided for @settingsNoNickname.
  ///
  /// In nl, this message translates to:
  /// **'Geen nickname ingesteld'**
  String get settingsNoNickname;

  /// No description provided for @settingsNicknameHint.
  ///
  /// In nl, this message translates to:
  /// **'Stel een nickname in voor squad modus'**
  String get settingsNicknameHint;

  /// No description provided for @settingsChangeNickname.
  ///
  /// In nl, this message translates to:
  /// **'Nickname Wijzigen'**
  String get settingsChangeNickname;

  /// No description provided for @settingsNicknameSet.
  ///
  /// In nl, this message translates to:
  /// **'Nickname ingesteld op: {nickname}'**
  String settingsNicknameSet(String nickname);

  /// No description provided for @settingsSetNickname.
  ///
  /// In nl, this message translates to:
  /// **'Nickname Instellen'**
  String get settingsSetNickname;

  /// No description provided for @settingsSave.
  ///
  /// In nl, this message translates to:
  /// **'Opslaan'**
  String get settingsSave;

  /// No description provided for @settingsDisplay.
  ///
  /// In nl, this message translates to:
  /// **'Weergave'**
  String get settingsDisplay;

  /// No description provided for @settingsDarkMode.
  ///
  /// In nl, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsNotifications.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen & Privacy'**
  String get settingsNotifications;

  /// No description provided for @settingsPushNotifs.
  ///
  /// In nl, this message translates to:
  /// **'Push Notificaties'**
  String get settingsPushNotifs;

  /// No description provided for @settingsPushNotifsSub.
  ///
  /// In nl, this message translates to:
  /// **'Voor Flash Promo\'s en Squad alerts'**
  String get settingsPushNotifsSub;

  /// No description provided for @settingsAnonSession.
  ///
  /// In nl, this message translates to:
  /// **'Anonieme Sessie'**
  String get settingsAnonSession;

  /// No description provided for @settingsAnonSessionSub.
  ///
  /// In nl, this message translates to:
  /// **'Device ID gelinkt'**
  String get settingsAnonSessionSub;

  /// No description provided for @settingsDestroySession.
  ///
  /// In nl, this message translates to:
  /// **'Sessie Vernietigen'**
  String get settingsDestroySession;

  /// No description provided for @settingsDestroySessionTitle.
  ///
  /// In nl, this message translates to:
  /// **'Sessie wissen?'**
  String get settingsDestroySessionTitle;

  /// No description provided for @settingsDestroySessionDesc.
  ///
  /// In nl, this message translates to:
  /// **'Dit wist je anonieme sessie. Je bent momenteel nergens permanent ingelogd.'**
  String get settingsDestroySessionDesc;

  /// No description provided for @settingsCancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get settingsCancel;

  /// No description provided for @settingsDelete.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen'**
  String get settingsDelete;

  /// No description provided for @settingsAbout.
  ///
  /// In nl, this message translates to:
  /// **'Over Club App'**
  String get settingsAbout;

  /// No description provided for @settingsFeedback.
  ///
  /// In nl, this message translates to:
  /// **'Bugs & Feedback Rapporteren'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackSub.
  ///
  /// In nl, this message translates to:
  /// **'Help de app beter te maken'**
  String get settingsFeedbackSub;

  /// No description provided for @settingsLanguage.
  ///
  /// In nl, this message translates to:
  /// **'Taal'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageNl.
  ///
  /// In nl, this message translates to:
  /// **'Nederlands'**
  String get settingsLanguageNl;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In nl, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In nl, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @splashSetupVerifying.
  ///
  /// In nl, this message translates to:
  /// **'Services en data controleren…'**
  String get splashSetupVerifying;

  /// No description provided for @splashSetupReady.
  ///
  /// In nl, this message translates to:
  /// **'Alles in orde'**
  String get splashSetupReady;

  /// No description provided for @splashSetupErrorTitle.
  ///
  /// In nl, this message translates to:
  /// **'Setup kon niet worden gecontroleerd'**
  String get splashSetupErrorTitle;

  /// No description provided for @splashSetupErrorTimeout.
  ///
  /// In nl, this message translates to:
  /// **'Time-out. Controleer je netwerk en probeer opnieuw.'**
  String get splashSetupErrorTimeout;

  /// No description provided for @splashSetupErrorGeneric.
  ///
  /// In nl, this message translates to:
  /// **'Er ging iets mis. Controleer je verbinding en probeer opnieuw.'**
  String get splashSetupErrorGeneric;

  /// No description provided for @splashRetry.
  ///
  /// In nl, this message translates to:
  /// **'Opnieuw proberen'**
  String get splashRetry;

  /// No description provided for @optionScreenTitle.
  ///
  /// In nl, this message translates to:
  /// **'Hoe wil je beginnen?'**
  String get optionScreenTitle;

  /// No description provided for @optionScreenAnonymous.
  ///
  /// In nl, this message translates to:
  /// **'Anoniem blijven'**
  String get optionScreenAnonymous;

  /// No description provided for @optionScreenAnonymousDesc.
  ///
  /// In nl, this message translates to:
  /// **'Je kunt later altijd nog een account aanmaken'**
  String get optionScreenAnonymousDesc;

  /// No description provided for @optionScreenCreateAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken'**
  String get optionScreenCreateAccount;

  /// No description provided for @optionScreenCreateAccountDesc.
  ///
  /// In nl, this message translates to:
  /// **'Bewaar je profiel en sync across apparaten'**
  String get optionScreenCreateAccountDesc;

  /// No description provided for @optionScreenLogin.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get optionScreenLogin;

  /// No description provided for @optionScreenLoginDesc.
  ///
  /// In nl, this message translates to:
  /// **'Heb je al een account? Log in om je voortgang te sync.'**
  String get optionScreenLoginDesc;

  /// No description provided for @accountFormTitle.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken'**
  String get accountFormTitle;

  /// No description provided for @accountFormFirstName.
  ///
  /// In nl, this message translates to:
  /// **'Voornaam'**
  String get accountFormFirstName;

  /// No description provided for @accountFormLastName.
  ///
  /// In nl, this message translates to:
  /// **'Achternaam'**
  String get accountFormLastName;

  /// No description provided for @accountFormEmail.
  ///
  /// In nl, this message translates to:
  /// **'Email'**
  String get accountFormEmail;

  /// No description provided for @accountFormBirthday.
  ///
  /// In nl, this message translates to:
  /// **'Geboortedatum'**
  String get accountFormBirthday;

  /// No description provided for @accountFormBirthdayRequired.
  ///
  /// In nl, this message translates to:
  /// **'Selecteer je geboortedatum'**
  String get accountFormBirthdayRequired;

  /// No description provided for @accountFormBirthdaySelect.
  ///
  /// In nl, this message translates to:
  /// **'Selecteer datum'**
  String get accountFormBirthdaySelect;

  /// No description provided for @accountFormPersonalInfo.
  ///
  /// In nl, this message translates to:
  /// **'Over jou'**
  String get accountFormPersonalInfo;

  /// No description provided for @accountFormPersonalInfoDesc.
  ///
  /// In nl, this message translates to:
  /// **'Vertel ons wie je bent'**
  String get accountFormPersonalInfoDesc;

  /// No description provided for @accountFormEmailDesc.
  ///
  /// In nl, this message translates to:
  /// **'Je email wordt alleen gebruikt om in te loggen'**
  String get accountFormEmailDesc;

  /// No description provided for @accountFormNickname.
  ///
  /// In nl, this message translates to:
  /// **'Nickname voor Squad'**
  String get accountFormNickname;

  /// No description provided for @accountFormNicknameHint.
  ///
  /// In nl, this message translates to:
  /// **'Je nickname is alleen zichtbaar voor squad-leden'**
  String get accountFormNicknameHint;

  /// No description provided for @accountFormPassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get accountFormPassword;

  /// No description provided for @accountFormPasswordHint.
  ///
  /// In nl, this message translates to:
  /// **'Minimaal 6 tekens'**
  String get accountFormPasswordHint;

  /// No description provided for @accountFormConfirmPassword.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig wachtwoord'**
  String get accountFormConfirmPassword;

  /// No description provided for @accountFormPasswordMismatch.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoorden komen niet overeen'**
  String get accountFormPasswordMismatch;

  /// No description provided for @accountFormNext.
  ///
  /// In nl, this message translates to:
  /// **'Volgende'**
  String get accountFormNext;

  /// No description provided for @accountFormCreate.
  ///
  /// In nl, this message translates to:
  /// **'Account Aanmaken'**
  String get accountFormCreate;

  /// No description provided for @accountFormAlreadyHave.
  ///
  /// In nl, this message translates to:
  /// **'Heb je al een account?'**
  String get accountFormAlreadyHave;

  /// No description provided for @accountFormLogin.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get accountFormLogin;

  /// No description provided for @accountFormRequired.
  ///
  /// In nl, this message translates to:
  /// **'Dit veld is verplicht'**
  String get accountFormRequired;

  /// No description provided for @accountFormInvalidEmail.
  ///
  /// In nl, this message translates to:
  /// **'Ongeldig email adres'**
  String get accountFormInvalidEmail;

  /// No description provided for @accountFormEmailTaken.
  ///
  /// In nl, this message translates to:
  /// **'Dit email adres is al in gebruik'**
  String get accountFormEmailTaken;

  /// No description provided for @accountFormMinPassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord moet minimaal 6 tekens zijn'**
  String get accountFormMinPassword;

  /// No description provided for @creatingTitle.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken...'**
  String get creatingTitle;

  /// No description provided for @creatingError.
  ///
  /// In nl, this message translates to:
  /// **'Er ging iets mis. Probeer opnieuw.'**
  String get creatingError;

  /// No description provided for @accountSuccessTitle.
  ///
  /// In nl, this message translates to:
  /// **'Welkom, {name}!'**
  String accountSuccessTitle(String name);

  /// No description provided for @accountSuccessSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Je profiel is aangemaakt'**
  String get accountSuccessSubtitle;

  /// No description provided for @accountSuccessContinue.
  ///
  /// In nl, this message translates to:
  /// **'Doorgaan'**
  String get accountSuccessContinue;

  /// No description provided for @loginTitle.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In nl, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get loginButton;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In nl, this message translates to:
  /// **'Email of wachtwoord is incorrect'**
  String get loginInvalidCredentials;

  /// No description provided for @loginNoAccount.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen account?'**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In nl, this message translates to:
  /// **'Registreren'**
  String get loginRegister;

  /// No description provided for @settingsAnonymous.
  ///
  /// In nl, this message translates to:
  /// **'Anoniem'**
  String get settingsAnonymous;

  /// No description provided for @settingsLogin.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get settingsLogin;

  /// No description provided for @settingsLogout.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In nl, this message translates to:
  /// **'Weet je het zeker? Je nickname blijft bewaard.'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountDesc.
  ///
  /// In nl, this message translates to:
  /// **'Alle data wordt permanent verwijderd'**
  String get settingsDeleteAccountDesc;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen?'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountWarning.
  ///
  /// In nl, this message translates to:
  /// **'Al je data wordt permanent verwijderd. Deze actie kan niet ongedaan worden.'**
  String get settingsDeleteAccountWarning;

  /// No description provided for @settingsOk.
  ///
  /// In nl, this message translates to:
  /// **'OK'**
  String get settingsOk;

  /// No description provided for @settingsYes.
  ///
  /// In nl, this message translates to:
  /// **'Ja'**
  String get settingsYes;

  /// No description provided for @settingsNo.
  ///
  /// In nl, this message translates to:
  /// **'Nee'**
  String get settingsNo;

  /// No description provided for @settingsAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsHelpSupport.
  ///
  /// In nl, this message translates to:
  /// **'Help & Support'**
  String get settingsHelpSupport;

  /// No description provided for @settingsReportBug.
  ///
  /// In nl, this message translates to:
  /// **'Een bug melden'**
  String get settingsReportBug;

  /// No description provided for @settingsRateApp.
  ///
  /// In nl, this message translates to:
  /// **'App beoordelen'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In nl, this message translates to:
  /// **'App delen'**
  String get settingsShareApp;

  /// No description provided for @settingsPreferences.
  ///
  /// In nl, this message translates to:
  /// **'Voorkeuren'**
  String get settingsPreferences;

  /// No description provided for @settingsTerms.
  ///
  /// In nl, this message translates to:
  /// **'Algemene Voorwaarden'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In nl, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
