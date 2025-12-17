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
