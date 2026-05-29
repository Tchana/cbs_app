// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignmentPage extends StatefulWidget {
  final String assignmentId;

  const AssignmentPage({super.key, required this.assignmentId});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final SupabaseService _apiService = SupabaseService();

  late Future<Map<String, dynamic>> _detailsFuture;
  late Future<Map<String, dynamic>?> _submissionFuture;

  Map<String, dynamic>? _details;

  // Answers state (only used when submission doesn't exist yet).
  final _selectedOptionByQuestionId = <String, String?>{};
  final _openPdfByQuestionId = <String, File?>{};

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _detailsFuture = _apiService.fetchAssignmentDetails(widget.assignmentId);
    _submissionFuture =
        _apiService.fetchMySubmissionForAssignment(widget.assignmentId);
  }

  void _initAnswerStateIfNeeded(List<Map<String, dynamic>> questions) {
    for (final q in questions) {
      final qid = q['id']?.toString();
      if (qid == null) continue;

      if (!_selectedOptionByQuestionId.containsKey(qid)) {
        _selectedOptionByQuestionId[qid] = null;
      }
      if (!_openPdfByQuestionId.containsKey(qid)) {
        _openPdfByQuestionId[qid] = null;
      }
    }
  }

  Future<void> _pickOpenPdf(String questionId) async {
    final res = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (res == null || res.files.isEmpty) return;
    final path = res.files.single.path;
    if (path == null || path.isEmpty) return;

    final file = File(path);
    setState(() {
      _openPdfByQuestionId[questionId] = file;
    });
  }

  Future<void> _submit() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    if (_details == null) return;
    final questions = (_details!['questions'] as List).cast<Map<String, dynamic>>();

    // Validate MCQ answers (single-choice).
    for (final q in questions) {
      final qid = q['id']?.toString();
      final type = (q['type'] ?? '').toString();
      if (qid == null) continue;

      if (type == 'mcq_single') {
        final selected = _selectedOptionByQuestionId[qid];
        if (selected == null || selected.toString().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.assignmentAnswerAllMcq)),
          );
          return;
        }
      }
    }

    setState(() => _submitting = true);
    try {
      await _apiService.submitAssignment(
        assignmentId: widget.assignmentId,
        questions: questions,
        selectedOptionByQuestionId: _selectedOptionByQuestionId,
        openPdfByQuestionId: _openPdfByQuestionId,
      );

      // Refresh.
      final newSubmission =
          await _apiService.fetchMySubmissionForAssignment(widget.assignmentId);

      if (newSubmission != null) {
        _reload();
        if (mounted) setState(() {});
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _details?['assignment']?['title']?.toString() ??
              l10n.assignmentTitleFallback,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>?>>(
          future:
              Future.wait<Map<String, dynamic>?>([_detailsFuture, _submissionFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final results = snapshot.data;
            final details = results?[0];
            final submission = results?[1];

            if (details == null) {
              return Center(child: Text(l10n.assignmentNotFound));
            }

            _details = details;

            final assignment = details['assignment'] as Map<String, dynamic>;
            final pdfUrl = assignment['pdf_url']?.toString();
            final questions = (details['questions'] as List)
                .cast<Map<String, dynamic>>();
            final dataController =
                Get.isRegistered<DataController>() ? Get.find<DataController>() : null;
            final canSubmitAssignments =
                dataController?.canSubmitAssignments ?? true;
            final isSuspended = dataController?.isSuspended ?? false;

            _initAnswerStateIfNeeded(questions);

            final answersByQuestionId =
                (submission?['answers_by_question_id'] as Map<String, dynamic>?) ??
                    <String, dynamic>{};

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (pdfUrl != null && pdfUrl.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.assignmentPdfLabel,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: CbsColors.primaryBrown,
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        openRemoteFile(pdfUrl);
                      },
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(
                        l10n.assignmentOpenPdf,
                        style: smallStyle18.copyWith(
                          color: CbsColors.primaryBrown,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                Text(
                  assignment['description']?.toString() ?? '',
                  style: smallStyle18.copyWith(
                    color: CbsColors.hintColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                if (submission == null && !canSubmitAssignments) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      isSuspended
                          ? l10n.assignmentSubmissionSuspended
                          : l10n.assignmentSubmissionDowngraded,
                      style: smallStyle18.copyWith(
                        color: CbsColors.primaryDark[800],
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                ...questions.map((q) {
                  final qid = q['id']?.toString() ?? '';
                  final type = (q['type'] ?? '').toString();
                  final prompt = q['prompt']?.toString() ?? '';

                  if (type == 'mcq_single') {
                    final options =
                        (q['options'] as List).cast<Map<String, dynamic>>();
                    final selected = _selectedOptionByQuestionId[qid];

                    final answer = answersByQuestionId[qid] as Map<String, dynamic>?;
                    final submittedSelected =
                        answer?['selected_option_id']?.toString();
                    final mcqScore = answer?['mcq_points_awarded'];
                    final showGrade = submission != null;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
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
                            prompt,
                            style: smallStyle18.copyWith(
                              fontWeight: FontWeight.w700,
                              color: CbsColors.primaryDark[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...options.map((o) {
                            final optionId = o['id']?.toString() ?? '';
                            final optionText = o['option_text']?.toString() ?? '';
                            final groupVal =
                                showGrade ? submittedSelected : selected;
                            return RadioListTile<String>(
                              value: optionId,
                              groupValue: groupVal,
                              title: Text(optionText),
                              dense: true,
                              onChanged: submission != null || !canSubmitAssignments
                                  ? null
                                  : (v) {
                                      setState(() {
                                        _selectedOptionByQuestionId[qid] = v;
                                      });
                                    },
                            );
                          },
                          ),
                          if (showGrade) ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.assignmentMcqPoints('${mcqScore ?? 0}'),
                              style: smallStyle18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: CbsColors.primaryBrown,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  // open_pdf
                  final answer = answersByQuestionId[qid] as Map<String, dynamic>?;
                  final studentPdfUrl = answer?['student_answer_pdf_url']?.toString();
                  final teacherPoints = answer?['teacher_points'];
                  final teacherFeedback = answer?['teacher_feedback']?.toString();

                  final pickedFile = _openPdfByQuestionId[qid];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
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
                          prompt,
                          style: smallStyle18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: CbsColors.primaryDark[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (submission == null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pickedFile != null
                                      ? l10n.assignmentPdfSelected(
                                          pickedFile.path
                                              .split(RegExp(r'[\\/]'))
                                              .last,
                                        )
                                      : l10n.assignmentNoPdfSelectedOptional,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed:
                                    canSubmitAssignments ? () => _pickOpenPdf(qid) : null,
                                icon: const Icon(Icons.upload_file_rounded),
                                label: Text(l10n.uploadPdf),
                              ),
                            ],
                          ),
                        ] else ...[
                          if (studentPdfUrl != null && studentPdfUrl.isNotEmpty) ...[
                            TextButton.icon(
                              onPressed: () {
                                openRemoteFile(studentPdfUrl);
                              },
                              icon: const Icon(Icons.picture_as_pdf_outlined),
                              label: Text(l10n.openSubmittedPdf),
                            ),
                          ] else ...[
                            Text(
                              l10n.assignmentNoPdfSubmitted,
                              style: smallStyle18.copyWith(
                                color: CbsColors.hintColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                          if (teacherPoints != null) ...[
                            Text(
                              l10n.assignmentTeacherPoints(
                                teacherPoints.toString(),
                              ),
                              style: smallStyle18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: CbsColors.primaryBrown,
                              ),
                            ),
                            if (teacherFeedback != null && teacherFeedback.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                l10n.assignmentFeedbackPrefix(teacherFeedback),
                                style: smallStyle18.copyWith(
                                  color: CbsColors.primaryDark[800],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ] else ...[
                            Text(
                              l10n.assignmentWaitingReview,
                              style: smallStyle18.copyWith(
                                color: CbsColors.hintColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  );
                }),

                if (submission != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'MCQ score total: ${submission['mcq_score_total'] ?? 0}',
                    style: smallStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.assignmentFinalScoreTotal(
                      '${submission['final_score_total'] ?? 0}',
                    ),
                    style: smallStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CbsColors.primaryDark[800],
                    ),
                  ),
                ],

                const SizedBox(height: 18),
                if (submission == null)
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          _submitting || !canSubmitAssignments ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CbsColors.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.submit),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

