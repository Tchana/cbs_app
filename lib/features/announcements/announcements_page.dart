import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({
    super.key,
    SupabaseService? apiService,
  }) : apiService = apiService ?? const SupabaseService.testable();

  final SupabaseService apiService;

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.apiService.fetchVisibleAnnouncements(limit: 100);
    _markAllReadInBackground();
  }

  Future<void> _markAllReadInBackground() async {
    try {
      final items = await widget.apiService.fetchVisibleAnnouncements(limit: 100);
      final ids = items
          .map((a) => a['id']?.toString())
          .whereType<String>()
          .toList();
      await widget.apiService.markAnnouncementsAsRead(ids);
    } catch (_) {
      // Ignore silently; reading state is non-blocking.
    }
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.apiService.fetchVisibleAnnouncements(limit: 100);
    });
    await _markAllReadInBackground();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CbsColors.darkBg : CbsColors.backgroundColor;
    final cardBg = isDark ? CbsColors.darkSurface : Colors.white;
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.16);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final bodyColor =
        isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor;
    final metaColor =
        isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;
    final accent = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: DesktopPageFrame(
          padding: EdgeInsets.zero,
          child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                ),
              );
            }

            final items = snapshot.data ?? const <Map<String, dynamic>>[];
            if (items.isEmpty) {
              return RefreshIndicator(
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                onRefresh: _reload,
                child: ListView(
                  children: [
                    const SizedBox(height: 180),
                    Center(
                      child: Text(
                        l10n.noAnnouncementsYet,
                        style: smallStyle18.copyWith(color: bodyColor),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              onRefresh: _reload,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final a = items[i];
                  final title = (a['title'] ?? '').toString();
                  final body = (a['body'] ?? '').toString();
                  final createdAt = a['created_at']?.toString();
                  final courseMap =
                      a['course'] is Map<String, dynamic> ? a['course'] as Map<String, dynamic> : null;
                  final courseTitle = (courseMap?['title'] ?? '').toString();
                  final when = createdAt == null
                      ? ''
                      : DateFormat.yMMMd().add_jm().format(
                            DateTime.tryParse(createdAt)?.toLocal() ??
                                DateTime.now(),
                          );

                  final displayTitle =
                      title.isEmpty ? l10n.announcementFallback : title;

                  return Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Accent rail
                          Container(
                            width: 4,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 12, 14, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? CbsColors.darkElevated
                                              : CbsColors.primaryBrown
                                                  .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: isDark
                                              ? Border.all(
                                                  color: CbsColors.darkBorder
                                                      .withValues(alpha: 0.9),
                                                )
                                              : null,
                                        ),
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          size: 18,
                                          color: accent,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          displayTitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: smallStyle18.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: titleColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        when,
                                        style: verySmallStyle12.copyWith(
                                          color: metaColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    body,
                                    style: smallStyle18.copyWith(
                                      height: 1.35,
                                      color: bodyColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (courseTitle.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? CbsColors.darkElevated
                                              : CbsColors.primaryBrown
                                                  .withValues(alpha: 0.10),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          border: isDark
                                              ? Border.all(
                                                  color: CbsColors.darkBorder
                                                      .withValues(alpha: 0.9),
                                                )
                                              : null,
                                        ),
                                        child: Text(
                                          courseTitle,
                                          style: verySmallStyle12.copyWith(
                                            color: isDark
                                                ? CbsColors.darkTextSecondary
                                                : CbsColors.primaryBrown,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}

