import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      Get.updateLocale(Locale(languageCode));
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saved)),
      );
    }
  }

  Future<void> _handleThemeChange(String theme) async {
    await SettingsService.setTheme(theme);
    if (mounted) {
      setState(() {
        _currentTheme = theme;
      });
      final themeMode = theme == 'dark'
          ? ThemeMode.dark
          : theme == 'system'
              ? ThemeMode.system
              : ThemeMode.light;
      Get.changeThemeMode(themeMode);
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saved)),
      );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? CbsColors.darkCard : CbsColors.white;
    final muted = isDark ? CbsColors.darkHint : CbsColors.hintColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeader(
                title: localizations.settings,
                titleIcon: const Icon(
                  Icons.settings,
                  color: CbsColors.primaryBrown,
                ),
              ),
              gapH8,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CbsColors.primaryBrown.withValues(alpha: 0.95),
                      CbsColors.brandDeepBlue.withValues(alpha: 0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: CbsColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: CbsColors.white,
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: Text(
                        localizations.settingsSubtitle,
                        style: smallStyle18.copyWith(
                          fontSize: 14,
                          color: CbsColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapH20,
              _buildSectionTitle(
                title: localizations.language,
                subtitle: localizations.languageDescription,
                icon: Icons.language,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildChoiceChip(
                      label: localizations.french,
                      selected: _currentLanguage == 'fr',
                      onTap: () => _handleLanguageChange('fr'),
                    ),
                    _buildChoiceChip(
                      label: localizations.english,
                      selected: _currentLanguage == 'en',
                      onTap: () => _handleLanguageChange('en'),
                    ),
                  ],
                ),
              ),
              gapH16,
              _buildSectionTitle(
                title: localizations.theme,
                subtitle: localizations.themeDescription,
                icon: Icons.palette_rounded,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildChoiceChip(
                      label: localizations.lightTheme,
                      selected: _currentTheme == 'light',
                      onTap: () => _handleThemeChange('light'),
                    ),
                    _buildChoiceChip(
                      label: localizations.darkTheme,
                      selected: _currentTheme == 'dark',
                      onTap: () => _handleThemeChange('dark'),
                    ),
                    _buildChoiceChip(
                      label: localizations.systemTheme,
                      selected: _currentTheme == 'system',
                      onTap: () => _handleThemeChange('system'),
                    ),
                  ],
                ),
              ),
              gapH16,
              _buildSectionTitle(
                title: localizations.appPreferences,
                subtitle: localizations.notificationsDescription,
                icon: Icons.notifications_active_outlined,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: localizations.notificationsEnabled,
                      subtitle: localizations.notificationsDescription,
                      value: _notificationsEnabled,
                      icon: Icons.notifications_active,
                      muted: muted,
                      onChanged: (value) async {
                        await SettingsService.setNotificationsEnabled(value);
                        if (mounted) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        }
                      },
                    ),
                    _divider(isDark),
                    _buildSwitchTile(
                      title: localizations.soundEnabled,
                      subtitle: localizations.soundDescription,
                      value: _soundEnabled,
                      icon: Icons.volume_up,
                      muted: muted,
                      onChanged: (value) async {
                        await SettingsService.setSoundEnabled(value);
                        if (mounted) {
                          setState(() {
                            _soundEnabled = value;
                          });
                        }
                      },
                    ),
                    _divider(isDark),
                    _buildSwitchTile(
                      title: localizations.vibrationEnabled,
                      subtitle: localizations.vibrationDescription,
                      value: _vibrationEnabled,
                      icon: Icons.vibration,
                      muted: muted,
                      onChanged: (value) async {
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
              ),
              gapH16,
              _buildSectionTitle(
                title: localizations.about,
                subtitle: localizations.appName,
                icon: Icons.info_outline_rounded,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.info_outline,
                    color: CbsColors.primaryBrown,
                  ),
                  title: Text(
                    localizations.appName,
                    style: smallStyle18.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${localizations.version} 1.0.0',
                    style: smallStyle18.copyWith(color: muted, fontSize: 13),
                  ),
                ),
              ),
              gapH16,
              _buildSectionTitle(
                title: localizations.accountActions,
                subtitle: localizations.logoutDescription,
                icon: Icons.manage_accounts_outlined,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.logout, color: CbsColors.errorColor),
                  title: Text(
                    localizations.logout,
                    style: smallStyle18.copyWith(
                      color: CbsColors.errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    localizations.logoutDescription,
                    style: smallStyle18.copyWith(
                      fontSize: 13,
                      color: muted,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: CbsColors.hintColor),
                  onTap: _handleLogout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color surface,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: CbsColors.primaryBrown.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: CbsColors.primaryBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: CbsColors.primaryBrown, size: 18),
        ),
        gapW10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CbsColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: smallStyle18.copyWith(
                  fontSize: 12,
                  color: CbsColors.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: smallStyle18.copyWith(
          fontSize: 13,
          color: selected ? CbsColors.white : CbsColors.primaryBrown,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: CbsColors.primaryBrown,
      backgroundColor: CbsColors.primaryBrown.withValues(alpha: 0.08),
      side: BorderSide(
        color: CbsColors.primaryBrown.withValues(alpha: 0.2),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? CbsColors.darkHint.withValues(alpha: 0.35)
          : CbsColors.primaryBrown.withValues(alpha: 0.1),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color muted,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: CbsColors.primaryBrown),
      title: Text(
        title,
        style: smallStyle18.copyWith(fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: smallStyle18.copyWith(
          fontSize: 12,
          color: muted,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: CbsColors.primaryBrown,
      ),
    );
  }
}
