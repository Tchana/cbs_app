import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/features/splash_screens/splash_screens.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/page/main_page.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_shell_controller.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/supabase/supabase_config.dart';
import 'package:center_for_biblical_studies/utils/cbs_theme.dart';
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
  Get.put(DataController(), permanent: true);
  Get.put(DesktopShellController(), permanent: true);
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
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appName ??
          'Center for Biblical Studies',
      theme: CbsTheme.light(),
      darkTheme: CbsTheme.dark(),
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
      getPages: [
        GetPage(name: '/MainPage', page: () => const MainPage()),
      ],
      home: Builder(
        builder: (context) {
          if (Adaptive.isDesktop(context)) {
            return const LoginPage();
          }
          return const SplashScreen();
        },
      ),
    );
  }
}
