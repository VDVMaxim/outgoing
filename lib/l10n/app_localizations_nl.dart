// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Club App';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Kaart';

  @override
  String get navActivities => 'Acties';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingStart => 'Starten';

  @override
  String get onboarding1Title => 'Ontdek je stad';

  @override
  String get onboarding1Desc =>
      'Bekijk in één oogopslag welke buurten bruisen, vind je favoriete clubs en plan je nachtleven met onze interactieve kaart.';

  @override
  String get onboarding2Title => 'Squad Mode';

  @override
  String get onboarding2Desc =>
      'Raak nooit meer je vrienden kwijt. Creëer een Squad via een pincode en deel tijdelijk jullie locatie op de kaart. Stopt automatisch om 6 uur \'s ochtends.';

  @override
  String get onboarding3Title => 'Comfort & Veiligheid';

  @override
  String get onboarding3Desc =>
      'Zoek specifiek naar clubs met gratis water, veilige chillzones en bekijk real-time \'Vibes\' die door mede-bezoekers bevestigd zijn.';

  @override
  String get onboarding4Title => 'Jouw Stem Telt';

  @override
  String get onboarding4Desc =>
      'Deze app is wekelijks in ontwikkeling vóór en dóór de student. Bugs of feedback stuur je in 1 klik in de instellingen door.';

  @override
  String get onboardingNicknameTitle => 'Wat is je naam?';

  @override
  String get onboardingNicknameDesc =>
      'Kies een nickname om je squad mates te laten weten wie je bent.';

  @override
  String get onboardingNicknameHint => 'Je nickname...';

  @override
  String get onboardingNicknameGenerate => 'Genereer random nickname';

  @override
  String get onboardingLocationTitle => 'Ontdek de Vibe';

  @override
  String get onboardingLocationDesc =>
      'We gebruiken je locatie om live te tonen welke clubs dichtbij zijn en wat de actuele sfeer is. Geen account nodig, blijf anoniem.';

  @override
  String get onboardingLocationAllow => 'Locatie Toestaan';

  @override
  String get onboardingLocationSkip => 'Misschien Later';

  @override
  String get onboardingSetupTitle => 'Setup';

  @override
  String get onboardingStartExploring => 'Ontdekken';

  @override
  String get onboardingAllSet => 'Je bent klaar!';

  @override
  String get onboardingExploreNearby =>
      'Laten we ontdekken wat er in de buurt gebeurt.';

  @override
  String get onboardingSettingUp => 'Account wordt ingesteld...';

  @override
  String get onboardingNicknameRequired => 'Voer een nickname in';

  @override
  String get onboardingNicknameMinLength =>
      'Nickname moet minimaal 3 tekens zijn';

  @override
  String get homeHighlightsTitle => 'Top 3 Highlights';

  @override
  String get homeTrendingTitle => 'Trending: Meest Populair';

  @override
  String get homeAlertTitle => 'Let op: Controleactie';

  @override
  String get homeAlertDesc =>
      'Er is momenteel veel drukte en politiecontrole gemeld aan het begin van de Overpoortstraat. Wees voorzichtig.';

  @override
  String get activitiesTitle => 'Activiteiten & Acties';

  @override
  String get activitiesSearchHint => 'Zoek vereniging, club, thema...';

  @override
  String get activitiesEmpty => 'Geen acties gevonden.';

  @override
  String get activitiesDetails => 'Details';

  @override
  String get activitiesUnknownCrowd => 'Onbekend';

  @override
  String get mapSearchHint => 'Zoek op wijk of club...';

  @override
  String get mapFood => 'Eten';

  @override
  String get mapFilters => 'Filters';

  @override
  String get mapClearAll => 'Alles wissen';

  @override
  String get mapCategories => 'Categorieën';

  @override
  String mapOpenClubs(int count) {
    return '$count clubs open';
  }

  @override
  String get mapOnline => 'Online';

  @override
  String get mapLastSeen => 'Laatst gezien';

  @override
  String get mapJustNow => 'zojuist';

  @override
  String get mapMinuteAgo => '1 minuut geleden';

  @override
  String mapMinutesAgo(int count) {
    return '$count minuten geleden';
  }

  @override
  String get mapHourAgo => '1 uur geleden';

  @override
  String mapHoursAgo(int count) {
    return '$count uur geleden';
  }

  @override
  String get clubVibeTitle => 'Vibe';

  @override
  String clubVibeConfirmed(int minutes) {
    return '$minutes min geleden bevestigd';
  }

  @override
  String get clubVibeUpdate => 'Update';

  @override
  String get clubRoute => 'Route';

  @override
  String get clubTaxi => 'Taxi';

  @override
  String get clubUnknownCrowd => 'Onbekend';

  @override
  String get toastLocationUnknown => 'Locatie onbekend, kan Vibe niet checken.';

  @override
  String toastTooFarAway(int distance) {
    return 'Je bent ${distance}m verwijderd. Je moet binnen 50m zijn.';
  }

  @override
  String get squadTitle => 'Squad Mode';

  @override
  String get squadSubtitle => 'Verlies elkaar niet uit het oog.';

  @override
  String get squadDesc =>
      'Zien waar je maten zijn op de kaart tot 06:00. Danana verdwijnt de Squad automatisch voor ieders privacy.';

  @override
  String get squadCreate => 'Nieuwe Squad Maken';

  @override
  String get squadJoin => 'Deelnemen';

  @override
  String get squadOr => 'OF DEELNEMEN';

  @override
  String get squadPinHint => 'Voer 6-cijferige PIN in';

  @override
  String get squadPinLabel => 'JULLIE SQUAD PIN';

  @override
  String squadMembers(int count) {
    return 'Actieve Leden ($count/10)';
  }

  @override
  String get squadYou => 'Jij (Anoniem)';

  @override
  String get squadSharingOn => 'Locatie delen staat aan';

  @override
  String get squadSharingLive => 'Live locatie wordt gedeeld';

  @override
  String get squadLeave => 'Squad Verlaten';

  @override
  String get squadWrongPin => 'Pin is onjuist of sessie bestaat niet.';

  @override
  String get squadLocationRequired => 'Locatie Nodig';

  @override
  String get squadLocationDesc =>
      'Squad mode heeft je locatie nodig om je positie te delen met squad leden. Je locatie wordt alleen gedeeld tijdens een actieve squad.';

  @override
  String get squadEnableLocation => 'Locatie Inschakelen';

  @override
  String get squadNicknameRequired => 'Nickname Nodig';

  @override
  String get squadNicknameRequiredDesc =>
      'Je moet een nickname instellen voordat je bij een squad kan. Ga naar Instellingen om je nickname in te stellen.';

  @override
  String get squadError => 'Fout';

  @override
  String get squadPinCopied => 'PIN gekopieerd';

  @override
  String get squadCopyPin => 'Kopieer PIN';

  @override
  String get squadScanQR => 'Scan QR code';

  @override
  String get squadOffline => 'Offline';

  @override
  String get squadOnline => 'Online';

  @override
  String get squadFailedToJoin => 'Kon niet deelnemen aan squad';

  @override
  String get squadFailedToCreate => 'Kon geen squad maken';

  @override
  String get squadNicknameFirst =>
      'Stel eerst een nickname in bij Instellingen';

  @override
  String get squadLocationRequiredToast =>
      'Locatie toestemming is nodig voor squad modus';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSquadProfile => 'Squad Profiel';

  @override
  String get settingsNickname => 'Nickname';

  @override
  String get settingsNoNickname => 'Geen nickname ingesteld';

  @override
  String get settingsNicknameHint => 'Stel een nickname in voor squad modus';

  @override
  String get settingsChangeNickname => 'Nickname Wijzigen';

  @override
  String settingsNicknameSet(String nickname) {
    return 'Nickname ingesteld op: $nickname';
  }

  @override
  String get settingsSetNickname => 'Nickname Instellen';

  @override
  String get settingsSave => 'Opslaan';

  @override
  String get settingsDisplay => 'Weergave';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsNotifications => 'Meldingen & Privacy';

  @override
  String get settingsPushNotifs => 'Push Notificaties';

  @override
  String get settingsPushNotifsSub => 'Voor Flash Promo\'s en Squad alerts';

  @override
  String get settingsAnonSession => 'Anonieme Sessie';

  @override
  String get settingsAnonSessionSub => 'Device ID gelinkt';

  @override
  String get settingsDestroySession => 'Sessie Vernietigen';

  @override
  String get settingsDestroySessionTitle => 'Sessie wissen?';

  @override
  String get settingsDestroySessionDesc =>
      'Dit wist je anonieme sessie. Je bent momenteel nergens permanent ingelogd.';

  @override
  String get settingsCancel => 'Annuleren';

  @override
  String get settingsDelete => 'Account verwijderen';

  @override
  String get settingsAbout => 'Over Club App';

  @override
  String get settingsFeedback => 'Bugs & Feedback Rapporteren';

  @override
  String get settingsFeedbackSub => 'Help de app beter te maken';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLanguageNl => 'Nederlands';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get splashSetupVerifying => 'Services en data controleren…';

  @override
  String get splashSetupReady => 'Alles in orde';

  @override
  String get splashSetupErrorTitle => 'Setup kon niet worden gecontroleerd';

  @override
  String get splashSetupErrorTimeout =>
      'Time-out. Controleer je netwerk en probeer opnieuw.';

  @override
  String get splashSetupErrorGeneric =>
      'Er ging iets mis. Controleer je verbinding en probeer opnieuw.';

  @override
  String get splashRetry => 'Opnieuw proberen';

  @override
  String get optionScreenTitle => 'Hoe wil je beginnen?';

  @override
  String get optionScreenAnonymous => 'Anoniem blijven';

  @override
  String get optionScreenAnonymousDesc =>
      'Je kunt later altijd nog een account aanmaken';

  @override
  String get optionScreenCreateAccount => 'Account aanmaken';

  @override
  String get optionScreenCreateAccountDesc =>
      'Bewaar je profiel en sync across apparaten';

  @override
  String get optionScreenLogin => 'Inloggen';

  @override
  String get optionScreenLoginDesc =>
      'Heb je al een account? Log in om je voortgang te sync.';

  @override
  String get accountFormTitle => 'Account aanmaken';

  @override
  String get accountFormFirstName => 'Voornaam';

  @override
  String get accountFormLastName => 'Achternaam';

  @override
  String get accountFormEmail => 'Email';

  @override
  String get accountFormBirthday => 'Geboortedatum';

  @override
  String get accountFormBirthdayRequired => 'Selecteer je geboortedatum';

  @override
  String get accountFormBirthdaySelect => 'Selecteer datum';

  @override
  String get accountFormPersonalInfo => 'Over jou';

  @override
  String get accountFormPersonalInfoDesc => 'Vertel ons wie je bent';

  @override
  String get accountFormEmailDesc =>
      'Je email wordt alleen gebruikt om in te loggen';

  @override
  String get accountFormNickname => 'Nickname voor Squad';

  @override
  String get accountFormNicknameHint =>
      'Je nickname is alleen zichtbaar voor squad-leden';

  @override
  String get accountFormPassword => 'Wachtwoord';

  @override
  String get accountFormPasswordHint => 'Minimaal 6 tekens';

  @override
  String get accountFormConfirmPassword => 'Bevestig wachtwoord';

  @override
  String get accountFormPasswordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get accountFormNext => 'Volgende';

  @override
  String get accountFormCreate => 'Account Aanmaken';

  @override
  String get accountFormAlreadyHave => 'Heb je al een account?';

  @override
  String get accountFormLogin => 'Inloggen';

  @override
  String get accountFormRequired => 'Dit veld is verplicht';

  @override
  String get accountFormInvalidEmail => 'Ongeldig email adres';

  @override
  String get accountFormEmailTaken => 'Dit email adres is al in gebruik';

  @override
  String get accountFormMinPassword => 'Wachtwoord moet minimaal 6 tekens zijn';

  @override
  String get creatingTitle => 'Account aanmaken...';

  @override
  String get creatingError => 'Er ging iets mis. Probeer opnieuw.';

  @override
  String accountSuccessTitle(String name) {
    return 'Welkom, $name!';
  }

  @override
  String get accountSuccessSubtitle => 'Je profiel is aangemaakt';

  @override
  String get accountSuccessContinue => 'Doorgaan';

  @override
  String get loginTitle => 'Inloggen';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Wachtwoord';

  @override
  String get loginButton => 'Inloggen';

  @override
  String get loginInvalidCredentials => 'Email of wachtwoord is incorrect';

  @override
  String get loginNoAccount => 'Nog geen account?';

  @override
  String get loginRegister => 'Registreren';

  @override
  String get settingsAnonymous => 'Anoniem';

  @override
  String get settingsLogin => 'Inloggen';

  @override
  String get settingsLogout => 'Uitloggen';

  @override
  String get settingsLogoutConfirm =>
      'Weet je het zeker? Je nickname blijft bewaard.';

  @override
  String get settingsDeleteAccount => 'Account verwijderen';

  @override
  String get settingsDeleteAccountDesc =>
      'Alle data wordt permanent verwijderd';

  @override
  String get settingsDeleteAccountConfirm => 'Account verwijderen?';

  @override
  String get settingsDeleteAccountWarning =>
      'Al je data wordt permanent verwijderd. Deze actie kan niet ongedaan worden.';

  @override
  String get settingsOk => 'OK';

  @override
  String get settingsYes => 'Ja';

  @override
  String get settingsNo => 'Nee';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsReportBug => 'Een bug melden';

  @override
  String get settingsRateApp => 'App beoordelen';

  @override
  String get settingsShareApp => 'App delen';

  @override
  String get settingsPreferences => 'Voorkeuren';

  @override
  String get settingsTerms => 'Algemene Voorwaarden';

  @override
  String get settingsPrivacy => 'Privacy Policy';
}
