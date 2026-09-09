import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/services/update_service.dart';
import 'package:center_for_biblical_studies/core/platform/platform_capabilities.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_campus_ui.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:center_for_biblical_studies/widgets/update_dialog.dart';
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
  String _appVersionLabel = '';
  bool _checkingForUpdates = false;

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
    final versionLabel = await UpdateService.getCurrentVersionLabel();

    if (mounted) {
      setState(() {
        _currentLanguage = language;
        _currentTheme = theme;
        _notificationsEnabled = notifications;
        _soundEnabled = sound;
        _vibrationEnabled = vibration;
        _appVersionLabel = versionLabel;
      });
    }
  }

  Future<void> _checkForUpdates() async {
    if (_checkingForUpdates) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    setState(() => _checkingForUpdates = true);
    try {
      final update = await UpdateService.checkForUpdate(force: true);
      if (!mounted) return;
      if (update != null) {
        await UpdateDialog.show(context, update);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.youAreOnLatestVersion)),
        );
      }
    } finally {
      if (mounted) setState(() => _checkingForUpdates = false);
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
      builder: (BuildContext dialogContext) {
        final dialogDark =
            Theme.of(dialogContext).brightness == Brightness.dark;
        final surface = dialogDark ? CbsColors.darkSurface : CbsColors.white;
        final border =
            dialogDark ? CbsColors.darkBorder : CbsColors.creamDark;
        final titleColor = dialogDark
            ? CbsColors.darkTextPrimary
            : CbsColors.primaryBrown;
        final bodyColor = dialogDark
            ? CbsColors.darkTextSecondary
            : (CbsColors.primaryDark[800] ?? CbsColors.primaryBrown);
        final primaryBg =
            dialogDark ? CbsColors.brandGold : CbsColors.primaryBrown;
        final primaryFg =
            dialogDark ? CbsColors.brownNight : CbsColors.white;
        final danger = CbsColors.errorColor;
        return AlertDialog(
          backgroundColor: surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: border.withValues(alpha: 0.9)),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: danger.withValues(alpha: dialogDark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: danger.withValues(alpha: dialogDark ? 0.45 : 0.30),
                  ),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: danger,
                  size: 20,
                ),
              ),
              gapW12,
              Expanded(
                child: Text(
                  localizations.logout,
                  style: smallStyle18.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            localizations.logoutConfirmation,
            style: smallStyle18.copyWith(
              color: bodyColor,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: OutlinedButton.styleFrom(
                foregroundColor: dialogDark
                    ? CbsColors.darkTextSecondary
                    : CbsColors.primaryBrown,
                side: BorderSide(color: border.withValues(alpha: 0.9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: primaryBg,
                foregroundColor: primaryFg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              child: Text(
                localizations.confirm,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
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
    final surface = isDark ? CbsColors.darkSurface : CbsColors.white;
    final muted =
        isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor;
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryBrown;
    final accentIcon =
        isDark ? CbsColors.brandGold : CbsColors.primaryBrown;

    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkBg : CbsColors.backgroundColor,
      appBar: Adaptive.isDesktop(context)
          ? null
          : AppBar(
        title: Text(
          localizations.settings,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: DesktopPageFrame(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Adaptive.isDesktop(context))
                CampusPageHeader(
                  title: localizations.settings,
                  subtitle: localizations.settingsSubtitle,
                  icon: Icons.settings_rounded,
                ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [CbsColors.darkSurface, CbsColors.darkElevated]
                        : [
                            CbsColors.primaryBrown.withValues(alpha: 0.95),
                            CbsColors.brandDeepBlue.withValues(alpha: 0.95),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: isDark
                      ? Border.all(
                          color: CbsColors.goldDeep.withValues(alpha: 0.45),
                        )
                      : null,
                  boxShadow: isDark
                      ? null
                      : [
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
                        color: isDark
                            ? CbsColors.brandGold.withValues(alpha: 0.15)
                            : CbsColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: isDark ? CbsColors.brandGold : CbsColors.white,
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: Text(
                        localizations.settingsSubtitle,
                        style: smallStyle18.copyWith(
                          fontSize: 14,
                          color: isDark
                              ? CbsColors.darkTextPrimary
                              : CbsColors.white,
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
                isDark: isDark,
                titleColor: titleColor,
                muted: muted,
                accentIcon: accentIcon,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                isDark: isDark,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildChoiceChip(
                      label: localizations.french,
                      selected: _currentLanguage == 'fr',
                      isDark: isDark,
                      onTap: () => _handleLanguageChange('fr'),
                    ),
                    _buildChoiceChip(
                      label: localizations.english,
                      selected: _currentLanguage == 'en',
                      isDark: isDark,
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
                isDark: isDark,
                titleColor: titleColor,
                muted: muted,
                accentIcon: accentIcon,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                isDark: isDark,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildChoiceChip(
                      label: localizations.lightTheme,
                      selected: _currentTheme == 'light',
                      isDark: isDark,
                      onTap: () => _handleThemeChange('light'),
                    ),
                    _buildChoiceChip(
                      label: localizations.darkTheme,
                      selected: _currentTheme == 'dark',
                      isDark: isDark,
                      onTap: () => _handleThemeChange('dark'),
                    ),
                    _buildChoiceChip(
                      label: localizations.systemTheme,
                      selected: _currentTheme == 'system',
                      isDark: isDark,
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
                isDark: isDark,
                titleColor: titleColor,
                muted: muted,
                accentIcon: accentIcon,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                isDark: isDark,
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: localizations.notificationsEnabled,
                      subtitle: localizations.notificationsDescription,
                      value: _notificationsEnabled,
                      icon: Icons.notifications_active,
                      muted: muted,
                      isDark: isDark,
                      accentIcon: accentIcon,
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
                      isDark: isDark,
                      accentIcon: accentIcon,
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
                      isDark: isDark,
                      accentIcon: accentIcon,
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
                isDark: isDark,
                titleColor: titleColor,
                muted: muted,
                accentIcon: accentIcon,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                isDark: isDark,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.info_outline,
                        color: accentIcon,
                      ),
                      title: Text(
                        localizations.appName,
                        style: smallStyle18.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? CbsColors.darkTextPrimary : null,
                        ),
                      ),
                      subtitle: Text(
                        _appVersionLabel.isEmpty
                            ? '${localizations.version} …'
                            : '${localizations.version} $_appVersionLabel',
                        style:
                            smallStyle18.copyWith(color: muted, fontSize: 13),
                      ),
                    ),
                    if (PlatformCapabilities.supportsAppUpdates) ...[
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.system_update_alt,
                          color: accentIcon,
                        ),
                        title: Text(
                          localizations.checkForUpdates,
                          style: smallStyle18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? CbsColors.darkTextPrimary : null,
                          ),
                        ),
                        subtitle: Text(
                          localizations.downloadLatestRelease,
                          style: smallStyle18.copyWith(
                            fontSize: 13,
                            color: muted,
                          ),
                        ),
                        trailing: _checkingForUpdates
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.chevron_right, color: muted),
                        onTap:
                            _checkingForUpdates ? null : _checkForUpdates,
                      ),
                    ],
                  ],
                ),
              ),
              gapH16,
              _buildSectionTitle(
                title: localizations.accountActions,
                subtitle: localizations.logoutDescription,
                icon: Icons.manage_accounts_outlined,
                isDark: isDark,
                titleColor: titleColor,
                muted: muted,
                accentIcon: accentIcon,
              ),
              gapH8,
              _buildCard(
                surface: surface,
                isDark: isDark,
                child: Column(
                  children: [
                    ListTile(
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
                      trailing: Icon(
                        Icons.chevron_right,
                        color: muted,
                      ),
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color surface,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? CbsColors.darkBorder.withValues(alpha: 0.9)
              : CbsColors.primaryBrown.withValues(alpha: 0.12),
        ),
        boxShadow: isDark
            ? null
            : [
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
    required bool isDark,
    required Color titleColor,
    required Color muted,
    required Color accentIcon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isDark
                ? CbsColors.darkElevated
                : CbsColors.primaryBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: isDark
                ? Border.all(
                    color: CbsColors.goldDeep.withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Icon(icon, color: accentIcon, size: 18),
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
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: smallStyle18.copyWith(
                  fontSize: 12,
                  color: muted,
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
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final selectedBg =
        isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final selectedFg =
        isDark ? CbsColors.brownNight : CbsColors.white;
    final unselectedFg =
        isDark ? CbsColors.darkTextSecondary : CbsColors.primaryBrown;
    final unselectedBg = isDark
        ? CbsColors.darkElevated
        : CbsColors.primaryBrown.withValues(alpha: 0.08);
    final borderColor = isDark
        ? (selected ? CbsColors.brandGold : CbsColors.darkBorder)
        : CbsColors.primaryBrown.withValues(alpha: 0.2);

    return ChoiceChip(
      label: Text(
        label,
        style: smallStyle18.copyWith(
          fontSize: 13,
          color: selected ? selectedFg : unselectedFg,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: selectedBg,
      backgroundColor: unselectedBg,
      side: BorderSide(color: borderColor),
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
          ? CbsColors.darkDivider
          : CbsColors.primaryBrown.withValues(alpha: 0.1),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Color muted,
    required bool isDark,
    required Color accentIcon,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: accentIcon),
      title: Text(
        title,
        style: smallStyle18.copyWith(
          fontSize: 15,
          color: isDark ? CbsColors.darkTextPrimary : null,
        ),
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
        activeThumbColor:
            isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
        activeTrackColor: isDark
            ? CbsColors.brandGold.withValues(alpha: 0.35)
            : CbsColors.primaryBrown.withValues(alpha: 0.35),
      ),
    );
  }
}
