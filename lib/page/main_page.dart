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
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navTheme = Theme.of(context).bottomNavigationBarTheme;
    return Scaffold(
      body: pages[currentStep],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: isDark
                  ? CbsColors.darkNavBg
                  : (navTheme.backgroundColor ?? CbsColors.lightCardBg),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? CbsColors.darkBorder.withValues(alpha: 0.9)
                    : CbsColors.creamDark,
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Row(
                children: [
                  _NavItem(
                    index: 0,
                    currentIndex: currentStep,
                    label: l10n.navHome,
                    icon: Icons.home,
                    isDark: isDark,
                    selectedColor: CbsColors.brandGold,
                    unselectedColor:
                        isDark ? CbsColors.brandIvory : navTheme.unselectedItemColor ?? CbsColors.warmGrey,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 1,
                    currentIndex: currentStep,
                    label: l10n.navLibrary,
                    icon: Icons.my_library_books_rounded,
                    isDark: isDark,
                    selectedColor: CbsColors.brandGold,
                    unselectedColor:
                        isDark ? CbsColors.brandIvory : navTheme.unselectedItemColor ?? CbsColors.warmGrey,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 2,
                    currentIndex: currentStep,
                    label: l10n.navCourses,
                    icon: Icons.school,
                    isDark: isDark,
                    selectedColor: CbsColors.brandGold,
                    unselectedColor:
                        isDark ? CbsColors.brandIvory : navTheme.unselectedItemColor ?? CbsColors.warmGrey,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 3,
                    currentIndex: currentStep,
                    label: l10n.navForum,
                    icon: Icons.message,
                    isDark: isDark,
                    selectedColor: CbsColors.brandGold,
                    unselectedColor:
                        isDark ? CbsColors.brandIvory : navTheme.unselectedItemColor ?? CbsColors.warmGrey,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 4,
                    currentIndex: currentStep,
                    label: l10n.settings,
                    icon: Icons.settings,
                    isDark: isDark,
                    selectedColor: CbsColors.brandGold,
                    unselectedColor:
                        isDark ? CbsColors.brandIvory : navTheme.unselectedItemColor ?? CbsColors.warmGrey,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final bool isDark;
  final Color selectedColor;
  final Color unselectedColor;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.zero,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? selectedColor.withValues(alpha: isDark ? 0.16 : 0.12)
                  : Colors.transparent,
              border: Border.all(
                color: selected
                    ? (isDark ? CbsColors.goldDeep : selectedColor)
                        .withValues(alpha: isDark ? 0.7 : 0.45)
                    : Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? selectedColor : unselectedColor,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? selectedColor : unselectedColor,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
