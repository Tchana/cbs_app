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

class _MainPageState extends State<MainPage> {
  List pages = [
    DashboardPage(),
    LibraryPage(),
    CoursesPage(),
    ForumPage(),
    Settings(),
  ];

  int currentStep = 0;
  void onTap(int index) {
    setState(() {
      currentStep = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Keep library/courses gates in sync after cold start (splash skips data load).
    Future<void>(() async {
      try {
        await const SupabaseService().refreshMyEntitlement();
      } catch (_) {}
    });
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
