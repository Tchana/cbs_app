import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'notifications': 'Notifications',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'english': 'English',
      'french': 'French',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'account': 'Account',
      'general': 'General',
      'privacy': 'Privacy',
      'about': 'About',
      'version': 'Version',
      'app_name': 'Center for Biblical Studies',
      'notifications_enabled': 'Enable notifications',
      'sound_enabled': 'Enable sound',
      'vibration_enabled': 'Enable vibration',
      'select_language': 'Select Language',
      'select_theme': 'Select Theme',
      // Auth
      'login': 'Login',
      'register': 'Register',
      'create_your_account': 'Create your account',
      'sign_in_to_your_account': 'Sign in to your Account',
      'sign_in_to_your_n_account': 'Sign in to your\nAccount',
      'do_not_have_account': "Don't have an account?",
      'i_have_account': 'I already have an account',
      'forgot_password': 'Forgot Password?',
      'or_login_with': 'or Login with',
      'google': 'Google',
      'facebook': 'Facebook',
      'logged_in': 'Logged In!',
      'registration_complete': 'Registration Complete!',
      'check_email_to_confirm':
          'Please check your email to confirm your account, then sign in.',
      'name': 'Name',
      'please_enter_name': 'Please, Enter Name',
      'invalid_name': 'Invalid Name',
      'email': 'Email',
      'please_enter_email': 'Please, Enter Email Address',
      'invalid_email': 'Invalid Email Address',
      'password': 'Password',
      'please_enter_password': 'Please, Enter Password',
      'invalid_password': 'Invalid Password',
      'confirm_password': 'Confirm Password',
      'please_re_enter_password': 'Please, Re-Enter Password',
      'password_not_matched': 'Password not matched!',
      // Main nav
      'nav_home': 'Home',
      'nav_library': 'Library',
      'nav_courses': 'Courses',
      'nav_forum': 'Forum',
      // Library
      'library': 'Library',
      'tab_all': 'All',
      'tab_bibles': 'Bibles',
      'tab_books': 'Books',
      'tab_dictionaries': 'Dictionaries',
      'no_items_found': 'No items found',
      'section_bibles': 'Bibles',
      // Splash / onboarding
      'splash_next': 'Next',
      'splash_start': 'Get Started',
      'onboarding_1': 'Many courses, books and Bibles at your fingertips',
      'onboarding_2': 'Study from anywhere, anytime, at your convenience',
      'onboarding_3': 'Gain knowledge on different doctrinal traditions',
      // Forum
      'forum': 'Forum',
      'create_group': 'Create a group',
      'group_name': 'Group name',
      'description': 'Description',
      'private_group': 'Private group',
      'create': 'Create',
      'groups': 'Groups',
      'no_groups': 'No groups yet',
      'create_first': 'Create the first group',
      'group_name_required': 'Please enter a name for the group',
      'group_created_success': 'Group created successfully',
      'group_create_error': 'Error creating group',
      'no_message': 'No message',
      'private': 'Private',
      'unnamed_group': 'Unnamed',
      'loading': 'Loading...',
      // Dashboard / Home
      'dashboard_greeting': 'Hello',
      'dashboard_subtitle': 'Continue your studies',
      'dashboard_welcome': 'Welcome to CBS!',
      'dashboard_welcome_subtitle': 'Introductory video about CBS',
      'search_hint': 'Search',
      'teachers_section': 'Teachers',
      'courses_section': 'Courses',
      'see_all': 'See all',
      'contact': 'Contact',
      // Additional UI / Settings
      'settings_subtitle': 'Manage language, theme, and preferences',
      'language_description': 'Choose your preferred language',
      'theme_description': 'Select how the app appears',
      'app_preferences': 'App preferences',
      'notifications_description': 'Receive updates and alerts',
      'sound_description': 'Play sounds for app events',
      'vibration_description': 'Vibrate for app interactions',
      'account_actions': 'Account actions',
      'logout_description': 'Sign out from this device',
      'saved': 'Saved',
      'tab_in_progress': 'In progress',
      'tab_completed': 'Completed',
      'pdf_viewer': 'PDF Viewer',
      'error_prefix': 'Error',
      'skip': 'Skip',
      'send': 'Send',
      'refresh': 'Refresh',
      'chat_message_hint': 'Type your message...',
      'be_first_message': 'Be the first to send a message',
      'online': 'online',
      'unknown_user': 'Unknown user',
      'yesterday': 'Yesterday',
      'course_default': 'Course',
      'description_label': 'Description',
      'teacher_label': 'Teacher',
      'lessons_label': 'Lessons',
      'no_lessons_yet': 'No lessons yet',
      'lesson_label': 'Lesson',
      'open_pdf': 'Open PDF',
      'not_available': 'Not available',
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'verse_of_the_day': 'Verse of the day',
      'verse_unavailable': 'Unable to load verse of the day.',
      'pdf_load_error': 'Unable to open this PDF file.',
      'retry': 'Retry',
    },
    'fr': {
      'settings': 'Paramètres',
      'language': 'Langue',
      'theme': 'Thème',
      'notifications': 'Notifications',
      'sound': 'Son',
      'vibration': 'Vibration',
      'logout': 'Déconnexion',
      'logout_confirmation': 'Êtes-vous sûr de vouloir vous déconnecter?',
      'cancel': 'Annuler',
      'confirm': 'Confirmer',
      'english': 'Anglais',
      'french': 'Français',
      'light_theme': 'Clair',
      'dark_theme': 'Sombre',
      'system_theme': 'Système',
      'account': 'Compte',
      'general': 'Général',
      'privacy': 'Confidentialité',
      'about': 'À propos',
      'version': 'Version',
      'app_name': 'Centre d\'Études Bibliques',
      'notifications_enabled': 'Activer les notifications',
      'sound_enabled': 'Activer le son',
      'vibration_enabled': 'Activer la vibration',
      'select_language': 'Sélectionner la langue',
      'select_theme': 'Sélectionner le thème',
      // Auth
      'login': 'Connexion',
      'register': 'S\'inscrire',
      'create_your_account': 'Créer votre compte',
      'sign_in_to_your_account': 'Connectez-vous à votre compte',
      'sign_in_to_your_n_account': 'Connectez-vous à votre\nCompte',
      'do_not_have_account': 'Vous n\'avez pas de compte ?',
      'i_have_account': 'J\'ai déjà un compte',
      'forgot_password': 'Mot de passe oublié ?',
      'or_login_with': 'ou connexion avec',
      'google': 'Google',
      'facebook': 'Facebook',
      'logged_in': 'Connecté !',
      'registration_complete': 'Inscription terminée !',
      'check_email_to_confirm':
          'Veuillez vérifier votre e-mail pour confirmer votre compte, puis connectez-vous.',
      'name': 'Nom',
      'please_enter_name': 'Veuillez entrer le nom',
      'invalid_name': 'Nom invalide',
      'email': 'E-mail',
      'please_enter_email': 'Veuillez entrer l\'adresse e-mail',
      'invalid_email': 'Adresse e-mail invalide',
      'password': 'Mot de passe',
      'please_enter_password': 'Veuillez entrer le mot de passe',
      'invalid_password': 'Mot de passe invalide',
      'confirm_password': 'Confirmer le mot de passe',
      'please_re_enter_password': 'Veuillez ressaisir le mot de passe',
      'password_not_matched': 'Les mots de passe ne correspondent pas',
      // Main nav
      'nav_home': 'Accueil',
      'nav_library': 'Bibliothèque',
      'nav_courses': 'Cours',
      'nav_forum': 'Forum',
      // Library
      'library': 'Bibliothèque',
      'tab_all': 'Tout',
      'tab_bibles': 'Bibles',
      'tab_books': 'Livres',
      'tab_dictionaries': 'Dictionnaires',
      'no_items_found': 'Aucun élément',
      'section_bibles': 'Bibles',
      // Splash / onboarding
      'splash_next': 'Suivant',
      'splash_start': 'Commencer',
      'onboarding_1': 'De nombreux cours, livres et Bibles à votre disposition',
      'onboarding_2': 'Étudiez de n\'importe où, à n\'importe quelle heure',
      'onboarding_3': 'Acquérez la connaissance sur les courants doctrinaux',
      // Forum
      'forum': 'Forum',
      'create_group': 'Créer un groupe',
      'group_name': 'Nom du groupe',
      'description': 'Description',
      'private_group': 'Groupe privé',
      'create': 'Créer',
      'groups': 'Groupes',
      'no_groups': 'Aucun groupe',
      'create_first': 'Créez le premier groupe',
      'group_name_required': 'Veuillez entrer un nom pour le groupe',
      'group_created_success': 'Groupe créé avec succès',
      'group_create_error': 'Erreur lors de la création du groupe',
      'no_message': 'Aucun message',
      'private': 'Privé',
      'unnamed_group': 'Sans nom',
      'loading': 'Chargement...',
      // Dashboard / Home
      'dashboard_greeting': 'Bonjour',
      'dashboard_subtitle': 'Poursuivez vos études',
      'dashboard_welcome': 'Bienvenue sur CBS !',
      'dashboard_welcome_subtitle': 'Vidéo introductive sur le CBS',
      'search_hint': 'Rechercher',
      'teachers_section': 'Enseignants',
      'courses_section': 'Cours',
      'see_all': 'Voir tout',
      'contact': 'Contacter',
      // Additional UI / Settings
      'settings_subtitle': 'Gérez la langue, le thème et les préférences',
      'language_description': 'Choisissez votre langue préférée',
      'theme_description': 'Sélectionnez l\'apparence de l\'application',
      'app_preferences': 'Préférences de l\'application',
      'notifications_description': 'Recevez les mises à jour et les alertes',
      'sound_description': 'Jouer les sons des événements de l\'application',
      'vibration_description': 'Vibrer lors des interactions',
      'account_actions': 'Actions du compte',
      'logout_description': 'Se déconnecter de cet appareil',
      'saved': 'Enregistré',
      'tab_in_progress': 'En cours',
      'tab_completed': 'Terminé',
      'pdf_viewer': 'Lecteur PDF',
      'error_prefix': 'Erreur',
      'skip': 'Passer',
      'send': 'Envoyer',
      'refresh': 'Actualiser',
      'chat_message_hint': 'Tapez votre message...',
      'be_first_message': 'Soyez le premier à envoyer un message',
      'online': 'en ligne',
      'unknown_user': 'Utilisateur inconnu',
      'yesterday': 'Hier',
      'course_default': 'Cours',
      'description_label': 'Description',
      'teacher_label': 'Professeur',
      'lessons_label': 'Leçons',
      'no_lessons_yet': 'Aucune leçon pour le moment',
      'lesson_label': 'Leçon',
      'open_pdf': 'Ouvrir le PDF',
      'not_available': 'Non disponible',
      'good_morning': 'Bonjour',
      'good_afternoon': 'Bon apres-midi',
      'good_evening': 'Bonsoir',
      'verse_of_the_day': 'Verset du jour',
      'verse_unavailable': 'Impossible de charger le verset du jour.',
      'pdf_load_error': 'Impossible d\'ouvrir ce fichier PDF.',
      'retry': 'Reessayer',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Getters for common translations
  String get settings => translate('settings');
  String get language => translate('language');
  String get theme => translate('theme');
  String get notifications => translate('notifications');
  String get sound => translate('sound');
  String get vibration => translate('vibration');
  String get logout => translate('logout');
  String get logoutConfirmation => translate('logout_confirmation');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get english => translate('english');
  String get french => translate('french');
  String get lightTheme => translate('light_theme');
  String get darkTheme => translate('dark_theme');
  String get systemTheme => translate('system_theme');
  String get account => translate('account');
  String get general => translate('general');
  String get privacy => translate('privacy');
  String get about => translate('about');
  String get version => translate('version');
  String get appName => translate('app_name');
  String get notificationsEnabled => translate('notifications_enabled');
  String get soundEnabled => translate('sound_enabled');
  String get vibrationEnabled => translate('vibration_enabled');
  String get selectLanguage => translate('select_language');
  String get selectTheme => translate('select_theme');
  // Auth
  String get login => translate('login');
  String get register => translate('register');
  String get createYourAccount => translate('create_your_account');
  String get signInToYourAccount => translate('sign_in_to_your_account');
  String get signInToYourNAccount => translate('sign_in_to_your_n_account');
  String get doNotHaveAccount => translate('do_not_have_account');
  String get iHaveAccount => translate('i_have_account');
  String get forgotPassword => translate('forgot_password');
  String get orLoginWith => translate('or_login_with');
  String get google => translate('google');
  String get facebook => translate('facebook');
  String get loggedIn => translate('logged_in');
  String get registrationComplete => translate('registration_complete');
  String get checkEmailToConfirm => translate('check_email_to_confirm');
  String get name => translate('name');
  String get pleaseEnterName => translate('please_enter_name');
  String get invalidName => translate('invalid_name');
  String get email => translate('email');
  String get pleaseEnterEmail => translate('please_enter_email');
  String get invalidEmail => translate('invalid_email');
  String get password => translate('password');
  String get pleaseEnterPassword => translate('please_enter_password');
  String get invalidPassword => translate('invalid_password');
  String get confirmPassword => translate('confirm_password');
  String get pleaseReEnterPassword => translate('please_re_enter_password');
  String get passwordNotMatched => translate('password_not_matched');
  // Nav
  String get navHome => translate('nav_home');
  String get navLibrary => translate('nav_library');
  String get navCourses => translate('nav_courses');
  String get navForum => translate('nav_forum');
  // Library
  String get library => translate('library');
  String get tabAll => translate('tab_all');
  String get tabBibles => translate('tab_bibles');
  String get tabBooks => translate('tab_books');
  String get tabDictionaries => translate('tab_dictionaries');
  String get noItemsFound => translate('no_items_found');
  String get sectionBibles => translate('section_bibles');
  // Splash
  String get splashNext => translate('splash_next');
  String get splashStart => translate('splash_start');
  String get onboarding1 => translate('onboarding_1');
  String get onboarding2 => translate('onboarding_2');
  String get onboarding3 => translate('onboarding_3');
  // Forum
  String get forum => translate('forum');
  String get createGroup => translate('create_group');
  String get groupName => translate('group_name');
  String get description => translate('description');
  String get privateGroup => translate('private_group');
  String get create => translate('create');
  String get groups => translate('groups');
  String get noGroups => translate('no_groups');
  String get createFirst => translate('create_first');
  String get groupNameRequired => translate('group_name_required');
  String get groupCreatedSuccess => translate('group_created_success');
  String get groupCreateError => translate('group_create_error');
  String get noMessage => translate('no_message');
  String get private => translate('private');
  String get unnamedGroup => translate('unnamed_group');
  String get loading => translate('loading');
  // Dashboard
  String get dashboardGreeting => translate('dashboard_greeting');
  String get dashboardSubtitle => translate('dashboard_subtitle');
  String get dashboardWelcome => translate('dashboard_welcome');
  String get dashboardWelcomeSubtitle =>
      translate('dashboard_welcome_subtitle');
  String get searchHint => translate('search_hint');
  String get teachersSection => translate('teachers_section');
  String get coursesSection => translate('courses_section');
  String get seeAll => translate('see_all');
  String get contact => translate('contact');
  String get settingsSubtitle => translate('settings_subtitle');
  String get languageDescription => translate('language_description');
  String get themeDescription => translate('theme_description');
  String get appPreferences => translate('app_preferences');
  String get notificationsDescription => translate('notifications_description');
  String get soundDescription => translate('sound_description');
  String get vibrationDescription => translate('vibration_description');
  String get accountActions => translate('account_actions');
  String get logoutDescription => translate('logout_description');
  String get saved => translate('saved');
  String get tabInProgress => translate('tab_in_progress');
  String get tabCompleted => translate('tab_completed');
  String get pdfViewer => translate('pdf_viewer');
  String get errorPrefix => translate('error_prefix');
  String get skip => translate('skip');
  String get send => translate('send');
  String get refresh => translate('refresh');
  String get chatMessageHint => translate('chat_message_hint');
  String get beFirstMessage => translate('be_first_message');
  String get online => translate('online');
  String get unknownUser => translate('unknown_user');
  String get yesterday => translate('yesterday');
  String get courseDefault => translate('course_default');
  String get descriptionLabel => translate('description_label');
  String get teacherLabel => translate('teacher_label');
  String get lessonsLabel => translate('lessons_label');
  String get noLessonsYet => translate('no_lessons_yet');
  String get lessonLabel => translate('lesson_label');
  String get openPdf => translate('open_pdf');
  String get notAvailable => translate('not_available');
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get verseOfTheDay => translate('verse_of_the_day');
  String get verseUnavailable => translate('verse_unavailable');
  String get pdfLoadError => translate('pdf_load_error');
  String get retry => translate('retry');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
