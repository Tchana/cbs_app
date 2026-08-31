import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_shell_controller.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DesktopNavDestination {
  const DesktopNavDestination({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

/// School-platform shell: university sidebar, academic top bar, ivory canvas.
class DesktopShell extends StatelessWidget {
  const DesktopShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.child,
    this.onSearch,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<DesktopNavDestination> destinations;
  final Widget child;
  final VoidCallback? onSearch;

  String _userLabel() {
    final user = AuthService.currentUser;
    final meta = user?.userMetadata ?? {};
    final first = (meta['first_name'] ?? '').toString().trim();
    final last = (meta['last_name'] ?? '').toString().trim();
    final combined = '$first $last'.trim();
    if (combined.isNotEmpty) return combined;
    final email = user?.email ?? '';
    if (email.contains('@')) return email.split('@').first;
    return email;
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final extended = width >= 1180;
    final title = destinations[currentIndex].label;
    final date = DateFormat.yMMMMEEEEd(l10n.locale.languageCode)
        .format(DateTime.now());
    final userLabel = _userLabel();
    final initials = userLabel.isEmpty
        ? 'S'
        : userLabel
            .split(' ')
            .where((p) => p.isNotEmpty)
            .take(2)
            .map((p) => p[0].toUpperCase())
            .join();

    final railBg = isDark ? const Color(0xFF140C06) : CbsColors.primaryBrown;
    final canvasBg = isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6);

    return Scaffold(
      backgroundColor: canvasBg,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: extended ? 268 : 92,
            decoration: BoxDecoration(
              color: railBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(6, 0),
                ),
              ],
            ),
            child: SafeArea(
              right: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      extended ? 18 : 12,
                      22,
                      extended ? 18 : 12,
                      18,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: CbsColors.brandGold.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/cbs_logo.png',
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.menu_book_rounded,
                              color: CbsColors.brandGold,
                            ),
                          ),
                        ),
                        if (extended) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.appName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: smallStyle18.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.defaultStudentName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.brandGold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.12),
                      height: 1,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final dest = destinations[index];
                        final selected = index == currentIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () => onDestinationSelected(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      width: 3,
                                      color: selected
                                          ? CbsColors.brandGold
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: extended ? 12 : 0,
                                  vertical: 12,
                                ),
                                child: extended
                                    ? Row(
                                        children: [
                                          Icon(
                                            dest.icon,
                                            size: 20,
                                            color: selected
                                                ? CbsColors.brandGold
                                                : Colors.white
                                                    .withValues(alpha: 0.82),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              dest.label,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: smallStyle18.copyWith(
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withValues(alpha: 0.8),
                                                fontWeight: selected
                                                    ? FontWeight.w800
                                                    : FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Icon(
                                            dest.icon,
                                            size: 22,
                                            color: selected
                                                ? CbsColors.brandGold
                                                : Colors.white
                                                    .withValues(alpha: 0.82),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            dest.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: selected
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: selected
                                                  ? CbsColors.brandGold
                                                  : Colors.white
                                                      .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (extended)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: CbsColors.brandGold,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  color: Color(0xFF2C1A08),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                userLabel.isEmpty
                                    ? l10n.defaultStudentName
                                    : userLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: smallStyle18.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: isDark ? CbsColors.darkSurface : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? CbsColors.darkBorder
                            : CbsColors.creamDark,
                      ),
                    ),
                  ),
                  child: Obx(() {
                    final shell = ensureDesktopShellController();
                    final inlineSearch = shell.inlineSearchEnabled.value;
                    final detailTitle = shell.detailTitle.value;
                    final hasDetail = (detailTitle ?? '').trim().isNotEmpty;

                    return Row(
                      children: [
                        if (hasDetail) ...[
                          IconButton(
                            onPressed: shell.goBackFromDetail,
                            icon: const Icon(Icons.arrow_back_rounded),
                            tooltip: MaterialLocalizations.of(context)
                                .backButtonTooltip,
                            color: isDark
                                ? CbsColors.brandGold
                                : CbsColors.primaryBrown,
                          ),
                          Expanded(
                            child: Text(
                              detailTitle!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: smallStyle18.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? CbsColors.darkTextPrimary
                                    : CbsColors.primaryBrown,
                              ),
                            ),
                          ),
                        ] else if (inlineSearch)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                child: _InlineSearchField(
                                  controller: shell.searchController,
                                  hint: shell.searchHint.value.isNotEmpty
                                      ? shell.searchHint.value
                                      : l10n.searchHint,
                                  isDark: isDark,
                                ),
                              ),
                            ),
                          )
                        else if (currentIndex == 0 && onSearch != null)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 440),
                                child: _TopSearchField(
                                  hint: l10n.searchHint,
                                  isDark: isDark,
                                  onTap: onSearch!,
                                ),
                              ),
                            ),
                          )
                        else ...[
                          Icon(
                            destinations[currentIndex].icon,
                            color: isDark
                                ? CbsColors.brandGold
                                : CbsColors.primaryBrown,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            title,
                            style: smallStyle18.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? CbsColors.darkTextPrimary
                                  : CbsColors.primaryBrown,
                            ),
                          ),
                          const Spacer(),
                        ],
                        if (inlineSearch ||
                            (currentIndex == 0 && onSearch != null))
                          const SizedBox(width: 16),
                      Text(
                        date,
                        style: smallStyle18.copyWith(
                          fontSize: 13,
                          color: isDark
                              ? CbsColors.darkTextSecondary
                              : CbsColors.hintColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: isDark
                              ? CbsColors.brandGold.withValues(alpha: 0.2)
                              : CbsColors.goldPale,
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: isDark
                                  ? CbsColors.brandGold
                                  : CbsColors.primaryBrown,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Expanded(
                  child: ColoredBox(
                    color: canvasBg,
                    child: child,
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

class _InlineSearchField extends StatelessWidget {
  const _InlineSearchField({
    required this.controller,
    required this.hint,
    required this.isDark,
  });

  final TextEditingController controller;
  final String hint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: smallStyle18.copyWith(
        fontSize: 14,
        color: isDark ? CbsColors.darkTextPrimary : CbsColors.primaryBrown,
      ),
      cursorColor: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6),
        hintText: hint,
        hintStyle: smallStyle18.copyWith(
          fontSize: 14,
          color: isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 20,
          color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(
                Icons.clear_rounded,
                size: 18,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
              onPressed: controller.clear,
              tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
            );
          },
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark
                ? CbsColors.brandGold.withValues(alpha: 0.45)
                : CbsColors.primaryBrown.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

class _TopSearchField extends StatelessWidget {
  const _TopSearchField({
    required this.hint,
    required this.isDark,
    required this.onTap,
  });

  final String hint;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hint,
                  style: smallStyle18.copyWith(
                    fontSize: 14,
                    color: isDark
                        ? CbsColors.darkTextSecondary
                        : CbsColors.hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
