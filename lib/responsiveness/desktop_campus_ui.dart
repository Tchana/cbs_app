import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CampusCard extends StatelessWidget {
  const CampusCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (isDark ? CbsColors.darkSurface : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? CbsColors.goldDeep.withValues(alpha: 0.28)
              : CbsColors.creamDark,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      ),
    );
  }
}

class CampusPageHeader extends StatelessWidget {
  const CampusPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.school_rounded,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? CbsColors.brandGold.withValues(alpha: 0.14)
                  : CbsColors.primaryBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: smallStyle18.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: isDark
                        ? CbsColors.darkTextPrimary
                        : CbsColors.primaryBrown,
                  ),
                ),
                if ((subtitle ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: smallStyle18.copyWith(
                      fontSize: 14,
                      color: isDark
                          ? CbsColors.darkTextSecondary
                          : CbsColors.hintColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

class CampusStatTile extends StatelessWidget {
  const CampusStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CampusCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? CbsColors.brandGold.withValues(alpha: 0.12)
                  : CbsColors.goldPale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: smallStyle18.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? CbsColors.darkTextPrimary
                        : CbsColors.primaryBrown,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: smallStyle18.copyWith(
                    fontSize: 12,
                    color: isDark
                        ? CbsColors.darkTextSecondary
                        : CbsColors.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CampusHeroBanner extends StatelessWidget {
  const CampusHeroBanner({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String badge;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [CbsColors.darkSurface, const Color(0xFF2A1608)]
              : [CbsColors.primaryBrown, const Color(0xFF6B3F15)],
        ),
        boxShadow: [
          BoxShadow(
            color: CbsColors.primaryBrown.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CbsColors.brandGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: CbsColors.brandGold.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: smallStyle18.copyWith(
                      color: CbsColors.brandGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: smallStyle18.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: smallStyle18.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 16),
            trailing!,
          ],
        ],
      ),
    );
  }
}
