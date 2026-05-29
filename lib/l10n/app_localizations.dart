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
      'enrolled': 'Enrolled',
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
      'notifications_tooltip': 'Notifications',
      'outstanding_balance': 'You owe {amount} FCFA',
      'latest_announcement': 'Latest announcement',
      'announcements_empty_hint': 'New announcements will appear here.',
      'book': 'Book',
      'dash': '—',
      'teacher_whatsapp_unavailable':
          'This teacher does not have a WhatsApp number yet.',
      'today': 'Today',
      'group_uuid_missing': 'Group information is missing.',
      'time_yesterday_short': 'Yesterday',
      'days_ago': '{days}d ago',
      'chat_date_format': 'MMM d',
      'assignments_title': 'Assignments',
      'assignments_empty': 'No assignments found.',
      'lesson_prefix': 'Lesson: {lesson}',
      'due_prefix': 'Due: {date}',
      'view_assignments': 'View assignments',
      'enroll_to_access_assignments': 'Your subscription level does not include this course yet',
      'assignment_open_pdf': 'Open PDF',
      'assignment_mcq_points': 'MCQ points: {points}',
      'assignment_pdf_selected': 'Selected: {file}',
      'assignment_no_pdf_selected_optional': 'No PDF selected (optional)',
      'assignment_no_pdf_submitted': 'No PDF submitted.',
      'assignment_teacher_points': 'Teacher points: {points}',
      'assignment_feedback_prefix': 'Feedback: {feedback}',
      'assignment_waiting_review': 'Waiting for teacher review...',
      'assignment_mcq_score_total': 'MCQ score total: {points}',
      'assignment_final_score_total': 'Final score total: {points}',
      'assignment_submission_downgraded':
          'Your access is downgraded. You can view assignments, but submission is disabled until your account is restored.',
      'assignment_submission_suspended':
          'Your access is suspended. Please contact the school office.',
      'plan_default_student': 'Student',
      'plan_default_library_user': 'Library user',
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
      'error_with_details': '{details}',
      'unknown_error': 'Something went wrong. Please try again.',
      'registration_failed': 'Registration failed',
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
      'open_file': 'Open file',
      'document_viewer': 'Document',
      'file_load_error': 'Could not load this file. Check your connection and try again.',
      'open_with_external_app': 'Open with another app',
      'open_in_browser': 'Open in browser',
      'external_file_hint': 'This file type opens with another app on your device (Word, Excel, etc.).',
      'external_file_opened': 'If nothing opened, tap the button below to try again.',
      'open_file_externally_failed': 'No app found to open this file.',
      'not_available': 'Not available',
      'locked': 'Locked',
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'verse_of_the_day': 'Verse of the day',
      'verse_unavailable': 'Unable to load verse of the day.',
      'pdf_load_error': 'Unable to open this PDF file.',
      'retry': 'Retry',
      // Subscription / paywall
      'subscription_required_title': 'Subscription required',
      'subscription_required_courses': 'Your subscription is inactive. Subscribe to access courses.',
      'subscription_required_library': 'Your subscription is inactive. Subscribe to access the library.',
      'subscription_required_no_access': 'Your subscription does not include this access.',
      'subscribe': 'Subscribe',
      'renew': 'Renew',
      'not_now': 'Not now',
      'refresh_plans': 'Refresh plans',
      'unlock_access': 'Unlock access',
      'choose_trimester_subscription': 'Choose a subscription plan. The first installment activates access after payment confirmation.',
      'student_plan_subtitle': 'Courses + library',
      'library_plan_subtitle': 'Library only',
      'payment_initiated_waiting': 'Payment initiated for {planName}. Waiting confirmation...',
      'mobile_money_phone_title': 'Mobile money number',
      'mobile_money_phone_label': 'Phone number',
      'mobile_money_phone_hint': 'e.g. 677123456 or 237677123456',
      'mobile_money_phone_invalid': 'Enter a valid mobile money number',
      'mobile_money_approve_on_phone': 'Approve the payment on your phone for {planName}',
      'mobile_money_start_failed': 'Could not start the mobile money payment',
      'mobile_money_payment_failed': 'Payment was not completed',
      'mobile_money_payment_timeout': 'Payment is still pending. Pull to refresh in a moment.',
      'subscription_payments_disabled':
          'Subscription payments are currently unavailable. Please contact an administrator for access.',
      'subscription_activated_success': 'Subscription activated successfully',
      'subscription_renewed_success': 'Subscription renewed successfully',
      'subscription_status_title': 'Subscription Status',
      'subscription_status_subtitle': 'Plan, expiry, and renewal',
      'status_label': 'Status',
      'expiry_label': 'Expiry',
      'days_remaining_label': 'Days remaining',
      'subscription_duration_months': '{months} months',
      'continue_reading': 'Continue reading',
      'author_prefix': 'Author: {author}',
      'author_unknown': 'Author: —',
      'recently_accessed': 'Recently accessed',
      'recent_courses': 'Recent courses',
      'recent_books': 'Recent books',
      'no_recent_access_yet': 'No recent access yet',
      'notifications_title': 'Notifications',
      'no_announcements_yet': 'No announcements yet.',
      'announcement_fallback': 'Announcement',
      'view_all': 'View all',
      'enroll': 'Enroll',
      'assignment_title_fallback': 'Assignment',
      'assignment_not_found': 'Assignment not found.',
      'assignment_answer_all_mcq': 'Please answer all MCQ questions.',
      'assignment_pdf_label': 'Assignment PDF',
      'upload_pdf': 'Upload PDF',
      'open_submitted_pdf': 'Open submitted PDF',
      'submit': 'Submit',
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
      'enrolled': 'Inscrit',
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
      'notifications_tooltip': 'Notifications',
      'outstanding_balance': 'Vous devez {amount} FCFA',
      'latest_announcement': 'Dernière annonce',
      'announcements_empty_hint': 'Les nouvelles annonces apparaîtront ici.',
      'book': 'Livre',
      'dash': '—',
      'teacher_whatsapp_unavailable':
          'Ce professeur n’a pas encore de numéro WhatsApp.',
      'today': 'Aujourd’hui',
      'group_uuid_missing': 'Informations du groupe manquantes.',
      'time_yesterday_short': 'Hier',
      'days_ago': 'Il y a {days} j',
      'chat_date_format': 'd MMM',
      'assignments_title': 'Devoirs',
      'assignments_empty': 'Aucun devoir trouvé.',
      'lesson_prefix': 'Leçon : {lesson}',
      'due_prefix': 'Date limite : {date}',
      'view_assignments': 'Voir les devoirs',
      'enroll_to_access_assignments': 'Votre niveau d’abonnement n’inclut pas encore ce cours',
      'assignment_open_pdf': 'Ouvrir le PDF',
      'assignment_mcq_points': 'Points QCM : {points}',
      'assignment_pdf_selected': 'Sélectionné : {file}',
      'assignment_no_pdf_selected_optional':
          'Aucun PDF sélectionné (optionnel)',
      'assignment_no_pdf_submitted': 'Aucun PDF soumis.',
      'assignment_teacher_points': 'Points du professeur : {points}',
      'assignment_feedback_prefix': 'Retour : {feedback}',
      'assignment_waiting_review': 'En attente de la correction...',
      'assignment_mcq_score_total': 'Total QCM : {points}',
      'assignment_final_score_total': 'Note finale : {points}',
      'assignment_submission_downgraded':
          'Votre accès est réduit. Vous pouvez voir les devoirs, mais la soumission est désactivée jusqu’à la restauration de votre compte.',
      'assignment_submission_suspended':
          'Votre accès est suspendu. Veuillez contacter l’administration.',
      'plan_default_student': 'Étudiant',
      'plan_default_library_user': 'Bibliothèque',
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
      'error_with_details': '{details}',
      'unknown_error': 'Une erreur est survenue. Veuillez réessayer.',
      'registration_failed': 'Échec de l’inscription',
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
      'open_file': 'Ouvrir le fichier',
      'document_viewer': 'Document',
      'file_load_error': 'Impossible de charger ce fichier. Vérifiez votre connexion et réessayez.',
      'open_with_external_app': 'Ouvrir avec une autre application',
      'open_in_browser': 'Ouvrir dans le navigateur',
      'external_file_hint': 'Ce type de fichier s’ouvre avec une autre application (Word, Excel, etc.).',
      'external_file_opened': 'Si rien ne s’est ouvert, appuyez sur le bouton ci-dessous.',
      'open_file_externally_failed': 'Aucune application trouvée pour ouvrir ce fichier.',
      'not_available': 'Non disponible',
      'locked': 'Verrouillé',
      'good_morning': 'Bonjour',
      'good_afternoon': 'Bon apres-midi',
      'good_evening': 'Bonsoir',
      'verse_of_the_day': 'Verset du jour',
      'verse_unavailable': 'Impossible de charger le verset du jour.',
      'pdf_load_error': 'Impossible d\'ouvrir ce fichier PDF.',
      'retry': 'Reessayer',
      // Abonnements / paywall
      'subscription_required_title': 'Abonnement requis',
      'subscription_required_courses': 'Votre abonnement est inactif. Abonnez-vous pour accéder aux cours.',
      'subscription_required_library': 'Votre abonnement est inactif. Abonnez-vous pour accéder à la bibliothèque.',
      'subscription_required_no_access': 'Votre abonnement ne donne pas accès à cette fonctionnalité.',
      'subscribe': 'S’abonner',
      'renew': 'Renouveler',
      'not_now': 'Pas maintenant',
      'refresh_plans': 'Actualiser les offres',
      'unlock_access': 'Débloquer l’accès',
      'choose_trimester_subscription': 'Choisissez une offre d’abonnement. Le premier versement active l’accès après confirmation du paiement.',
      'student_plan_subtitle': 'Cours + bibliothèque',
      'library_plan_subtitle': 'Bibliothèque uniquement',
      'payment_initiated_waiting': 'Paiement lancé pour {planName}. En attente de confirmation...',
      'mobile_money_phone_title': 'Numéro Mobile Money',
      'mobile_money_phone_label': 'Numéro de téléphone',
      'mobile_money_phone_hint': 'ex. 677123456 ou 237677123456',
      'mobile_money_phone_invalid': 'Entrez un numéro Mobile Money valide',
      'mobile_money_approve_on_phone': 'Validez le paiement sur votre téléphone pour {planName}',
      'mobile_money_start_failed': 'Impossible de lancer le paiement Mobile Money',
      'mobile_money_payment_failed': 'Le paiement n’a pas abouti',
      'mobile_money_payment_timeout': 'Paiement toujours en attente. Actualisez dans un instant.',
      'subscription_payments_disabled':
          'Les paiements d’abonnement ne sont pas disponibles pour le moment. Contactez un administrateur pour obtenir l’accès.',
      'subscription_activated_success': 'Abonnement activé avec succès',
      'subscription_renewed_success': 'Abonnement renouvelé avec succès',
      'subscription_status_title': 'Statut d’abonnement',
      'subscription_status_subtitle': 'Offre, expiration et renouvellement',
      'status_label': 'Statut',
      'expiry_label': 'Expiration',
      'days_remaining_label': 'Jours restants',
      'subscription_duration_months': '{months} mois',
      'continue_reading': 'Continuer la lecture',
      'author_prefix': 'Auteur : {author}',
      'author_unknown': 'Auteur : —',
      'recently_accessed': 'Récemment consulté',
      'recent_courses': 'Cours récents',
      'recent_books': 'Livres récents',
      'no_recent_access_yet': 'Aucun accès récent pour le moment',
      'notifications_title': 'Notifications',
      'no_announcements_yet': 'Aucune annonce pour le moment.',
      'announcement_fallback': 'Annonce',
      'view_all': 'Voir tout',
      'enroll': 'S’inscrire',
      'assignment_title_fallback': 'Devoir',
      'assignment_not_found': 'Devoir introuvable.',
      'assignment_answer_all_mcq': 'Veuillez répondre à toutes les questions QCM.',
      'assignment_pdf_label': 'PDF du devoir',
      'upload_pdf': 'Téléverser un PDF',
      'open_submitted_pdf': 'Ouvrir le PDF soumis',
      'submit': 'Soumettre',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String translateWithParams(String key, Map<String, String> params) {
    var s = translate(key);
    params.forEach((k, v) {
      s = s.replaceAll('{$k}', v);
    });
    return s;
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
  String get enrolled => translate('enrolled');
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
  String get notificationsTooltip => translate('notifications_tooltip');
  String outstandingBalance(String amount) =>
      translateWithParams('outstanding_balance', {'amount': amount});
  String get latestAnnouncement => translate('latest_announcement');
  String get announcementsEmptyHint => translate('announcements_empty_hint');
  String get book => translate('book');
  String get dash => translate('dash');
  String get teacherWhatsAppUnavailable => translate('teacher_whatsapp_unavailable');
  String get today => translate('today');
  String get groupUuidMissing => translate('group_uuid_missing');
  String get timeYesterdayShort => translate('time_yesterday_short');
  String daysAgo(int days) =>
      translateWithParams('days_ago', {'days': '$days'});
  String get chatDateFormatPattern => translate('chat_date_format');
  String get assignmentsTitle => translate('assignments_title');
  String get assignmentsEmpty => translate('assignments_empty');
  String lessonPrefix(String lesson) =>
      translateWithParams('lesson_prefix', {'lesson': lesson});
  String duePrefix(String date) =>
      translateWithParams('due_prefix', {'date': date});
  String get viewAssignments => translate('view_assignments');
  String get enrollToAccessAssignments =>
      translate('enroll_to_access_assignments');
  String get assignmentOpenPdf => translate('assignment_open_pdf');
  String assignmentMcqPoints(String points) =>
      translateWithParams('assignment_mcq_points', {'points': points});
  String assignmentPdfSelected(String file) =>
      translateWithParams('assignment_pdf_selected', {'file': file});
  String get assignmentNoPdfSelectedOptional =>
      translate('assignment_no_pdf_selected_optional');
  String get assignmentNoPdfSubmitted => translate('assignment_no_pdf_submitted');
  String assignmentTeacherPoints(String points) =>
      translateWithParams('assignment_teacher_points', {'points': points});
  String assignmentFeedbackPrefix(String feedback) =>
      translateWithParams('assignment_feedback_prefix', {'feedback': feedback});
  String get assignmentWaitingReview => translate('assignment_waiting_review');
  String assignmentMcqScoreTotal(String points) =>
      translateWithParams('assignment_mcq_score_total', {'points': points});
  String assignmentFinalScoreTotal(String points) =>
      translateWithParams('assignment_final_score_total', {'points': points});
  String get assignmentSubmissionDowngraded =>
      translate('assignment_submission_downgraded');
  String get assignmentSubmissionSuspended =>
      translate('assignment_submission_suspended');
  String get planDefaultStudent => translate('plan_default_student');
  String get planDefaultLibraryUser =>
      translate('plan_default_library_user');
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
  String errorWithDetails(Object details) => translateWithParams(
        'error_with_details',
        {'details': '$details'},
      );
  String get unknownError => translate('unknown_error');
  String get registrationFailed => translate('registration_failed');
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
  String get openFile => translate('open_file');
  String get documentViewer => translate('document_viewer');
  String get fileLoadError => translate('file_load_error');
  String get openWithExternalApp => translate('open_with_external_app');
  String get openInBrowser => translate('open_in_browser');
  String get externalFileHint => translate('external_file_hint');
  String get externalFileOpened => translate('external_file_opened');
  String get openFileExternallyFailed => translate('open_file_externally_failed');
  String get notAvailable => translate('not_available');
  String get locked => translate('locked');
  String get goodMorning => translate('good_morning');
  String get goodAfternoon => translate('good_afternoon');
  String get goodEvening => translate('good_evening');
  String get verseOfTheDay => translate('verse_of_the_day');
  String get verseUnavailable => translate('verse_unavailable');
  String get pdfLoadError => translate('pdf_load_error');
  String get retry => translate('retry');

  // Subscription / paywall
  String get subscriptionRequiredTitle => translate('subscription_required_title');
  String get subscriptionRequiredCourses => translate('subscription_required_courses');
  String get subscriptionRequiredLibrary => translate('subscription_required_library');
  String get subscriptionRequiredNoAccess => translate('subscription_required_no_access');
  String get subscribe => translate('subscribe');
  String get renew => translate('renew');
  String get notNow => translate('not_now');
  String get refreshPlans => translate('refresh_plans');
  String get unlockAccess => translate('unlock_access');
  String get chooseTrimesterSubscription => translate('choose_trimester_subscription');
  String get studentPlanSubtitle => translate('student_plan_subtitle');
  String get libraryPlanSubtitle => translate('library_plan_subtitle');
  String paymentInitiatedWaiting(String planName) =>
      translateWithParams('payment_initiated_waiting', {'planName': planName});
  String get mobileMoneyPhoneTitle => translate('mobile_money_phone_title');
  String get mobileMoneyPhoneLabel => translate('mobile_money_phone_label');
  String get mobileMoneyPhoneHint => translate('mobile_money_phone_hint');
  String get mobileMoneyPhoneInvalid => translate('mobile_money_phone_invalid');
  String mobileMoneyApproveOnPhone(String planName) =>
      translateWithParams('mobile_money_approve_on_phone', {'planName': planName});
  String get mobileMoneyStartFailed => translate('mobile_money_start_failed');
  String get mobileMoneyPaymentFailed => translate('mobile_money_payment_failed');
  String get mobileMoneyPaymentTimeout => translate('mobile_money_payment_timeout');
  String subscriptionDurationMonths(int months) =>
      translateWithParams('subscription_duration_months', {'months': '$months'});
  String get continueReading => translate('continue_reading');
  String authorPrefix(String author) =>
      translateWithParams('author_prefix', {'author': author});
  String get authorUnknown => translate('author_unknown');
  String get recentlyAccessed => translate('recently_accessed');
  String get recentCourses => translate('recent_courses');
  String get recentBooks => translate('recent_books');
  String get noRecentAccessYet => translate('no_recent_access_yet');
  String get notificationsTitle => translate('notifications_title');
  String get noAnnouncementsYet => translate('no_announcements_yet');
  String get announcementFallback => translate('announcement_fallback');
  String get viewAll => translate('view_all');
  String get enroll => translate('enroll');
  String get assignmentTitleFallback => translate('assignment_title_fallback');
  String get assignmentNotFound => translate('assignment_not_found');
  String get assignmentAnswerAllMcq => translate('assignment_answer_all_mcq');
  String get assignmentPdfLabel => translate('assignment_pdf_label');
  String get uploadPdf => translate('upload_pdf');
  String get openSubmittedPdf => translate('open_submitted_pdf');
  String get submit => translate('submit');
  String get subscriptionPaymentsDisabled =>
      translate('subscription_payments_disabled');
  String get subscriptionActivatedSuccess => translate('subscription_activated_success');
  String get subscriptionRenewedSuccess => translate('subscription_renewed_success');
  String get subscriptionStatusTitle => translate('subscription_status_title');
  String get subscriptionStatusSubtitle => translate('subscription_status_subtitle');
  String get statusLabel => translate('status_label');
  String get expiryLabel => translate('expiry_label');
  String get daysRemainingLabel => translate('days_remaining_label');
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
