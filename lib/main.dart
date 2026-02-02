import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
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
  ThemeMode _themeMode = ThemeMode.light;

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

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Center for Biblical Studies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CbsColors.primaryBrown,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        primaryColor: CbsColors.primaryBrown,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: CbsColors.primaryBrown,
        ),
        useMaterial3: true,
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
      home: const LoginPage(),
    );
  }
}
