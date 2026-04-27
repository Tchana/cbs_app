import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/features/splash_screens/splash_screens.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/supabase/supabase_config.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('fr');
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final languageCode = await SettingsService.getLanguage();
    final theme = await SettingsService.getTheme();

    if (mounted) {
      setState(() {
        _locale = Locale(languageCode);
        _themeMode = theme == 'dark'
            ? ThemeMode.dark
            : theme == 'system'
                ? ThemeMode.system
                : ThemeMode.light;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DataController());

    final lightScheme = ColorScheme.fromSeed(
      seedColor: CbsColors.brandBrown,
      brightness: Brightness.light,
    ).copyWith(
      primary: CbsColors.brandBrown,
      secondary: CbsColors.brandBlue,
      surface: CbsColors.brandWhite,
      onSurface: CbsColors.brandBrown,
      error: CbsColors.errorColor,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: CbsColors.brandDeepBlue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF1F7A8C),
      secondary: const Color(0xFFBFDBF7),
      surface: CbsColors.darkSurface,
      onSurface: CbsColors.darkText,
      error: CbsColors.errorColor,
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appName ??
          'Center for Biblical Studies',
      theme: ThemeData(
        colorScheme: lightScheme,
        useMaterial3: true,
        primaryColor: CbsColors.brandBrown,
        scaffoldBackgroundColor: CbsColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: CbsColors.brandBrown,
          foregroundColor: CbsColors.brandWhite,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: CbsColors.brandBrown,
              displayColor: CbsColors.brandBrown,
            ),
        iconTheme: const IconThemeData(color: CbsColors.brandBrown),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: CbsColors.brandBrown,
            foregroundColor: CbsColors.brandWhite,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkScheme,
        useMaterial3: true,
        primaryColor: const Color(0xFF1F7A8C),
        scaffoldBackgroundColor: CbsColors.darkSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F7A8C),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        cardColor: CbsColors.darkCard,
        dividerColor: CbsColors.darkText.withValues(alpha: 0.28),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: CbsColors.darkText,
              displayColor: CbsColors.darkText,
            ),
        iconTheme: const IconThemeData(color: Color(0xFF3F2C23)),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF3F2C23),
            foregroundColor: Color(0xFFFFFFFF),
          ),
        ),
      ),
      themeMode: _themeMode,
      locale: _locale,
      fallbackLocale: const Locale('fr', ''),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      home: const SplashScreen(),
    );
  }
}
