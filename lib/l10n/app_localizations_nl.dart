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
  String get navMap => 'Kaart';

  @override
  String get navDiscover => 'Ontdekken';

  @override
  String get navProfile => 'Profiel';

  @override
  String get navEvents => 'Acties';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get feedViewEvents => 'Bekijk Events';

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
  String get eventsTitle => 'Activiteiten & Acties';

  @override
  String get eventsSearchHint => 'Zoek vereniging, club, thema...';

  @override
  String get eventsEmpty => 'Geen acties gevonden.';

  @override
  String get eventsDetails => 'Details';

  @override
  String get eventsUnknownCrowd => 'Onbekend';

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
      'Zien waar je maten zijn op de kaart tot 06:00. Daarna verdwijnt de Squad automatisch voor ieders privacy.';

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
  String get settingsAccount => 'Account';

  @override
  String get settingsPreferences => 'Voorkeuren';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsFeedback => 'Jouw mening';

  @override
  String get settingsReportBug => 'Een fout melden';

  @override
  String get settingsRateApp => 'Beoordeel de App';

  @override
  String get settingsShareApp => 'Deel de App';

  @override
  String get settingsAbout => 'Over de App';

  @override
  String get settingsTerms => 'Algemene Voorwaarden';

  @override
  String get settingsPrivacy => 'Privacybeleid';

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
  String get loginSubtitle => 'Log in om door te gaan';

  @override
  String get registerFirstNameTitle => 'Wat is je voornaam?';

  @override
  String get registerFirstNameDesc => 'Vul je voornaam in om te beginnen';

  @override
  String get registerLastNameTitle => 'Wat is je achternaam?';

  @override
  String get registerLastNameDesc => 'Vul je achternaam in om door te gaan';

  @override
  String get registerBirthdayTitle => 'Wanneer ben je geboren?';

  @override
  String get registerBirthdayDesc =>
      'We hebben dit nodig om je leeftijd te verifiëren';

  @override
  String get registerEmailTitle => 'Wat is je e-mailadres?';

  @override
  String get registerEmailDesc => 'We sturen je een verificatielink';

  @override
  String get registerPasswordTitle => 'Maak een wachtwoord';

  @override
  String get registerPasswordDesc => 'Zorg dat het minstens 6 tekens lang is';

  @override
  String get errorFirstNameRequired => 'Voornaam is verplicht';

  @override
  String get errorLastNameRequired => 'Achternaam is verplicht';

  @override
  String get errorEmailRequired => 'E-mailadres is verplicht';

  @override
  String get errorInvalidEmail => 'Ongeldig e-mailadres';

  @override
  String get errorPasswordRequired => 'Wachtwoord is verplicht';

  @override
  String get errorPasswordLength => 'Wachtwoord moet minstens 6 tekens zijn';

  @override
  String get errorConfirmPasswordRequired => 'Bevestig je wachtwoord';

  @override
  String get errorPasswordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get errorNicknameRequired => 'Vul a.u.b. een bijnaam in';

  @override
  String get errorNicknameLength => 'Nickname moet minstens 3 tekens zijn';

  @override
  String get errorEmailInUse => 'Dit e-mailadres is al in gebruik';

  @override
  String get mapApply => 'Toepassen';

  @override
  String get mapSetTime => 'Stel doeltijd in';

  @override
  String get mapCancel => 'Annuleren';

  @override
  String get mapPlacePin => 'Plaats Pin';

  @override
  String get mapJoin => 'Ik doe mee';

  @override
  String get vibeCheckTitle => 'Hoe is de Vibe?';

  @override
  String get vibeHot => '🔥 Heet';

  @override
  String get vibeCold => '🧊 Koud';

  @override
  String get vibeCancel => 'Annuleren';

  @override
  String get vibeUpdated => 'Vibe geüpdatet! +20 VP';

  @override
  String get placeOpeningHours => 'Openingsuren';

  @override
  String get placeNoOpeningHours => 'Geen openingsuren bekend';

  @override
  String get placeNoVibes => 'Nog geen vibes vanavond';

  @override
  String get placeUpdate => 'Update';

  @override
  String get placeRoute => 'Route naar locatie';

  @override
  String get placeCheckIn => 'Check In (+10 VP)';

  @override
  String get eventsFallback => 'Event';

  @override
  String get eventsError => 'Er is een fout opgetreden';

  @override
  String get assocSearchTitle => 'Verenigingen zoeken';

  @override
  String get assocSearchHint => 'Zoek op naam...';

  @override
  String get assocPending => 'In afwachting van goedkeuring';

  @override
  String get assocActive => 'Actief lid';

  @override
  String get assocLeave => 'Vereniging verlaten';

  @override
  String get assocCancel => 'Annuleren';

  @override
  String get assocSendRequest => 'Verzoek sturen';

  @override
  String get pushTitle => 'Push Notificaties';

  @override
  String get pushEnable => 'Zet Notificaties Aan';

  @override
  String get pushReceive => 'Ontvang meldingen van Club App';

  @override
  String get pushPromos => 'Flash Promos';

  @override
  String get pushSquad => 'Squad Alerts';

  @override
  String get pushQuiet => 'Stille Uren';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get accountAssoc => 'Mijn Verenigingen';

  @override
  String get eventHostedBy => 'Georganiseerd door';

  @override
  String get eventStartsAt => 'Begint om';

  @override
  String get eventRoute => 'Route naar locatie';

  @override
  String get eventCheckIn => 'Check In (+10 VP)';

  @override
  String get editProfileTitle => 'Profiel bewerken';

  @override
  String get editProfileRemovePhoto => 'Verwijder foto';

  @override
  String get editProfileBioHint => 'Vertel iets over jezelf...';

  @override
  String get settingsAccountDetails => 'Accountgegevens';

  @override
  String get guestTitle => 'Welkom als Gast';

  @override
  String get guestSubtitle =>
      'Maak een account aan of log in om samen met je squad te viben, VP te verdienen en je profiel aan te passen.';

  @override
  String get guestLogin => 'Inloggen';

  @override
  String get guestRegister => 'Account aanmaken';

  @override
  String get ok => 'OK';

  @override
  String get errorCouldNotOpenLink => 'Kon link niet openen';

  @override
  String get settingsAppStoreComingSoon => 'App store link komt binnenkort';

  @override
  String get errorCouldNotOpenEmail => 'Kon e-mail app niet openen';

  @override
  String get profilePhotoUpdated => 'Profielfoto geüpdatet';

  @override
  String get profilePhotoUploadError => 'Fout bij uploaden foto';

  @override
  String get profilePhotoRemoved => 'Profielfoto verwijderd';

  @override
  String get profilePhotoRemoveError => 'Fout bij verwijderen foto';

  @override
  String get profileSaved => 'Profiel opgeslagen';

  @override
  String get profileSaveError => 'Fout bij opslaan profiel';

  @override
  String get errorLoadingFollowers => 'Fout bij laden van volgers';

  @override
  String get errorLoadingFollowing => 'Fout bij laden van volgend';

  @override
  String get checkInSuccess => '+10 VP! Check-in bevestigd';

  @override
  String get error => 'Fout';

  @override
  String get errorLoadingProfile => 'Fout bij laden van profiel';

  @override
  String get unfollow => 'Ontvolgen';

  @override
  String get follow => 'Volgen';

  @override
  String get editProfile => 'Profiel bewerken';

  @override
  String get searchAssociations => 'Zoek Verenigingen';

  @override
  String get errorLoadingPlaces => 'Fout bij laden van locaties';

  @override
  String get errorLoadingPlacesDesc =>
      'Controleer je verbinding en probeer opnieuw.';

  @override
  String get errorLoadingDetails => 'Fout bij laden van details';

  @override
  String get errorLoadingDetailsDesc =>
      'Kon details van de locatie niet laden.';

  @override
  String get notNow => 'Niet nu';

  @override
  String get squads => 'Squads';

  @override
  String get cities => 'Steden';

  @override
  String get searchNicknamePlaceholder => 'Typ een bijnaam...';

  @override
  String get achievements => 'Prestaties';

  @override
  String get activity => 'Activiteit';

  @override
  String get circles => 'Kringen';

  @override
  String get followers => 'Volgers';

  @override
  String get following => 'Volgend';

  @override
  String get bioPlaceholder => 'Ik hou van techno en lange nachten...';

  @override
  String get daySun => 'Zo';

  @override
  String get dayMon => 'Ma';

  @override
  String get dayTue => 'Di';

  @override
  String get dayWed => 'Wo';

  @override
  String get dayThu => 'Do';

  @override
  String get dayFri => 'Vr';

  @override
  String get daySat => 'Za';

  @override
  String get bio => 'Bio';

  @override
  String get firstName => 'Voornaam';

  @override
  String get lastName => 'Achternaam';

  @override
  String get noFollowers => 'Nog geen volgers.';

  @override
  String get followingNone => 'Je volgt nog niemand.';

  @override
  String get remove => 'Verwijderen';

  @override
  String get userNotFound => 'Gebruiker niet gevonden';

  @override
  String guestWelcomeMessage(String nickname) {
    return 'Hoi $nickname,\nMaak een account aan of log in om je Vibe Level, Badges en Verenigingen te ontgrendelen.';
  }

  @override
  String get badgeVault => 'Badge Vault';

  @override
  String get badgeVaultSubtitle => 'Bekijk je verzamelde badges';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get leaderboardSubtitle => 'Bekijk de ranglijsten';

  @override
  String get challenges => 'Challenges';

  @override
  String get challengesSubtitle => 'Voltooi missies met je squad';

  @override
  String get noRecentActivity => 'Geen recente activiteit gevonden.';

  @override
  String get checkedIn => 'Ingecheckt';

  @override
  String get vibeUpdatedTitle => 'Vibe geüpdatet';

  @override
  String get noAssociations => 'Je bent nog geen lid van een vereniging.';

  @override
  String get errorConnection =>
      'Controleer je verbinding en probeer het opnieuw.';

  @override
  String get errorLoadingPlaceDetails => 'Kon details van locatie niet laden.';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get apply => 'Toepassen';

  @override
  String get setTargetTime => 'Stel doeltijd in';

  @override
  String get placePin => 'Plaats Pin';

  @override
  String get imIn => 'Ik doe mee';

  @override
  String get notifStepTitle => 'Mis niks van de actie';

  @override
  String get notifStepDesc =>
      'Zet je pushmeldingen aan om direct te weten wanneer je squad actief is of als er een flash promo is.';

  @override
  String get notifStepEnable => 'Meldingen aanzetten';

  @override
  String get notifStepLater => 'Misschien later';

  @override
  String get registerBioTitle => 'Wat is jouw Bio?';

  @override
  String get registerBioDesc => 'Vertel iets over jezelf (Optioneel)';

  @override
  String get registerBioHint => 'Ik hou van techno en lange nachten...';

  @override
  String registerWelcome(String firstName) {
    return 'Welkom, $firstName!';
  }

  @override
  String get registerProfileCreated => 'Je profiel is aangemaakt';

  @override
  String get errorRegistrationFailed => 'Registratie mislukt';

  @override
  String get badgeVaultTitle => 'Badge Vault';

  @override
  String get quickStats => 'Snelle Statistieken';

  @override
  String get explorerBadges => 'Explorer Badges';

  @override
  String get socialBadges => 'Social Badges';

  @override
  String get safetyBadges => 'Safety Badges';

  @override
  String get leaderboardTitle => 'Ranglijst';

  @override
  String get yourSquad => 'Jouw Squad';

  @override
  String get squadChallenges => 'Squad Uitdagingen';

  @override
  String get inProgress => 'In uitvoering';

  @override
  String get completed => 'Voltooid!';

  @override
  String locationsCount(int current, int required) {
    return '$current/$required locaties';
  }

  @override
  String get settingsHaptics => 'Haptische Feedback';

  @override
  String get settingsRateAppSoon => 'App Store link binnenkort beschikbaar';

  @override
  String settingsVersion(String version) {
    return 'Versie $version';
  }

  @override
  String get errorNoEmailApp =>
      'Geen e-mail app gevonden. Mail ons op info@clubapp.be';

  @override
  String get errorEmailGeneric => 'Kon e-mail app niet openen';

  @override
  String get errorDeleteAccount => 'Er ging iets mis bij het verwijderen';

  @override
  String get pushNotificationsTitle => 'Pushmeldingen';

  @override
  String get enableNotifications => 'Meldingen inschakelen';

  @override
  String get enableNotificationsDesc => 'Ontvang meldingen van Club App';

  @override
  String get notificationTypes => 'Type meldingen';

  @override
  String get flashPromos => 'Flash Promos';

  @override
  String get flashPromosDesc => 'Krijg meldingen over last-minute deals';

  @override
  String get squadAlerts => 'Squad Alerts';

  @override
  String get squadAlertsDesc => 'Meldingen wanneer je weg bent van je Squad';

  @override
  String get chatMessages => 'Chatberichten';

  @override
  String get chatMessagesDesc => 'Nieuwe berichten van je Squad';

  @override
  String get newFeatures => 'Nieuwe functies';

  @override
  String get newFeaturesDesc => 'Updates over nieuwe app-functies';

  @override
  String get quietHours => 'Stille uren';

  @override
  String get dontDisturb => 'Niet storen';

  @override
  String get dontDisturbDesc => 'Demp meldingen tijdens ingestelde uren';

  @override
  String get from => 'Van';

  @override
  String get to => 'Tot';

  @override
  String get assocActiveMember => 'Actief lid';

  @override
  String get assocPendingRequest => 'Aanvraag in behandeling';

  @override
  String get assocAboutTitle => 'Over de vereniging';

  @override
  String get assocNoDescription =>
      'Deze vereniging heeft nog geen beschrijving toegevoegd.';

  @override
  String get assocCancelRequest => 'Aanvraag annuleren';

  @override
  String get assocRequestMembership => 'Lidmaatschap verzoeken';

  @override
  String get allBadges => 'Alle Badges';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$count van de $total badges ontgrendeld';
  }

  @override
  String vpToNextLevel(int count) {
    return '$count VP naar volgend level';
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
  String get levelNewbie => 'Nieuweling';

  @override
  String get levelClubHopper => 'Club Hopper';

  @override
  String get levelVibeMaster => 'Vibe Master';

  @override
  String get levelLegend => 'Legende';

  @override
  String get locationPermissionTitle => 'Locatietoegang';

  @override
  String get locationPermissionMessage =>
      'Locatie is nodig om Squad Mode te gebruiken en de vibe van clubs in de buurt te checken. Je locatie wordt alleen gedeeld als je in een actieve squad zit en stopt automatisch om 06:00 uur.';

  @override
  String get notificationPermissionTitle => 'Meldingen';

  @override
  String get notificationPermissionMessage =>
      'Schakel meldingen in om Flash Promos en Squad-waarschuwingen te ontvangen wanneer je niet op je telefoon kijkt.';

  @override
  String get club => 'Club';

  @override
  String get event => 'Event';
}
