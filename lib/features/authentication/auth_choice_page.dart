import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/features/authentication/signup_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_auth_layout.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttons = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => Get.to(() => const LoginPage()),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor:
                      isDark ? CbsColors.brandGold : CbsColors.brandBrown,
                  foregroundColor:
                      isDark ? CbsColors.brownNight : CbsColors.brandWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.login,
                  style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Get.to(() => const SignupPage()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: BorderSide(
                    color:
                        isDark ? CbsColors.brandGold : CbsColors.brandDeepBlue,
                  ),
                  foregroundColor:
                      isDark ? CbsColors.brandGold : CbsColors.brandDeepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.register,
                  style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );

    if (Adaptive.isDesktop(context)) {
      return DesktopAuthLayout(
        headline: l10n.signInToYourAccount,
        form: buttons,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.menu_book_rounded,
                size: 72,
                color: isDark ? CbsColors.brandBlue : CbsColors.brandDeepBlue,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.appName,
                textAlign: TextAlign.center,
                style: largeStyle32Bold.copyWith(
                  fontSize: 28,
                  color: isDark ? CbsColors.darkText : CbsColors.brandBrown,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.signInToYourAccount,
                textAlign: TextAlign.center,
                style: smallStyle18.copyWith(
                  fontSize: 16,
                  color: isDark ? CbsColors.darkHint : CbsColors.hintColor,
                ),
              ),
              const Spacer(),
              buttons,
            ],
          ),
        ),
      ),
    );
  }
}
