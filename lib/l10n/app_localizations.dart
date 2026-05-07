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

  /// No description provided for @navMap.
  ///
  /// In nl, this message translates to:
  /// **'Kaart'**
  String get navMap;

  /// No description provided for @navDiscover.
  ///
  /// In nl, this message translates to:
  /// **'Ontdekken'**
  String get navDiscover;

  /// No description provided for @navProfile.
  ///
  /// In nl, this message translates to:
  /// **'Profiel'**
  String get navProfile;

  /// No description provided for @navEvents.
  ///
  /// In nl, this message translates to:
  /// **'Acties'**
  String get navEvents;

  /// No description provided for @navFeed.
  ///
  /// In nl, this message translates to:
  /// **'Feed'**
  String get navFeed;

  /// No description provided for @navSettings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get navSettings;

  /// No description provided for @feedViewEvents.
  ///
  /// In nl, this message translates to:
  /// **'Bekijk Events'**
  String get feedViewEvents;

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

  /// No description provided for @eventsTitle.
  ///
  /// In nl, this message translates to:
  /// **'Activiteiten & Acties'**
  String get eventsTitle;

  /// No description provided for @eventsSearchHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoek vereniging, club, thema...'**
  String get eventsSearchHint;

  /// No description provided for @eventsEmpty.
  ///
  /// In nl, this message translates to:
  /// **'Geen acties gevonden.'**
  String get eventsEmpty;

  /// No description provided for @eventsDetails.
  ///
  /// In nl, this message translates to:
  /// **'Details'**
  String get eventsDetails;

  /// No description provided for @eventsUnknownCrowd.
  ///
  /// In nl, this message translates to:
  /// **'Onbekend'**
  String get eventsUnknownCrowd;

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
  /// **'Zien waar je maten zijn op de kaart tot 06:00. Daarna verdwijnt de Squad automatisch voor ieders privacy.'**
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

  /// No description provided for @settingsAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsPreferences.
  ///
  /// In nl, this message translates to:
  /// **'Voorkeuren'**
  String get settingsPreferences;

  /// No description provided for @settingsHelpSupport.
  ///
  /// In nl, this message translates to:
  /// **'Help & Support'**
  String get settingsHelpSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In nl, this message translates to:
  /// **'Jouw mening'**
  String get settingsFeedback;

  /// No description provided for @settingsReportBug.
  ///
  /// In nl, this message translates to:
  /// **'Een fout melden'**
  String get settingsReportBug;

  /// No description provided for @settingsRateApp.
  ///
  /// In nl, this message translates to:
  /// **'Beoordeel de App'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In nl, this message translates to:
  /// **'Deel de App'**
  String get settingsShareApp;

  /// No description provided for @settingsAbout.
  ///
  /// In nl, this message translates to:
  /// **'Over de App'**
  String get settingsAbout;

  /// No description provided for @settingsTerms.
  ///
  /// In nl, this message translates to:
  /// **'Algemene Voorwaarden'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In nl, this message translates to:
  /// **'Privacybeleid'**
  String get settingsPrivacy;

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

  /// No description provided for @loginSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Log in om door te gaan'**
  String get loginSubtitle;

  /// No description provided for @registerFirstNameTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wat is je voornaam?'**
  String get registerFirstNameTitle;

  /// No description provided for @registerFirstNameDesc.
  ///
  /// In nl, this message translates to:
  /// **'Vul je voornaam in om te beginnen'**
  String get registerFirstNameDesc;

  /// No description provided for @registerLastNameTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wat is je achternaam?'**
  String get registerLastNameTitle;

  /// No description provided for @registerLastNameDesc.
  ///
  /// In nl, this message translates to:
  /// **'Vul je achternaam in om door te gaan'**
  String get registerLastNameDesc;

  /// No description provided for @registerBirthdayTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wanneer ben je geboren?'**
  String get registerBirthdayTitle;

  /// No description provided for @registerBirthdayDesc.
  ///
  /// In nl, this message translates to:
  /// **'We hebben dit nodig om je leeftijd te verifiëren'**
  String get registerBirthdayDesc;

  /// No description provided for @registerEmailTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wat is je e-mailadres?'**
  String get registerEmailTitle;

  /// No description provided for @registerEmailDesc.
  ///
  /// In nl, this message translates to:
  /// **'We sturen je een verificatielink'**
  String get registerEmailDesc;

  /// No description provided for @registerPasswordTitle.
  ///
  /// In nl, this message translates to:
  /// **'Maak een wachtwoord'**
  String get registerPasswordTitle;

  /// No description provided for @registerPasswordDesc.
  ///
  /// In nl, this message translates to:
  /// **'Zorg dat het minstens 6 tekens lang is'**
  String get registerPasswordDesc;

  /// No description provided for @errorFirstNameRequired.
  ///
  /// In nl, this message translates to:
  /// **'Voornaam is verplicht'**
  String get errorFirstNameRequired;

  /// No description provided for @errorLastNameRequired.
  ///
  /// In nl, this message translates to:
  /// **'Achternaam is verplicht'**
  String get errorLastNameRequired;

  /// No description provided for @errorEmailRequired.
  ///
  /// In nl, this message translates to:
  /// **'E-mailadres is verplicht'**
  String get errorEmailRequired;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In nl, this message translates to:
  /// **'Ongeldig e-mailadres'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord is verplicht'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordLength.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord moet minstens 6 tekens zijn'**
  String get errorPasswordLength;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig je wachtwoord'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoorden komen niet overeen'**
  String get errorPasswordMismatch;

  /// No description provided for @errorNicknameRequired.
  ///
  /// In nl, this message translates to:
  /// **'Vul a.u.b. een bijnaam in'**
  String get errorNicknameRequired;

  /// No description provided for @errorNicknameLength.
  ///
  /// In nl, this message translates to:
  /// **'Nickname moet minstens 3 tekens zijn'**
  String get errorNicknameLength;

  /// No description provided for @errorEmailInUse.
  ///
  /// In nl, this message translates to:
  /// **'Dit e-mailadres is al in gebruik'**
  String get errorEmailInUse;

  /// No description provided for @mapApply.
  ///
  /// In nl, this message translates to:
  /// **'Toepassen'**
  String get mapApply;

  /// No description provided for @mapSetTime.
  ///
  /// In nl, this message translates to:
  /// **'Stel doeltijd in'**
  String get mapSetTime;

  /// No description provided for @mapCancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get mapCancel;

  /// No description provided for @mapPlacePin.
  ///
  /// In nl, this message translates to:
  /// **'Plaats Pin'**
  String get mapPlacePin;

  /// No description provided for @mapJoin.
  ///
  /// In nl, this message translates to:
  /// **'Ik doe mee'**
  String get mapJoin;

  /// No description provided for @vibeCheckTitle.
  ///
  /// In nl, this message translates to:
  /// **'Hoe is de Vibe?'**
  String get vibeCheckTitle;

  /// No description provided for @vibeHot.
  ///
  /// In nl, this message translates to:
  /// **'🔥 Heet'**
  String get vibeHot;

  /// No description provided for @vibeCold.
  ///
  /// In nl, this message translates to:
  /// **'🧊 Koud'**
  String get vibeCold;

  /// No description provided for @vibeCancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get vibeCancel;

  /// No description provided for @vibeUpdated.
  ///
  /// In nl, this message translates to:
  /// **'Vibe geüpdatet! +20 VP'**
  String get vibeUpdated;

  /// No description provided for @placeOpeningHours.
  ///
  /// In nl, this message translates to:
  /// **'Openingsuren'**
  String get placeOpeningHours;

  /// No description provided for @placeNoOpeningHours.
  ///
  /// In nl, this message translates to:
  /// **'Geen openingsuren bekend'**
  String get placeNoOpeningHours;

  /// No description provided for @placeNoVibes.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen vibes vanavond'**
  String get placeNoVibes;

  /// No description provided for @placeUpdate.
  ///
  /// In nl, this message translates to:
  /// **'Update'**
  String get placeUpdate;

  /// No description provided for @placeRoute.
  ///
  /// In nl, this message translates to:
  /// **'Route naar locatie'**
  String get placeRoute;

  /// No description provided for @placeCheckIn.
  ///
  /// In nl, this message translates to:
  /// **'Check In (+10 VP)'**
  String get placeCheckIn;

  /// No description provided for @eventsFallback.
  ///
  /// In nl, this message translates to:
  /// **'Event'**
  String get eventsFallback;

  /// No description provided for @eventsError.
  ///
  /// In nl, this message translates to:
  /// **'Er is een fout opgetreden'**
  String get eventsError;

  /// No description provided for @assocSearchTitle.
  ///
  /// In nl, this message translates to:
  /// **'Verenigingen zoeken'**
  String get assocSearchTitle;

  /// No description provided for @assocSearchHint.
  ///
  /// In nl, this message translates to:
  /// **'Zoek op naam...'**
  String get assocSearchHint;

  /// No description provided for @assocPending.
  ///
  /// In nl, this message translates to:
  /// **'In afwachting van goedkeuring'**
  String get assocPending;

  /// No description provided for @assocActive.
  ///
  /// In nl, this message translates to:
  /// **'Actief lid'**
  String get assocActive;

  /// No description provided for @assocLeave.
  ///
  /// In nl, this message translates to:
  /// **'Vereniging verlaten'**
  String get assocLeave;

  /// No description provided for @assocCancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get assocCancel;

  /// No description provided for @assocSendRequest.
  ///
  /// In nl, this message translates to:
  /// **'Verzoek sturen'**
  String get assocSendRequest;

  /// No description provided for @pushTitle.
  ///
  /// In nl, this message translates to:
  /// **'Push Notificaties'**
  String get pushTitle;

  /// No description provided for @pushEnable.
  ///
  /// In nl, this message translates to:
  /// **'Zet Notificaties Aan'**
  String get pushEnable;

  /// No description provided for @pushReceive.
  ///
  /// In nl, this message translates to:
  /// **'Ontvang meldingen van Club App'**
  String get pushReceive;

  /// No description provided for @pushPromos.
  ///
  /// In nl, this message translates to:
  /// **'Flash Promos'**
  String get pushPromos;

  /// No description provided for @pushSquad.
  ///
  /// In nl, this message translates to:
  /// **'Squad Alerts'**
  String get pushSquad;

  /// No description provided for @pushQuiet.
  ///
  /// In nl, this message translates to:
  /// **'Stille Uren'**
  String get pushQuiet;

  /// No description provided for @faqTitle.
  ///
  /// In nl, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @accountAssoc.
  ///
  /// In nl, this message translates to:
  /// **'Mijn Verenigingen'**
  String get accountAssoc;

  /// No description provided for @eventHostedBy.
  ///
  /// In nl, this message translates to:
  /// **'Georganiseerd door'**
  String get eventHostedBy;

  /// No description provided for @eventStartsAt.
  ///
  /// In nl, this message translates to:
  /// **'Begint om'**
  String get eventStartsAt;

  /// No description provided for @eventRoute.
  ///
  /// In nl, this message translates to:
  /// **'Route naar locatie'**
  String get eventRoute;

  /// No description provided for @eventCheckIn.
  ///
  /// In nl, this message translates to:
  /// **'Check In (+10 VP)'**
  String get eventCheckIn;

  /// No description provided for @editProfileTitle.
  ///
  /// In nl, this message translates to:
  /// **'Profiel bewerken'**
  String get editProfileTitle;

  /// No description provided for @editProfileRemovePhoto.
  ///
  /// In nl, this message translates to:
  /// **'Verwijder foto'**
  String get editProfileRemovePhoto;

  /// No description provided for @editProfileBioHint.
  ///
  /// In nl, this message translates to:
  /// **'Vertel iets over jezelf...'**
  String get editProfileBioHint;

  /// No description provided for @settingsAccountDetails.
  ///
  /// In nl, this message translates to:
  /// **'Accountgegevens'**
  String get settingsAccountDetails;

  /// No description provided for @editProfilePrivateDataDesc.
  ///
  /// In nl, this message translates to:
  /// **'Deze gegevens zijn privé en worden enkel voor communicatie gebruikt.'**
  String get editProfilePrivateDataDesc;

  /// No description provided for @guestTitle.
  ///
  /// In nl, this message translates to:
  /// **'Welkom als Gast'**
  String get guestTitle;

  /// No description provided for @guestSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Maak een account aan of log in om samen met je squad te viben, VP te verdienen en je profiel aan te passen.'**
  String get guestSubtitle;

  /// No description provided for @guestLogin.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get guestLogin;

  /// No description provided for @guestRegister.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken'**
  String get guestRegister;

  /// No description provided for @ok.
  ///
  /// In nl, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorCouldNotOpenLink.
  ///
  /// In nl, this message translates to:
  /// **'Kon link niet openen'**
  String get errorCouldNotOpenLink;

  /// No description provided for @settingsAppStoreComingSoon.
  ///
  /// In nl, this message translates to:
  /// **'App store link komt binnenkort'**
  String get settingsAppStoreComingSoon;

  /// No description provided for @errorCouldNotOpenEmail.
  ///
  /// In nl, this message translates to:
  /// **'Kon e-mail app niet openen'**
  String get errorCouldNotOpenEmail;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In nl, this message translates to:
  /// **'Profielfoto geüpdatet'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoUploadError.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij uploaden foto'**
  String get profilePhotoUploadError;

  /// No description provided for @profilePhotoRemoved.
  ///
  /// In nl, this message translates to:
  /// **'Profielfoto verwijderd'**
  String get profilePhotoRemoved;

  /// No description provided for @profilePhotoRemoveError.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij verwijderen foto'**
  String get profilePhotoRemoveError;

  /// No description provided for @profileSaved.
  ///
  /// In nl, this message translates to:
  /// **'Profiel opgeslagen'**
  String get profileSaved;

  /// No description provided for @profileSaveError.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij opslaan profiel'**
  String get profileSaveError;

  /// No description provided for @errorLoadingFollowers.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij laden van volgers'**
  String get errorLoadingFollowers;

  /// No description provided for @errorLoadingFollowing.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij laden van volgend'**
  String get errorLoadingFollowing;

  /// No description provided for @checkInSuccess.
  ///
  /// In nl, this message translates to:
  /// **'+10 VP! Check-in bevestigd'**
  String get checkInSuccess;

  /// No description provided for @error.
  ///
  /// In nl, this message translates to:
  /// **'Fout'**
  String get error;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij laden van profiel'**
  String get errorLoadingProfile;

  /// No description provided for @unfollow.
  ///
  /// In nl, this message translates to:
  /// **'Ontvolgen'**
  String get unfollow;

  /// No description provided for @follow.
  ///
  /// In nl, this message translates to:
  /// **'Volgen'**
  String get follow;

  /// No description provided for @editProfile.
  ///
  /// In nl, this message translates to:
  /// **'Profiel bewerken'**
  String get editProfile;

  /// No description provided for @searchAssociations.
  ///
  /// In nl, this message translates to:
  /// **'Zoek Verenigingen'**
  String get searchAssociations;

  /// No description provided for @errorLoadingPlaces.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij laden van locaties'**
  String get errorLoadingPlaces;

  /// No description provided for @errorLoadingPlacesDesc.
  ///
  /// In nl, this message translates to:
  /// **'Controleer je verbinding en probeer opnieuw.'**
  String get errorLoadingPlacesDesc;

  /// No description provided for @errorLoadingDetails.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij laden van details'**
  String get errorLoadingDetails;

  /// No description provided for @errorLoadingDetailsDesc.
  ///
  /// In nl, this message translates to:
  /// **'Kon details van de locatie niet laden.'**
  String get errorLoadingDetailsDesc;

  /// No description provided for @notNow.
  ///
  /// In nl, this message translates to:
  /// **'Niet nu'**
  String get notNow;

  /// No description provided for @squads.
  ///
  /// In nl, this message translates to:
  /// **'Squads'**
  String get squads;

  /// No description provided for @cities.
  ///
  /// In nl, this message translates to:
  /// **'Steden'**
  String get cities;

  /// No description provided for @searchNicknamePlaceholder.
  ///
  /// In nl, this message translates to:
  /// **'Typ een bijnaam...'**
  String get searchNicknamePlaceholder;

  /// No description provided for @achievements.
  ///
  /// In nl, this message translates to:
  /// **'Prestaties'**
  String get achievements;

  /// No description provided for @activity.
  ///
  /// In nl, this message translates to:
  /// **'Activiteit'**
  String get activity;

  /// No description provided for @circles.
  ///
  /// In nl, this message translates to:
  /// **'Kringen'**
  String get circles;

  /// No description provided for @followers.
  ///
  /// In nl, this message translates to:
  /// **'Volgers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In nl, this message translates to:
  /// **'Volgend'**
  String get following;

  /// No description provided for @bioPlaceholder.
  ///
  /// In nl, this message translates to:
  /// **'Ik hou van techno en lange nachten...'**
  String get bioPlaceholder;

  /// No description provided for @daySun.
  ///
  /// In nl, this message translates to:
  /// **'Zo'**
  String get daySun;

  /// No description provided for @dayMon.
  ///
  /// In nl, this message translates to:
  /// **'Ma'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In nl, this message translates to:
  /// **'Di'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In nl, this message translates to:
  /// **'Wo'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In nl, this message translates to:
  /// **'Do'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In nl, this message translates to:
  /// **'Vr'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In nl, this message translates to:
  /// **'Za'**
  String get daySat;

  /// No description provided for @bio.
  ///
  /// In nl, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @firstName.
  ///
  /// In nl, this message translates to:
  /// **'Voornaam'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In nl, this message translates to:
  /// **'Achternaam'**
  String get lastName;

  /// No description provided for @noFollowers.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen volgers.'**
  String get noFollowers;

  /// No description provided for @followingNone.
  ///
  /// In nl, this message translates to:
  /// **'Je volgt nog niemand.'**
  String get followingNone;

  /// No description provided for @remove.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderen'**
  String get remove;

  /// No description provided for @userNotFound.
  ///
  /// In nl, this message translates to:
  /// **'Gebruiker niet gevonden'**
  String get userNotFound;

  /// No description provided for @guestWelcomeMessage.
  ///
  /// In nl, this message translates to:
  /// **'Hoi {nickname},\nMaak een account aan of log in om je Vibe Level, Badges en Verenigingen te ontgrendelen.'**
  String guestWelcomeMessage(String nickname);

  /// No description provided for @badgeVault.
  ///
  /// In nl, this message translates to:
  /// **'Badge Vault'**
  String get badgeVault;

  /// No description provided for @badgeVaultSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Bekijk je verzamelde badges'**
  String get badgeVaultSubtitle;

  /// No description provided for @leaderboard.
  ///
  /// In nl, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @leaderboardSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Bekijk de ranglijsten'**
  String get leaderboardSubtitle;

  /// No description provided for @challenges.
  ///
  /// In nl, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @challengesSubtitle.
  ///
  /// In nl, this message translates to:
  /// **'Voltooi missies met je squad'**
  String get challengesSubtitle;

  /// No description provided for @noRecentActivity.
  ///
  /// In nl, this message translates to:
  /// **'Geen recente activiteit gevonden.'**
  String get noRecentActivity;

  /// No description provided for @checkedIn.
  ///
  /// In nl, this message translates to:
  /// **'Ingecheckt'**
  String get checkedIn;

  /// No description provided for @vibeUpdatedTitle.
  ///
  /// In nl, this message translates to:
  /// **'Vibe geüpdatet'**
  String get vibeUpdatedTitle;

  /// No description provided for @noAssociations.
  ///
  /// In nl, this message translates to:
  /// **'Je bent nog geen lid van een vereniging.'**
  String get noAssociations;

  /// No description provided for @errorConnection.
  ///
  /// In nl, this message translates to:
  /// **'Controleer je verbinding en probeer het opnieuw.'**
  String get errorConnection;

  /// No description provided for @errorLoadingPlaceDetails.
  ///
  /// In nl, this message translates to:
  /// **'Kon details van locatie niet laden.'**
  String get errorLoadingPlaceDetails;

  /// No description provided for @filtersTitle.
  ///
  /// In nl, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @apply.
  ///
  /// In nl, this message translates to:
  /// **'Toepassen'**
  String get apply;

  /// No description provided for @setTargetTime.
  ///
  /// In nl, this message translates to:
  /// **'Stel doeltijd in'**
  String get setTargetTime;

  /// No description provided for @placePin.
  ///
  /// In nl, this message translates to:
  /// **'Plaats Pin'**
  String get placePin;

  /// No description provided for @imIn.
  ///
  /// In nl, this message translates to:
  /// **'Ik doe mee'**
  String get imIn;

  /// No description provided for @notifStepTitle.
  ///
  /// In nl, this message translates to:
  /// **'Mis niks van de actie'**
  String get notifStepTitle;

  /// No description provided for @notifStepDesc.
  ///
  /// In nl, this message translates to:
  /// **'Zet je pushmeldingen aan om direct te weten wanneer je squad actief is of als er een flash promo is.'**
  String get notifStepDesc;

  /// No description provided for @notifStepEnable.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen aanzetten'**
  String get notifStepEnable;

  /// No description provided for @notifStepLater.
  ///
  /// In nl, this message translates to:
  /// **'Misschien later'**
  String get notifStepLater;

  /// No description provided for @registerBioTitle.
  ///
  /// In nl, this message translates to:
  /// **'Wat is jouw Bio?'**
  String get registerBioTitle;

  /// No description provided for @registerBioDesc.
  ///
  /// In nl, this message translates to:
  /// **'Vertel iets over jezelf (Optioneel)'**
  String get registerBioDesc;

  /// No description provided for @registerBioHint.
  ///
  /// In nl, this message translates to:
  /// **'Ik hou van techno en lange nachten...'**
  String get registerBioHint;

  /// No description provided for @registerWelcome.
  ///
  /// In nl, this message translates to:
  /// **'Welkom, {firstName}!'**
  String registerWelcome(String firstName);

  /// No description provided for @registerProfileCreated.
  ///
  /// In nl, this message translates to:
  /// **'Je profiel is aangemaakt'**
  String get registerProfileCreated;

  /// No description provided for @errorRegistrationFailed.
  ///
  /// In nl, this message translates to:
  /// **'Registratie mislukt'**
  String get errorRegistrationFailed;

  /// No description provided for @badgeVaultTitle.
  ///
  /// In nl, this message translates to:
  /// **'Badge Vault'**
  String get badgeVaultTitle;

  /// No description provided for @quickStats.
  ///
  /// In nl, this message translates to:
  /// **'Snelle Statistieken'**
  String get quickStats;

  /// No description provided for @explorerBadges.
  ///
  /// In nl, this message translates to:
  /// **'Explorer Badges'**
  String get explorerBadges;

  /// No description provided for @socialBadges.
  ///
  /// In nl, this message translates to:
  /// **'Social Badges'**
  String get socialBadges;

  /// No description provided for @safetyBadges.
  ///
  /// In nl, this message translates to:
  /// **'Safety Badges'**
  String get safetyBadges;

  /// No description provided for @leaderboardTitle.
  ///
  /// In nl, this message translates to:
  /// **'Ranglijst'**
  String get leaderboardTitle;

  /// No description provided for @yourSquad.
  ///
  /// In nl, this message translates to:
  /// **'Jouw Squad'**
  String get yourSquad;

  /// No description provided for @squadChallenges.
  ///
  /// In nl, this message translates to:
  /// **'Squad Uitdagingen'**
  String get squadChallenges;

  /// No description provided for @inProgress.
  ///
  /// In nl, this message translates to:
  /// **'In uitvoering'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In nl, this message translates to:
  /// **'Voltooid!'**
  String get completed;

  /// No description provided for @locationsCount.
  ///
  /// In nl, this message translates to:
  /// **'{current}/{required} locaties'**
  String locationsCount(int current, int required);

  /// No description provided for @settingsHaptics.
  ///
  /// In nl, this message translates to:
  /// **'Haptische Feedback'**
  String get settingsHaptics;

  /// No description provided for @settingsRateAppSoon.
  ///
  /// In nl, this message translates to:
  /// **'App Store link binnenkort beschikbaar'**
  String get settingsRateAppSoon;

  /// No description provided for @settingsVersion.
  ///
  /// In nl, this message translates to:
  /// **'Versie {version}'**
  String settingsVersion(String version);

  /// No description provided for @errorNoEmailApp.
  ///
  /// In nl, this message translates to:
  /// **'Geen e-mail app gevonden. Mail ons op info@clubapp.be'**
  String get errorNoEmailApp;

  /// No description provided for @errorEmailGeneric.
  ///
  /// In nl, this message translates to:
  /// **'Kon e-mail app niet openen'**
  String get errorEmailGeneric;

  /// No description provided for @errorDeleteAccount.
  ///
  /// In nl, this message translates to:
  /// **'Er ging iets mis bij het verwijderen'**
  String get errorDeleteAccount;

  /// No description provided for @pushNotificationsTitle.
  ///
  /// In nl, this message translates to:
  /// **'Pushmeldingen'**
  String get pushNotificationsTitle;

  /// No description provided for @enableNotifications.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen inschakelen'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsDesc.
  ///
  /// In nl, this message translates to:
  /// **'Ontvang meldingen van Club App'**
  String get enableNotificationsDesc;

  /// No description provided for @notificationTypes.
  ///
  /// In nl, this message translates to:
  /// **'Type meldingen'**
  String get notificationTypes;

  /// No description provided for @flashPromos.
  ///
  /// In nl, this message translates to:
  /// **'Flash Promos'**
  String get flashPromos;

  /// No description provided for @flashPromosDesc.
  ///
  /// In nl, this message translates to:
  /// **'Krijg meldingen over last-minute deals'**
  String get flashPromosDesc;

  /// No description provided for @squadAlerts.
  ///
  /// In nl, this message translates to:
  /// **'Squad Alerts'**
  String get squadAlerts;

  /// No description provided for @squadAlertsDesc.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen wanneer je weg bent van je Squad'**
  String get squadAlertsDesc;

  /// No description provided for @chatMessages.
  ///
  /// In nl, this message translates to:
  /// **'Chatberichten'**
  String get chatMessages;

  /// No description provided for @chatMessagesDesc.
  ///
  /// In nl, this message translates to:
  /// **'Nieuwe berichten van je Squad'**
  String get chatMessagesDesc;

  /// No description provided for @newFeatures.
  ///
  /// In nl, this message translates to:
  /// **'Nieuwe functies'**
  String get newFeatures;

  /// No description provided for @newFeaturesDesc.
  ///
  /// In nl, this message translates to:
  /// **'Updates over nieuwe app-functies'**
  String get newFeaturesDesc;

  /// No description provided for @quietHours.
  ///
  /// In nl, this message translates to:
  /// **'Stille uren'**
  String get quietHours;

  /// No description provided for @dontDisturb.
  ///
  /// In nl, this message translates to:
  /// **'Niet storen'**
  String get dontDisturb;

  /// No description provided for @dontDisturbDesc.
  ///
  /// In nl, this message translates to:
  /// **'Demp meldingen tijdens ingestelde uren'**
  String get dontDisturbDesc;

  /// No description provided for @from.
  ///
  /// In nl, this message translates to:
  /// **'Van'**
  String get from;

  /// No description provided for @to.
  ///
  /// In nl, this message translates to:
  /// **'Tot'**
  String get to;

  /// No description provided for @assocActiveMember.
  ///
  /// In nl, this message translates to:
  /// **'Actief lid'**
  String get assocActiveMember;

  /// No description provided for @assocPendingRequest.
  ///
  /// In nl, this message translates to:
  /// **'Aanvraag in behandeling'**
  String get assocPendingRequest;

  /// No description provided for @assocAboutTitle.
  ///
  /// In nl, this message translates to:
  /// **'Over de vereniging'**
  String get assocAboutTitle;

  /// No description provided for @assocNoDescription.
  ///
  /// In nl, this message translates to:
  /// **'Deze vereniging heeft nog geen beschrijving toegevoegd.'**
  String get assocNoDescription;

  /// No description provided for @assocCancelRequest.
  ///
  /// In nl, this message translates to:
  /// **'Aanvraag annuleren'**
  String get assocCancelRequest;

  /// No description provided for @assocRequestMembership.
  ///
  /// In nl, this message translates to:
  /// **'Lidmaatschap verzoeken'**
  String get assocRequestMembership;

  /// No description provided for @allBadges.
  ///
  /// In nl, this message translates to:
  /// **'Alle Badges'**
  String get allBadges;

  /// No description provided for @badgesUnlockedCount.
  ///
  /// In nl, this message translates to:
  /// **'{count} van de {total} badges ontgrendeld'**
  String badgesUnlockedCount(int count, int total);

  /// No description provided for @vpToNextLevel.
  ///
  /// In nl, this message translates to:
  /// **'{count} VP naar volgend level'**
  String vpToNextLevel(int count);

  /// No description provided for @weekendStreakCount.
  ///
  /// In nl, this message translates to:
  /// **'{count, plural, =1{{count} Weekend} other{{count} Weekends}}'**
  String weekendStreakCount(int count);

  /// No description provided for @levelNewbie.
  ///
  /// In nl, this message translates to:
  /// **'Nieuweling'**
  String get levelNewbie;

  /// No description provided for @levelClubHopper.
  ///
  /// In nl, this message translates to:
  /// **'Club Hopper'**
  String get levelClubHopper;

  /// No description provided for @levelVibeMaster.
  ///
  /// In nl, this message translates to:
  /// **'Vibe Master'**
  String get levelVibeMaster;

  /// No description provided for @levelLegend.
  ///
  /// In nl, this message translates to:
  /// **'Legende'**
  String get levelLegend;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In nl, this message translates to:
  /// **'Locatietoegang'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In nl, this message translates to:
  /// **'Locatie is nodig om Squad Mode te gebruiken en de vibe van clubs in de buurt te checken. Je locatie wordt alleen gedeeld als je in een actieve squad zit en stopt automatisch om 06:00 uur.'**
  String get locationPermissionMessage;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In nl, this message translates to:
  /// **'Meldingen'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In nl, this message translates to:
  /// **'Schakel meldingen in om Flash Promos en Squad-waarschuwingen te ontvangen wanneer je niet op je telefoon kijkt.'**
  String get notificationPermissionMessage;

  /// No description provided for @club.
  ///
  /// In nl, this message translates to:
  /// **'Club'**
  String get club;

  /// No description provided for @event.
  ///
  /// In nl, this message translates to:
  /// **'Event'**
  String get event;
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
