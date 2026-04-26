// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Club App';

  @override
  String get navMap => 'Carte';

  @override
  String get navActivities => 'Sorties';

  @override
  String get navSettings => 'Réglages';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Démarrer';

  @override
  String get onboarding1Title => 'Découvrez votre ville';

  @override
  String get onboarding1Desc =>
      'Voyez d\'un coup d\'œil quels quartiers sont animés, trouvez vos clubs préférés et planifiez votre nuit avec notre carte interactive.';

  @override
  String get onboarding2Title => 'Mode Squad';

  @override
  String get onboarding2Desc =>
      'Ne perdez plus jamais vos amis. Créez un Squad avec un code PIN et partagez temporairement votre position sur la carte. S\'arrête automatiquement à 6h du matin.';

  @override
  String get onboarding3Title => 'Confort & Sécurité';

  @override
  String get onboarding3Desc =>
      'Recherchez spécifiquement des clubs avec de l\'eau gratuite, des zones chill sécurisées et consultez les \'Vibes\' en temps réel confirmées par les visiteurs.';

  @override
  String get onboarding4Title => 'Votre avis compte';

  @override
  String get onboarding4Desc =>
      'Cette app est développée chaque semaine pour et par les étudiants. Envoyez des bugs ou des commentaires en 1 clic depuis les réglages.';

  @override
  String get onboardingNicknameTitle => 'Quel est votre nom ?';

  @override
  String get onboardingNicknameDesc =>
      'Choisissez un pseudo pour que vos copains de squad sachent qui vous êtes.';

  @override
  String get onboardingNicknameHint => 'Votre pseudo...';

  @override
  String get onboardingNicknameGenerate => 'Générer un pseudo aléatoire';

  @override
  String get onboardingLocationTitle => 'Découvrez l\'Ambiance';

  @override
  String get onboardingLocationDesc =>
      'Nous utilisons votre position pour montrer en direct quels clubs sont à proximité et quelle est l\'ambiance actuelle. Pas de compte nécessaire, restez anonyme.';

  @override
  String get onboardingLocationAllow => 'Autoriser la Position';

  @override
  String get onboardingLocationSkip => 'Peut-être Plus Tard';

  @override
  String get onboardingSetupTitle => 'Configuration';

  @override
  String get onboardingStartExploring => 'Commencer à Explorer';

  @override
  String get onboardingAllSet => 'Vous êtes prêt !';

  @override
  String get onboardingExploreNearby =>
      'Explorons ce qui se passe à proximité.';

  @override
  String get onboardingSettingUp => 'Configuration de votre compte...';

  @override
  String get onboardingNicknameRequired => 'Veuillez entrer un pseudo';

  @override
  String get onboardingNicknameMinLength =>
      'Le pseudo doit comporter au moins 3 caractères';

  @override
  String get activitiesTitle => 'Sorties & Promotions';

  @override
  String get activitiesSearchHint =>
      'Rechercher par association, club, thème...';

  @override
  String get activitiesEmpty => 'Aucune sortie trouvée.';

  @override
  String get activitiesDetails => 'Détails';

  @override
  String get activitiesUnknownCrowd => 'Inconnu';

  @override
  String get mapSearchHint => 'Rechercher par quartier ou club...';

  @override
  String get mapFood => 'Manger';

  @override
  String get mapFilters => 'Filtres';

  @override
  String get mapClearAll => 'Tout effacer';

  @override
  String get mapCategories => 'Catégories';

  @override
  String mapOpenClubs(int count) {
    return '$count clubs ouverts';
  }

  @override
  String get mapOnline => 'En ligne';

  @override
  String get mapLastSeen => 'Vu pour la dernière fois';

  @override
  String get mapJustNow => 'à l\'instant';

  @override
  String get mapMinuteAgo => 'il y a 1 minute';

  @override
  String mapMinutesAgo(int count) {
    return 'il y a $count minutes';
  }

  @override
  String get mapHourAgo => 'il y a 1 heure';

  @override
  String mapHoursAgo(int count) {
    return 'il y a $count heures';
  }

  @override
  String get clubVibeTitle => 'Ambiance';

  @override
  String clubVibeConfirmed(int minutes) {
    return 'confirmé il y a $minutes min';
  }

  @override
  String get clubVibeUpdate => 'Mettre à jour';

  @override
  String get clubRoute => 'Itinéraire';

  @override
  String get clubTaxi => 'Taxi';

  @override
  String get clubUnknownCrowd => 'Inconnu';

  @override
  String get toastLocationUnknown =>
      'Position inconnue, impossible de vérifier l\'ambiance.';

  @override
  String toastTooFarAway(int distance) {
    return 'Vous êtes à ${distance}m. Vous devez être à moins de 50m.';
  }

  @override
  String get squadTitle => 'Mode Squad';

  @override
  String get squadSubtitle => 'Ne perdez pas vos amis de vue.';

  @override
  String get squadDesc =>
      'Voyez où sont vos amis sur la carte jusqu\'à 06:00. Ensuite, le Squad disparaît automatiquement pour la confidentialité de tous.';

  @override
  String get squadCreate => 'Créer un nouveau Squad';

  @override
  String get squadJoin => 'Rejoindre';

  @override
  String get squadOr => 'OU REJOINDRE';

  @override
  String get squadPinHint => 'Entrez un PIN à 6 chiffres';

  @override
  String get squadPinLabel => 'VOTRE PIN SQUAD';

  @override
  String squadMembers(int count) {
    return 'Membres actifs ($count/10)';
  }

  @override
  String get squadYou => 'Vous (Anonyme)';

  @override
  String get squadSharingOn => 'Partage de localisation activé';

  @override
  String get squadSharingLive => 'La position est partagée en direct';

  @override
  String get squadLeave => 'Quitter le Squad';

  @override
  String get squadWrongPin =>
      'Le PIN est incorrect ou la session n\'existe pas.';

  @override
  String get squadLocationRequired => 'Position Requise';

  @override
  String get squadLocationDesc =>
      'Le mode Squad a besoin de votre position pour partager avec les membres. Votre position n\'est partagée que pendant un squad actif.';

  @override
  String get squadEnableLocation => 'Activer la Position';

  @override
  String get squadNicknameRequired => 'Pseudo Requis';

  @override
  String get squadNicknameRequiredDesc =>
      'Vous devez définir un pseudo avant de rejoindre un squad. Allez dans Réglages pour définir votre pseudo.';

  @override
  String get squadError => 'Erreur';

  @override
  String get squadPinCopied => 'PIN copié';

  @override
  String get squadCopyPin => 'Copier le PIN';

  @override
  String get squadScanQR => 'Scanner le code QR';

  @override
  String get squadOffline => 'Hors ligne';

  @override
  String get squadOnline => 'En ligne';

  @override
  String get squadFailedToJoin => 'Impossible de rejoindre le squad';

  @override
  String get squadFailedToCreate => 'Impossible de créer le squad';

  @override
  String get squadNicknameFirst =>
      'Veuillez d\'abord définir un pseudo dans Réglages';

  @override
  String get squadLocationRequiredToast =>
      'La permission de localisation est requise pour le mode squad';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsSquadProfile => 'Profil Squad';

  @override
  String get settingsNickname => 'Pseudo';

  @override
  String get settingsNoNickname => 'Aucun pseudo défini';

  @override
  String get settingsNicknameHint => 'Définissez un pseudo pour le mode squad';

  @override
  String get settingsChangeNickname => 'Changer le Pseudo';

  @override
  String settingsNicknameSet(String nickname) {
    return 'Pseudo défini sur : $nickname';
  }

  @override
  String get settingsSetNickname => 'Définir le Pseudo';

  @override
  String get settingsSave => 'Enregistrer';

  @override
  String get settingsDisplay => 'Affichage';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsNotifications => 'Notifications & Confidentialité';

  @override
  String get settingsPushNotifs => 'Notifications push';

  @override
  String get settingsPushNotifsSub => 'Pour les Flash Promos et alertes Squad';

  @override
  String get settingsAnonSession => 'Session anonyme';

  @override
  String get settingsAnonSessionSub => 'ID d\'appareil lié';

  @override
  String get settingsDestroySession => 'Détruire la session';

  @override
  String get settingsDestroySessionTitle => 'Effacer la session ?';

  @override
  String get settingsDestroySessionDesc =>
      'Cela effacera votre session anonyme. Vous n\'êtes connecté nulle part de façon permanente.';

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsDelete => 'Supprimer le compte';

  @override
  String get settingsAbout => 'À propos de Club App';

  @override
  String get settingsFeedback => 'Signaler des bugs & commentaires';

  @override
  String get settingsFeedbackSub => 'Aidez à améliorer l\'application';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageNl => 'Nederlands';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get splashSetupVerifying =>
      'Vérification des services et des données…';

  @override
  String get splashSetupReady => 'Tout est prêt';

  @override
  String get splashSetupErrorTitle => 'Impossible de vérifier la configuration';

  @override
  String get splashSetupErrorTimeout =>
      'Délai dépassé. Vérifiez le réseau et réessayez.';

  @override
  String get splashSetupErrorGeneric =>
      'Une erreur s\'est produite. Vérifiez la connexion et réessayez.';

  @override
  String get splashRetry => 'Réessayer';

  @override
  String get optionScreenTitle => 'Comment voulez-vous commencer ?';

  @override
  String get optionScreenAnonymous => 'Rester anonyme';

  @override
  String get optionScreenAnonymousDesc =>
      'Vous pouvez toujours créer un compte plus tard';

  @override
  String get optionScreenCreateAccount => 'Créer un compte';

  @override
  String get optionScreenCreateAccountDesc =>
      'Enregistrez votre profil et synchronisez sur tous les appareils';

  @override
  String get optionScreenLogin => 'Se connecter';

  @override
  String get optionScreenLoginDesc =>
      'Vous avez déjà un compte ? Connectez-vous pour synchroniser votre progression';

  @override
  String get accountFormTitle => 'Créer un compte';

  @override
  String get accountFormFirstName => 'Prénom';

  @override
  String get accountFormLastName => 'Nom';

  @override
  String get accountFormEmail => 'Email';

  @override
  String get accountFormBirthday => 'Date de naissance';

  @override
  String get accountFormBirthdayRequired =>
      'Veuillez sélectionner votre date de naissance';

  @override
  String get accountFormBirthdaySelect => 'Sélectionner la date';

  @override
  String get accountFormPersonalInfo => 'À propos de vous';

  @override
  String get accountFormPersonalInfoDesc => 'Parlez-nous de vous';

  @override
  String get accountFormEmailDesc =>
      'Votre email est uniquement utilisé pour vous connecter';

  @override
  String get accountFormNickname => 'Pseudo pour Squad';

  @override
  String get accountFormNicknameHint =>
      'Votre pseudo est uniquement visible pour les membres du squad';

  @override
  String get accountFormPassword => 'Mot de passe';

  @override
  String get accountFormPasswordHint => 'Au moins 6 caractères';

  @override
  String get accountFormConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get accountFormPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get accountFormNext => 'Suivant';

  @override
  String get accountFormCreate => 'Créer un Compte';

  @override
  String get accountFormAlreadyHave => 'Vous avez déjà un compte ?';

  @override
  String get accountFormLogin => 'Se connecter';

  @override
  String get accountFormRequired => 'Ce champ est obligatoire';

  @override
  String get accountFormInvalidEmail => 'Adresse email invalide';

  @override
  String get accountFormEmailTaken => 'Cette adresse email est déjà utilisée';

  @override
  String get accountFormMinPassword =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get creatingTitle => 'Création du compte...';

  @override
  String get creatingError =>
      'Quelque chose s\'est mal passé. Veuillez réessayer.';

  @override
  String accountSuccessTitle(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get accountSuccessSubtitle => 'Votre profil a été créé';

  @override
  String get accountSuccessContinue => 'Continuer';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginInvalidCredentials => 'Email ou mot de passe incorrect';

  @override
  String get loginNoAccount => 'Pas encore de compte ?';

  @override
  String get loginRegister => 'S\'inscrire';

  @override
  String get settingsAnonymous => 'Anonyme';

  @override
  String get settingsLogin => 'Se connecter';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get settingsLogoutConfirm =>
      'Êtes-vous sûr ? Votre pseudo sera sauvegardé.';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsDeleteAccountDesc =>
      'Toutes les données seront définitivement supprimées';

  @override
  String get settingsDeleteAccountConfirm => 'Supprimer le compte ?';

  @override
  String get settingsDeleteAccountWarning =>
      'Toutes vos données seront définitivement supprimées. Cette action ne peut pas être annulée.';

  @override
  String get settingsOk => 'OK';

  @override
  String get settingsYes => 'Oui';

  @override
  String get settingsNo => 'Non';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsHelpSupport => 'Aide & Support';

  @override
  String get settingsReportBug => 'Signaler un bug';

  @override
  String get settingsRateApp => 'Noter l\'app';

  @override
  String get settingsShareApp => 'Partager l\'app';

  @override
  String get settingsPreferences => 'Préférences';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';
}
