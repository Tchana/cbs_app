import 'package:center_for_biblical_studies/features/courses/courses_page.dart';
import 'package:center_for_biblical_studies/features/dashboard/dashboard_page.dart';
import 'package:center_for_biblical_studies/features/forum/forum_pages.dart';
import 'package:center_for_biblical_studies/features/library/Library_page.dart';
import 'package:center_for_biblical_studies/features/settings/settings.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  List pages = [
    DashboardPage(),
    LibraryPage(),
    CoursesPage(),
    ForumPage(),
    Settings(),
  ];

  int currentStep = 0;

  Future<void> _refreshEntitlementIfNeeded(int index) async {
    if (index == 0 || index == 1 || index == 2) {
      try {
        await const SupabaseService().refreshMyEntitlement();
      } catch (_) {}
    }
  }

  void onTap(int index) {
    setState(() {
      currentStep = index;
    });
    _refreshEntitlementIfNeeded(index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshEntitlementIfNeeded(currentStep);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshEntitlementIfNeeded(currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      body: pages[currentStep],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentStep,
        selectedItemColor: CbsColors.primaryBrown,
        unselectedItemColor: CbsColors.primaryBrown.withValues(alpha: 0.5),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            label: l10n.navHome,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: l10n.navLibrary,
            icon: const Icon(Icons.my_library_books_rounded),
          ),
          BottomNavigationBarItem(
            label: l10n.navCourses,
            icon: const Icon(Icons.school),
          ),
          BottomNavigationBarItem(
            label: l10n.navForum,
            icon: const Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: l10n.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
