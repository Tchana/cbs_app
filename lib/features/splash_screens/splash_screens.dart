import 'package:center_for_biblical_studies/features/authentication/auth_choice_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/page/main_page.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final isLoggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
      return;
    }

    final hasSeenOnboarding = await SettingsService.hasSeenOnboarding();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => hasSeenOnboarding
            ? const AuthChoicePage()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandBrown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/cbs_logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.appName,
              style: smallStyle18.copyWith(
                color: CbsColors.brandWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<String> _images = [
    'assets/images/img.png',
    'assets/images/img_1.png',
    'assets/images/img.png',
  ];

  Future<void> _finishOnboarding() async {
    await SettingsService.setOnboardingSeen(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthChoicePage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final texts = [l10n.onboarding1, l10n.onboarding2, l10n.onboarding3];

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      l10n.skip,
                      style: smallStyle18.copyWith(
                        color: isDark
                            ? CbsColors.brandBlue
                            : CbsColors.brandDeepBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            _images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          texts[index],
                          textAlign: TextAlign.center,
                          style: largeStyle32Bold.copyWith(
                            fontSize: 28,
                            color: isDark
                                ? CbsColors.darkText
                                : CbsColors.brandBrown,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 8,
                              width: _currentPage == i ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == i
                                    ? (isDark
                                        ? CbsColors.brandBlue
                                        : CbsColors.brandDeepBlue)
                                    : CbsColors.hintColor
                                        .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: () {
                              if (index == 2) {
                                _finishOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: isDark
                                  ? CbsColors.brandDeepBlue
                                  : CbsColors.brandBrown,
                              foregroundColor: CbsColors.brandWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              index < 2 ? l10n.splashNext : l10n.splashStart,
                              style: smallStyle18.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
