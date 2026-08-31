import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// Desktop login as a registrar counter: white slab + monumental brand field.
class DesktopLoginView extends StatelessWidget {
  const DesktopLoginView({
    super.key,
    required this.form,
  });

  final Widget form;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final slab = isDark ? CbsColors.darkSurface : Colors.white;
    final field = isDark ? const Color(0xFF120A05) : const Color(0xFF3D240C);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 520,
            child: ColoredBox(
              color: slab,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(56, 40, 56, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Monogram(isDark: isDark),
                      const SizedBox(height: 14),
                      Text(
                        l10n.appName,
                        style: smallStyle18.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: isDark
                              ? CbsColors.darkTextPrimary
                              : CbsColors.primaryBrown,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.login.toUpperCase(),
                        style: smallStyle18.copyWith(
                          fontSize: 12,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? CbsColors.brandGold
                              : CbsColors.primaryBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.signInToYourAccount,
                        style: smallStyle18.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2A1608),
                        ),
                      ),
                      const SizedBox(height: 28),
                      form,
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: field,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      color: CbsColors.brandGold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(64, 72, 64, 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          'CBS',
                          style: TextStyle(
                            fontSize: 128,
                            height: 0.85,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 18,
                            color: CbsColors.brandGold.withValues(alpha: 0.92),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: 56,
                          height: 2,
                          color: CbsColors.brandGold,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          l10n.appName,
                          style: smallStyle18.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.navCourses,
                          style: smallStyle18.copyWith(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 13,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'CBS',
        style: TextStyle(
          color: isDark ? const Color(0xFF2A1608) : Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
