import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _currentLanguage = 'fr';
  String _currentTheme = 'light';
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await SettingsService.getLanguage();
    final theme = await SettingsService.getTheme();
    final notifications = await SettingsService.getNotificationsEnabled();
    final sound = await SettingsService.getSoundEnabled();
    final vibration = await SettingsService.getVibrationEnabled();

    if (mounted) {
      setState(() {
        _currentLanguage = language;
        _currentTheme = theme;
        _notificationsEnabled = notifications;
        _soundEnabled = sound;
        _vibrationEnabled = vibration;
      });
    }
  }

  Future<void> _handleLanguageChange(String languageCode) async {
    await SettingsService.setLanguage(languageCode);
    if (mounted) {
      setState(() {
        _currentLanguage = languageCode;
      });
      // Note: Full app restart needed for language change
      // This is a simplified approach - in production, you'd want to use a state management solution
    }
  }

  Future<void> _handleThemeChange(String theme) async {
    await SettingsService.setTheme(theme);
    if (mounted) {
      setState(() {
        _currentTheme = theme;
      });
      // Note: Full app restart needed for theme change
      // This is a simplified approach - in production, you'd want to use a state management solution
    }
  }

  Future<void> _handleLogout() async {
    final localizations =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.logout,
            style: largeStyle32Bold.copyWith(color: CbsColors.primaryBrown),
          ),
          content: Text(
            localizations.logoutConfirmation,
            style: smallStyle18,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                localizations.cancel,
                style: smallStyle18.copyWith(color: CbsColors.primaryBrown),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: CbsColors.primaryBrown,
                foregroundColor: CbsColors.white,
              ),
              child: Text(
                localizations.confirm,
                style: smallStyle18.copyWith(color: CbsColors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              gapH16,
              PageHeader(
                title: localizations.settings,
                titleIcon: const Icon(
                  Icons.settings,
                  color: CbsColors.primaryBlue,
                ),
              ),
              gapH32,
              // Language Section
              _buildSection(
                title: localizations.language,
                icon: Icons.language,
                children: [
                  _buildLanguageTile(
                    context,
                    localizations,
                    'fr',
                    localizations.french,
                    Icons.flag,
                  ),
                  _buildLanguageTile(
                    context,
                    localizations,
                    'en',
                    localizations.english,
                    Icons.flag_outlined,
                  ),
                ],
              ),
              gapH16,
              // Theme Section
              _buildSection(
                title: localizations.theme,
                icon: Icons.palette,
                children: [
                  _buildThemeTile(
                    context,
                    localizations,
                    'light',
                    localizations.lightTheme,
                    Icons.light_mode,
                  ),
                  _buildThemeTile(
                    context,
                    localizations,
                    'dark',
                    localizations.darkTheme,
                    Icons.dark_mode,
                  ),
                  _buildThemeTile(
                    context,
                    localizations,
                    'system',
                    localizations.systemTheme,
                    Icons.brightness_auto,
                  ),
                ],
              ),
              gapH16,
              // Notifications Section
              _buildSection(
                title: localizations.notifications,
                icon: Icons.notifications,
                children: [
                  _buildSwitchTile(
                    context,
                    localizations,
                    localizations.notificationsEnabled,
                    _notificationsEnabled,
                    Icons.notifications_active,
                    (value) async {
                      await SettingsService.setNotificationsEnabled(value);
                      if (mounted) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      }
                    },
                  ),
                  _buildSwitchTile(
                    context,
                    localizations,
                    localizations.soundEnabled,
                    _soundEnabled,
                    Icons.volume_up,
                    (value) async {
                      await SettingsService.setSoundEnabled(value);
                      if (mounted) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      }
                    },
                  ),
                  _buildSwitchTile(
                    context,
                    localizations,
                    localizations.vibrationEnabled,
                    _vibrationEnabled,
                    Icons.vibration,
                    (value) async {
                      await SettingsService.setVibrationEnabled(value);
                      if (mounted) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              gapH16,
              // About Section
              _buildSection(
                title: localizations.about,
                icon: Icons.info,
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline,
                        color: CbsColors.primaryBrown),
                    title: Text(
                      localizations.appName,
                      style: smallStyle18.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${localizations.version} 1.0.0',
                      style: smallStyle18.copyWith(color: CbsColors.hintColor),
                    ),
                  ),
                ],
              ),
              gapH32,
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: CbsColors.white),
                    label: Text(
                      localizations.logout,
                      style: smallStyle18.copyWith(
                        color: CbsColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CbsColors.errorColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              gapH32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: CbsColors.primaryBrown, size: 20),
              gapW8,
              Text(
                title,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CbsColors.primaryBrown,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    AppLocalizations? localizations,
    String languageCode,
    String languageName,
    IconData icon,
  ) {
    final isSelected = _currentLanguage == languageCode;
    return ListTile(
      leading: Icon(icon, color: CbsColors.primaryBrown),
      title: Text(
        languageName,
        style: smallStyle18,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: CbsColors.primaryBrown)
          : null,
      onTap: () => _handleLanguageChange(languageCode),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    AppLocalizations? localizations,
    String theme,
    String themeName,
    IconData icon,
  ) {
    final isSelected = _currentTheme == theme;
    return ListTile(
      leading: Icon(icon, color: CbsColors.primaryBrown),
      title: Text(
        themeName,
        style: smallStyle18,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: CbsColors.primaryBrown)
          : null,
      onTap: () => _handleThemeChange(theme),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    AppLocalizations? localizations,
    String title,
    bool value,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: CbsColors.primaryBrown),
      title: Text(
        title,
        style: smallStyle18,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: CbsColors.primaryBrown,
      ),
    );
  }
}
