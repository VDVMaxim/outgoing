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
  String get navDiscover => 'Découvrir';

  @override
  String get navProfile => 'Profil';

  @override
  String get navEvents => 'Actions';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get feedViewEvents => 'Voir les événements';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get onboarding1Title => 'Découvre ta ville';

  @override
  String get onboarding1Desc =>
      'Vois en un coup d\'œil quels quartiers bougent, trouve tes clubs préférés et planifie ta soirée grâce à notre carte interactive.';

  @override
  String get onboarding2Title => 'Mode Squad';

  @override
  String get onboarding2Desc =>
      'Ne perds plus jamais tes amis. Crée une Squad avec un code PIN et partagez temporairement votre position sur la carte. S\'arrête automatiquement à 6h du matin.';

  @override
  String get onboarding3Title => 'Confort & Sécurité';

  @override
  String get onboarding3Desc =>
      'Trouve des clubs avec de l\'eau gratuite, des zones chill sécurisées et consulte les \"Vibes\" en temps réel confirmées par d\'autres visiteurs.';

  @override
  String get onboarding4Title => 'Ta voix compte';

  @override
  String get onboarding4Desc =>
      'Cette app évolue chaque semaine par et pour les étudiants. Envoie facilement tes bugs ou feedbacks depuis les paramètres.';

  @override
  String get onboardingNicknameTitle => 'Comment t\'appelles-tu ?';

  @override
  String get onboardingNicknameDesc =>
      'Choisis un pseudo pour que les membres de ta squad sachent qui tu es.';

  @override
  String get onboardingNicknameHint => 'Ton pseudo...';

  @override
  String get onboardingNicknameGenerate => 'Générer un pseudo aléatoire';

  @override
  String get onboardingLocationTitle => 'Découvre la Vibe';

  @override
  String get onboardingLocationDesc =>
      'Nous utilisons ta localisation pour montrer les clubs proches et l\'ambiance actuelle. Aucun compte requis, reste anonyme.';

  @override
  String get onboardingLocationAllow => 'Autoriser la localisation';

  @override
  String get onboardingLocationSkip => 'Peut-être plus tard';

  @override
  String get onboardingSetupTitle => 'Configuration';

  @override
  String get onboardingStartExploring => 'Découvrir';

  @override
  String get onboardingAllSet => 'Tout est prêt !';

  @override
  String get onboardingExploreNearby =>
      'Voyons ce qu\'il se passe autour de toi.';

  @override
  String get onboardingSettingUp => 'Configuration du compte...';

  @override
  String get onboardingNicknameRequired => 'Entre un pseudo';

  @override
  String get onboardingNicknameMinLength =>
      'Le pseudo doit contenir au moins 3 caractères';

  @override
  String get eventsTitle => 'Activités & Promotions';

  @override
  String get eventsSearchHint => 'Chercher association, club, thème...';

  @override
  String get eventsEmpty => 'Aucune promotion trouvée.';

  @override
  String get eventsDetails => 'Détails';

  @override
  String get eventsUnknownCrowd => 'Inconnu';

  @override
  String get mapSearchHint => 'Chercher un quartier ou un club...';

  @override
  String get mapFood => 'Nourriture';

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
  String get clubVibeTitle => 'Vibe';

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
      'Position inconnue, impossible de vérifier la Vibe.';

  @override
  String toastTooFarAway(int distance) {
    return 'Tu es à ${distance}m. Tu dois être à moins de 50m.';
  }

  @override
  String get squadTitle => 'Mode Squad';

  @override
  String get squadSubtitle => 'Ne perdez plus vos amis de vue.';

  @override
  String get squadDesc =>
      'Voyez où se trouvent vos potes sur la carte jusqu\'à 06:00. Ensuite, la Squad disparaît automatiquement pour préserver la vie privée.';

  @override
  String get squadCreate => 'Créer une nouvelle Squad';

  @override
  String get squadJoin => 'Rejoindre';

  @override
  String get squadOr => 'OU REJOINDRE';

  @override
  String get squadPinHint => 'Entrez un code PIN à 6 chiffres';

  @override
  String get squadPinLabel => 'CODE PIN DE VOTRE SQUAD';

  @override
  String squadMembers(int count) {
    return 'Membres actifs ($count/10)';
  }

  @override
  String get squadYou => 'Toi (Anonyme)';

  @override
  String get squadSharingOn => 'Partage de position activé';

  @override
  String get squadSharingLive => 'Position en direct partagée';

  @override
  String get squadLeave => 'Quitter la Squad';

  @override
  String get squadWrongPin =>
      'Le code PIN est incorrect ou la session n\'existe pas.';

  @override
  String get squadLocationRequired => 'Localisation requise';

  @override
  String get squadLocationDesc =>
      'Le mode Squad nécessite ta localisation pour partager ta position avec les membres de la squad. Elle n\'est partagée que pendant une squad active.';

  @override
  String get squadEnableLocation => 'Activer la localisation';

  @override
  String get squadNicknameRequired => 'Pseudo requis';

  @override
  String get squadNicknameRequiredDesc =>
      'Tu dois définir un pseudo avant de rejoindre une squad. Va dans Paramètres pour le configurer.';

  @override
  String get squadError => 'Erreur';

  @override
  String get squadPinCopied => 'PIN copié';

  @override
  String get squadCopyPin => 'Copier le PIN';

  @override
  String get squadScanQR => 'Scanner le QR code';

  @override
  String get squadOffline => 'Hors ligne';

  @override
  String get squadOnline => 'En ligne';

  @override
  String get squadFailedToJoin => 'Impossible de rejoindre la squad';

  @override
  String get squadFailedToCreate => 'Impossible de créer la squad';

  @override
  String get squadNicknameFirst => 'Définis d\'abord un pseudo dans Paramètres';

  @override
  String get squadLocationRequiredToast =>
      'L\'autorisation de localisation est nécessaire pour le mode squad';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsPreferences => 'Préférences';

  @override
  String get settingsHelpSupport => 'Aide & Support';

  @override
  String get settingsFeedback => 'Ton avis';

  @override
  String get settingsReportBug => 'Signaler un bug';

  @override
  String get settingsRateApp => 'Noter l\'application';

  @override
  String get settingsShareApp => 'Partager l\'application';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsTerms => 'Conditions générales';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsSquadProfile => 'Profil Squad';

  @override
  String get settingsNickname => 'Pseudo';

  @override
  String get settingsNoNickname => 'Aucun pseudo défini';

  @override
  String get settingsNicknameHint => 'Définis un pseudo pour le mode squad';

  @override
  String get settingsChangeNickname => 'Modifier le pseudo';

  @override
  String settingsNicknameSet(String nickname) {
    return 'Pseudo défini sur : $nickname';
  }

  @override
  String get settingsSetNickname => 'Définir un pseudo';

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
  String get settingsAnonSessionSub => 'Liée à l\'ID de l\'appareil';

  @override
  String get settingsDestroySession => 'Supprimer la session';

  @override
  String get settingsDestroySessionTitle => 'Supprimer la session ?';

  @override
  String get settingsDestroySessionDesc =>
      'Cela efface ta session anonyme. Tu n\'es connecté nulle part de façon permanente.';

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsDelete => 'Supprimer le compte';

  @override
  String get settingsFeedbackSub => 'Aide à améliorer l\'application';

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
      'Temps dépassé. Vérifie ton réseau et réessaie.';

  @override
  String get splashSetupErrorGeneric =>
      'Une erreur est survenue. Vérifie ta connexion et réessaie.';

  @override
  String get splashRetry => 'Réessayer';

  @override
  String get optionScreenTitle => 'Comment veux-tu commencer ?';

  @override
  String get optionScreenAnonymous => 'Rester anonyme';

  @override
  String get optionScreenAnonymousDesc =>
      'Tu pourras toujours créer un compte plus tard';

  @override
  String get optionScreenCreateAccount => 'Créer un compte';

  @override
  String get optionScreenCreateAccountDesc =>
      'Sauvegarde ton profil et synchronise entre appareils';

  @override
  String get optionScreenLogin => 'Se connecter';

  @override
  String get optionScreenLoginDesc =>
      'Tu as déjà un compte ? Connecte-toi pour synchroniser ta progression.';

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
  String get accountFormBirthdayRequired => 'Sélectionne ta date de naissance';

  @override
  String get accountFormBirthdaySelect => 'Sélectionner une date';

  @override
  String get accountFormPersonalInfo => 'À propos de toi';

  @override
  String get accountFormPersonalInfoDesc => 'Dis-nous qui tu es';

  @override
  String get accountFormEmailDesc =>
      'Ton email est uniquement utilisé pour te connecter';

  @override
  String get accountFormNickname => 'Pseudo pour Squad';

  @override
  String get accountFormNicknameHint =>
      'Ton pseudo est visible uniquement par les membres de ta squad';

  @override
  String get accountFormPassword => 'Mot de passe';

  @override
  String get accountFormPasswordHint => 'Minimum 6 caractères';

  @override
  String get accountFormConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get accountFormPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get accountFormNext => 'Suivant';

  @override
  String get accountFormCreate => 'Créer un compte';

  @override
  String get accountFormAlreadyHave => 'Tu as déjà un compte ?';

  @override
  String get accountFormLogin => 'Se connecter';

  @override
  String get accountFormRequired => 'Ce champ est requis';

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
  String get creatingError => 'Une erreur est survenue. Réessaie.';

  @override
  String accountSuccessTitle(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get accountSuccessSubtitle => 'Ton profil a été créé';

  @override
  String get accountSuccessContinue => 'Continuer';

  @override
  String get loginTitle => 'Connexion';

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
      'Es-tu sûr ? Ton pseudo restera sauvegardé.';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsDeleteAccountDesc =>
      'Toutes les données seront supprimées définitivement';

  @override
  String get settingsDeleteAccountConfirm => 'Supprimer le compte ?';

  @override
  String get settingsDeleteAccountWarning =>
      'Toutes tes données seront supprimées définitivement. Cette action est irréversible.';

  @override
  String get settingsOk => 'OK';

  @override
  String get settingsYes => 'Oui';

  @override
  String get settingsNo => 'Non';

  @override
  String get loginSubtitle => 'Connecte-toi pour continuer';

  @override
  String get registerFirstNameTitle => 'Quel est ton prénom ?';

  @override
  String get registerFirstNameDesc => 'Entre ton prénom pour commencer';

  @override
  String get registerLastNameTitle => 'Quel est ton nom ?';

  @override
  String get registerLastNameDesc => 'Entre ton nom pour continuer';

  @override
  String get registerBirthdayTitle => 'Quand es-tu né ?';

  @override
  String get registerBirthdayDesc =>
      'Nous en avons besoin pour vérifier ton âge';

  @override
  String get registerEmailTitle => 'Quelle est ton adresse email ?';

  @override
  String get registerEmailDesc => 'Nous t\'enverrons un lien de vérification';

  @override
  String get registerPasswordTitle => 'Crée un mot de passe';

  @override
  String get registerPasswordDesc =>
      'Assure-toi qu\'il contient au moins 6 caractères';

  @override
  String get errorFirstNameRequired => 'Le prénom est requis';

  @override
  String get errorLastNameRequired => 'Le nom est requis';

  @override
  String get errorEmailRequired => 'L\'adresse email est requise';

  @override
  String get errorInvalidEmail => 'Adresse email invalide';

  @override
  String get errorPasswordRequired => 'Le mot de passe est requis';

  @override
  String get errorPasswordLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get errorConfirmPasswordRequired => 'Confirme ton mot de passe';

  @override
  String get errorPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get errorNicknameRequired => 'Veuillez entrer un pseudonyme';

  @override
  String get errorNicknameLength =>
      'Le pseudo doit contenir au moins 3 caractères';

  @override
  String get errorEmailInUse => 'Cette adresse email est déjà utilisée';

  @override
  String get mapApply => 'Appliquer';

  @override
  String get mapSetTime => 'Définir l\'heure cible';

  @override
  String get mapCancel => 'Annuler';

  @override
  String get mapPlacePin => 'Placer une épingle';

  @override
  String get mapJoin => 'Je participe';

  @override
  String get vibeCheckTitle => 'Comment est la Vibe ?';

  @override
  String get vibeHot => '🔥 Chaud';

  @override
  String get vibeCold => '🧊 Froid';

  @override
  String get vibeCancel => 'Annuler';

  @override
  String get vibeUpdated => 'Vibe mise à jour ! +20 VP';

  @override
  String get placeOpeningHours => 'Heures d\'ouverture';

  @override
  String get placeNoOpeningHours => 'Aucune heure d\'ouverture connue';

  @override
  String get placeNoVibes => 'Pas encore de vibes ce soir';

  @override
  String get placeUpdate => 'Mettre à jour';

  @override
  String get placeRoute => 'Itinéraire vers le lieu';

  @override
  String get placeCheckIn => 'Check-in (+10 VP)';

  @override
  String get eventsFallback => 'Événement';

  @override
  String get eventsError => 'Une erreur est survenue';

  @override
  String get assocSearchTitle => 'Chercher des associations';

  @override
  String get assocSearchHint => 'Chercher par nom...';

  @override
  String get assocPending => 'En attente d\'approbation';

  @override
  String get assocActive => 'Membre actif';

  @override
  String get assocLeave => 'Quitter l\'association';

  @override
  String get assocCancel => 'Annuler';

  @override
  String get assocSendRequest => 'Envoyer une demande';

  @override
  String get pushTitle => 'Notifications push';

  @override
  String get pushEnable => 'Activer les notifications';

  @override
  String get pushReceive => 'Recevoir des notifications de Club App';

  @override
  String get pushPromos => 'Flash Promos';

  @override
  String get pushSquad => 'Alertes Squad';

  @override
  String get pushQuiet => 'Heures silencieuses';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get accountAssoc => 'Mes associations';

  @override
  String get eventHostedBy => 'Organisé par';

  @override
  String get eventStartsAt => 'Commence à';

  @override
  String get eventRoute => 'Itinéraire vers le lieu';

  @override
  String get eventCheckIn => 'Check-in (+10 VP)';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get editProfileRemovePhoto => 'Supprimer la photo';

  @override
  String get editProfileBioHint => 'Parle un peu de toi...';

  @override
  String get settingsAccountDetails => 'Informations du compte';

  @override
  String get editProfilePrivateDataDesc =>
      'Ces informations sont privées et ne sont utilisées que pour la communication.';

  @override
  String get guestTitle => 'Bienvenue en tant qu\'invité';

  @override
  String get guestSubtitle =>
      'Crée un compte ou connecte-toi pour vibrer avec ta squad, gagner des VP et personnaliser ton profil.';

  @override
  String get guestLogin => 'Se connecter';

  @override
  String get guestRegister => 'Créer un compte';

  @override
  String get ok => 'OK';

  @override
  String get errorCouldNotOpenLink => 'Impossible d\'ouvrir le lien';

  @override
  String get settingsAppStoreComingSoon => 'Lien App Store bientôt disponible';

  @override
  String get errorCouldNotOpenEmail =>
      'Impossible d\'ouvrir l\'application e-mail';

  @override
  String get profilePhotoUpdated => 'Photo de profil mise à jour';

  @override
  String get profilePhotoUploadError => 'Erreur lors du chargement de la photo';

  @override
  String get profilePhotoRemoved => 'Photo de profil supprimée';

  @override
  String get profilePhotoRemoveError =>
      'Erreur lors de la suppression de la photo';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get profileSaveError => 'Erreur lors de l\'enregistrement du profil';

  @override
  String get errorLoadingFollowers => 'Erreur lors du chargement des abonnés';

  @override
  String get errorLoadingFollowing =>
      'Erreur lors du chargement des abonnements';

  @override
  String get checkInSuccess => '+10 VP ! Check-in confirmé';

  @override
  String get error => 'Erreur';

  @override
  String get errorLoadingProfile => 'Erreur lors du chargement du profil';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String get follow => 'Suivre';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get searchAssociations => 'Rechercher des associations';

  @override
  String get errorLoadingPlaces => 'Erreur lors du chargement des lieux';

  @override
  String get errorLoadingPlacesDesc =>
      'Veuillez vérifier votre connexion et réessayer.';

  @override
  String get errorLoadingDetails => 'Erreur lors du chargement des détails';

  @override
  String get errorLoadingDetailsDesc =>
      'Impossible de charger les détails du lieu.';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get squads => 'Squads';

  @override
  String get cities => 'Villes';

  @override
  String get searchNicknamePlaceholder => 'Tapez un surnom...';

  @override
  String get achievements => 'Succès';

  @override
  String get activity => 'Activité';

  @override
  String get circles => 'Cercles';

  @override
  String get followers => 'Abonnés';

  @override
  String get following => 'Abonnements';

  @override
  String get bioPlaceholder => 'J\'aime la techno et les longues nuits...';

  @override
  String get daySun => 'Dim';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mer';

  @override
  String get dayThu => 'Jeu';

  @override
  String get dayFri => 'Ven';

  @override
  String get daySat => 'Sam';

  @override
  String get bio => 'Bio';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get noFollowers => 'Pas encore d\'abonnés.';

  @override
  String get followingNone => 'Vous ne suivez encore personne.';

  @override
  String get remove => 'Supprimer';

  @override
  String get userNotFound => 'Utilisateur non trouvé';

  @override
  String guestWelcomeMessage(String nickname) {
    return 'Salut $nickname,\nCrée un compte ou connecte-toi pour débloquer ton Vibe Level, tes Badges et tes Associations.';
  }

  @override
  String get badgeVault => 'Badge Vault';

  @override
  String get badgeVaultSubtitle => 'Voir tes badges collectés';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get leaderboardSubtitle => 'Voir les classements';

  @override
  String get challenges => 'Challenges';

  @override
  String get challengesSubtitle => 'Complète des missions avec ta squad';

  @override
  String get noRecentActivity => 'Aucune activité récente trouvée.';

  @override
  String get checkedIn => 'Check-in effectué';

  @override
  String get vibeUpdatedTitle => 'Vibe mise à jour';

  @override
  String get noAssociations =>
      'Tu n\'es membre d\'aucune association pour le moment.';

  @override
  String get errorConnection =>
      'Veuillez vérifier votre connexion et réessayer.';

  @override
  String get errorLoadingPlaceDetails =>
      'Impossible de charger les détails du lieu.';

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get apply => 'Appliquer';

  @override
  String get setTargetTime => 'Régler l\'heure cible';

  @override
  String get placePin => 'Placer une épingle';

  @override
  String get imIn => 'Je participe';

  @override
  String get notifStepTitle => 'Ne manquez rien de l\'action';

  @override
  String get notifStepDesc =>
      'Activez les notifications push pour savoir immédiatement quand votre squad est active ou s\'il y a une promo flash.';

  @override
  String get notifStepEnable => 'Activer les notifications';

  @override
  String get notifStepLater => 'Peut-être plus tard';

  @override
  String get registerBioTitle => 'Quelle est votre bio ?';

  @override
  String get registerBioDesc => 'Parlez-nous de vous (Optionnel)';

  @override
  String get registerBioHint => 'J\'adore la techno et les longues nuits...';

  @override
  String registerWelcome(String firstName) {
    return 'Bienvenue, $firstName !';
  }

  @override
  String get registerProfileCreated => 'Votre profil a été créé';

  @override
  String get errorRegistrationFailed => 'Échec de l\'inscription';

  @override
  String get badgeVaultTitle => 'Badge Vault';

  @override
  String get quickStats => 'Stats Rapides';

  @override
  String get explorerBadges => 'Badges Explorateur';

  @override
  String get socialBadges => 'Badges Sociaux';

  @override
  String get safetyBadges => 'Badges de Sécurité';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get yourSquad => 'Votre Squad';

  @override
  String get squadChallenges => 'Défis de Squad';

  @override
  String get inProgress => 'En cours';

  @override
  String get completed => 'Terminé !';

  @override
  String locationsCount(int current, int required) {
    return '$current/$required lieux';
  }

  @override
  String get settingsHaptics => 'Retour haptique';

  @override
  String get settingsRateAppSoon => 'Lien vers l\'App Store disponible bientôt';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get errorNoEmailApp =>
      'Aucune application de messagerie trouvée. Contactez-nous à info@clubapp.be';

  @override
  String get errorEmailGeneric =>
      'Impossible d\'ouvrir l\'application de messagerie';

  @override
  String get errorDeleteAccount =>
      'Une erreur est survenue lors de la suppression';

  @override
  String get pushNotificationsTitle => 'Notifications Push';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get enableNotificationsDesc =>
      'Recevoir des notifications de Club App';

  @override
  String get notificationTypes => 'Types de notifications';

  @override
  String get flashPromos => 'Promos Flash';

  @override
  String get flashPromosDesc => 'Soyez informé des offres de dernière minute';

  @override
  String get squadAlerts => 'Alertes de Squad';

  @override
  String get squadAlertsDesc =>
      'Notifications quand vous êtes loin de votre Squad';

  @override
  String get chatMessages => 'Messages de Chat';

  @override
  String get chatMessagesDesc => 'Nouveaux messages de votre Squad';

  @override
  String get newFeatures => 'Nouvelles fonctionnalités';

  @override
  String get newFeaturesDesc =>
      'Mises à jour sur les nouvelles fonctionnalités';

  @override
  String get quietHours => 'Heures calmes';

  @override
  String get dontDisturb => 'Ne pas déranger';

  @override
  String get dontDisturbDesc =>
      'Couper les notifications pendant les heures définies';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get assocActiveMember => 'Membre actif';

  @override
  String get assocPendingRequest => 'Demande en attente';

  @override
  String get assocAboutTitle => 'À propos de l\'association';

  @override
  String get assocNoDescription =>
      'Cette association n\'a pas encore ajouté de description.';

  @override
  String get assocCancelRequest => 'Annuler la demande';

  @override
  String get assocRequestMembership => 'Demander l\'adhésion';

  @override
  String get allBadges => 'Tous les badges';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$count sur $total badges débloqués';
  }

  @override
  String vpToNextLevel(int count) {
    return '$count VP vers le niveau suivant';
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
  String get levelNewbie => 'Novice';

  @override
  String get levelClubHopper => 'Club Hopper';

  @override
  String get levelVibeMaster => 'Vibe Master';

  @override
  String get levelLegend => 'Légende';

  @override
  String get locationPermissionTitle => 'Accès à la localisation';

  @override
  String get locationPermissionMessage =>
      'La localisation est nécessaire voor utiliser le Mode Squad et vérifier l\'ambiance des clubs à proximité. Votre position n\'est partagée que lorsque vous êtes dans een squad active et s\'arrête automatiquement à 6 heures du matin.';

  @override
  String get notificationPermissionTitle => 'Notifications';

  @override
  String get notificationPermissionMessage =>
      'Activez les notifications voor recevoir des Promos Flash et des alertes de Squad lorsque vous n\'êtes pas sur votre téléphone.';

  @override
  String get club => 'Club';

  @override
  String get event => 'Événement';
}
