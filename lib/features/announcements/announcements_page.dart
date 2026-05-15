import 'package:center_for_biblical_studies/services/supabase_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data ?? const <Map<String, dynamic>>[];
            if (items.isEmpty) {
              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView(
                  children: [
                    const SizedBox(height: 180),
                    Center(child: Text(l10n.noAnnouncementsYet)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
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

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? CbsColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.isEmpty ? l10n.announcementFallback : title,
                          style: smallStyle18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? CbsColors.darkText
                                : CbsColors.primaryDark[800],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          body,
                          style: smallStyle18.copyWith(
                            height: 1.35,
                            color: isDark
                                ? CbsColors.darkHint
                                : CbsColors.hintColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (courseTitle.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: CbsColors.primaryBrown
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  courseTitle,
                                  style: verySmallStyle12.copyWith(
                                    color: CbsColors.primaryBrown,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            Text(
                              when,
                              style: verySmallStyle12.copyWith(
                                color: CbsColors.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

