import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// Campus login hall: crest panel + enrolment form.
class DesktopAuthLayout extends StatelessWidget {
  const DesktopAuthLayout({
    super.key,
    required this.form,
    this.headline,
    this.subtitle,
    this.showAppBar = false,
    this.appBarTitle,
  });

  final Widget form;
  final String? headline;
  final String? subtitle;
  final bool showAppBar;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6),
      appBar: showAppBar
          ? AppBar(
              backgroundColor: CbsColors.primaryBrown,
              foregroundColor: CbsColors.white,
              title: Text(appBarTitle ?? ''),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3A2108),
                    Color(0xFF4A2C0A),
                    Color(0xFF6B3F15),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: CbsColors.brandGold.withValues(alpha: 0.7),
                              width: 1.5,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/cbs_logo.png',
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.menu_book_rounded,
                              size: 56,
                              color: CbsColors.brandGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          l10n.appName,
                          style: largeStyle32Bold.copyWith(
                            color: Colors.white,
                            fontSize: 34,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: 64,
                          height: 3,
                          color: CbsColors.brandGold,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          headline ?? l10n.signInToYourAccount,
                          style: smallStyle18.copyWith(
                            color: CbsColors.brandGold,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if ((subtitle ?? '').isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            subtitle!,
                            style: smallStyle18.copyWith(
                              color: Colors.white.withValues(alpha: 0.84),
                              fontSize: 15,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ColoredBox(
              color: isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                      decoration: BoxDecoration(
                        color: isDark ? CbsColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? CbsColors.goldDeep.withValues(alpha: 0.3)
                              : CbsColors.creamDark,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: form,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
