import 'package:center_for_biblical_studies/features/assignments/assignment_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CourseAssignmentsPage extends StatefulWidget {
  final String courseId;

  const CourseAssignmentsPage({super.key, required this.courseId});

  @override
  State<CourseAssignmentsPage> createState() => _CourseAssignmentsPageState();
}

class _CourseAssignmentsPageState extends State<CourseAssignmentsPage> {
  final SupabaseService _apiService = SupabaseService();

  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _apiService.fetchPublishedAssignmentsForCourse(widget.courseId);
  }

  Future<void> _reload() async {
    setState(() {
      _future =
          _apiService.fetchPublishedAssignmentsForCourse(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final localeName = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assignmentsTitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return Center(
                child: Text(
                  l10n.assignmentsEmpty,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return RefreshIndicator(
              color: CbsColors.primaryBrown,
              onRefresh: _reload,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final a = items[i];
                  final title = (a['title'] ?? '').toString();
                  final lessonTitle = a['lesson_title'] as String?;
                  final dueDate = a['due_date']?.toString();
                  String? dueLabel;
                  if (dueDate != null && dueDate.trim().isNotEmpty) {
                    final parsed = DateTime.tryParse(dueDate);
                    dueLabel = parsed == null
                        ? dueDate
                        : DateFormat.yMMMd(localeName).format(parsed.toLocal());
                  }

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        final assignmentId = a['id']?.toString();
                        if (assignmentId == null || assignmentId.isEmpty) {
                          return;
                        }
                        Get.to(() => AssignmentPage(assignmentId: assignmentId));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: CbsColors.primaryBrown.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: smallStyle18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: CbsColors.primaryDark[800],
                              ),
                            ),
                            if (lessonTitle != null && lessonTitle.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                l10n.lessonPrefix(lessonTitle.trim()),
                                style: smallStyle18.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: CbsColors.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (dueLabel != null && dueLabel.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                l10n.duePrefix(dueLabel),
                                style: smallStyle18.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: CbsColors.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
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

