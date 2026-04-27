import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _languageKey = 'app_language';
  static const String _themeKey = 'app_theme';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _soundKey = 'sound_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _onboardingSeenKey = 'onboarding_seen';

  // Language settings
  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'fr'; // Default to French
  }

  static Future<void> setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Theme settings
  static Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system'; // Default to system
  }

  static Future<void> setTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  // Notification settings
  static Future<bool> getNotificationsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true; // Default enabled
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  // Sound settings
  static Future<bool> getSoundEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundKey) ?? true; // Default enabled
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, enabled);
  }

  // Vibration settings
  static Future<bool> getVibrationEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationKey) ?? true; // Default enabled
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
  }

  static Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  static Future<void> setOnboardingSeen(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, seen);
  }
}
