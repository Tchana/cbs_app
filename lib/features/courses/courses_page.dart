import 'dart:math' as math;

import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/assignments/assignment_page.dart';
import 'package:center_for_biblical_studies/features/assignments/course_assignments_page.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_shell_controller.dart';
import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  final DataController dataController = Get.find<DataController>();
  final SupabaseService apiService = SupabaseService();

  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  int _widgetIndex = 0;
  int _desktopPage = 0;
  CourseData? selectedCourse;
  Worker? _searchWorker;
  Worker? _pendingCourseWorker;
  DesktopShellController? _shellController;
  bool _inlineSearchEnabled = false;

  Future<void> fetchData() async {
    try {
      final courses = await apiService.fetchCourses();
      dataController.setCourses(courses);
    } catch (_) {}
  }

  DesktopShellController get _shell => _shellController!;

  @override
  void initState() {
    super.initState();
    _shellController = ensureDesktopShellController();
    fetchData();
    _searchWorker = ever<String>(_shell.searchQuery, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _desktopPage = 0);
      });
    });
    _pendingCourseWorker = ever<CourseData?>(_shell.pendingCourse, (course) {
      if (course == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !Adaptive.isDesktop(context)) return;
        final l10n = AppLocalizations.of(context) ??
            AppLocalizations(const Locale('fr'));
        _consumePendingCourseOpen(l10n);
      });
    });
  }

  void _configureDesktopSearch(AppLocalizations l10n) {
    if (_inlineSearchEnabled || !Adaptive.isDesktop(context)) return;
    if (_widgetIndex != 0) return;
    _inlineSearchEnabled = true;
    _shell.enableInlineSearch(l10n.searchHint);
  }

  void _openCourse(CourseData course, AppLocalizations l10n) {
    RecentAccessService.markCourseAccessed(course.id);
    if (Adaptive.isDesktop(context)) {
      _openCourseInPlace(course, l10n);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CourseDetailsPage(course: course),
      ),
    );
  }

  void _openCourseInPlace(CourseData course, AppLocalizations l10n) {
    final title = (course.title ?? '').trim();
    setState(() {
      selectedCourse = course;
      _widgetIndex = 1;
      _assignmentsCourseId = null;
      _assignmentId = null;
    });
    _shell.disableInlineSearch();
    _inlineSearchEnabled = false;
    _shell.setDetailHeader(
      title.isNotEmpty ? title : l10n.courseDefault,
      onBack: _closeCourseDetail,
    );
  }

  String? _assignmentsCourseId;
  String? _assignmentId;

  void _openAssignmentsInPlace(String courseId, AppLocalizations l10n) {
    setState(() {
      _assignmentsCourseId = courseId;
      _assignmentId = null;
      _widgetIndex = 2;
    });
    _shell.setDetailHeader(
      l10n.assignmentsTitle,
      onBack: _closeAssignments,
    );
  }

  void _openAssignmentInPlace(String assignmentId, AppLocalizations l10n) {
    setState(() {
      _assignmentId = assignmentId;
      _widgetIndex = 3;
    });
    _shell.setDetailHeader(
      l10n.assignmentTitleFallback,
      onBack: _closeAssignment,
    );
  }

  void _closeAssignment() {
    if (!mounted) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    setState(() {
      _widgetIndex = 2;
      _assignmentId = null;
    });
    _shell.setDetailHeader(
      l10n.assignmentsTitle,
      onBack: _closeAssignments,
    );
  }

  void _closeAssignments() {
    if (!mounted) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    setState(() {
      _widgetIndex = 1;
      _assignmentsCourseId = null;
    });
    final title = (selectedCourse?.title ?? '').trim();
    _shell.setDetailHeader(
      title.isNotEmpty ? title : l10n.courseDefault,
      onBack: _closeCourseDetail,
    );
  }

  void _closeCourseDetail() {
    if (!mounted) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    setState(() {
      _widgetIndex = 0;
      selectedCourse = null;
      _assignmentsCourseId = null;
      _assignmentId = null;
    });
    _shell.clearDetailHeader();
    _shell.enableInlineSearch(l10n.searchHint);
    _inlineSearchEnabled = true;
  }

  void _consumePendingCourseOpen(AppLocalizations l10n) {
    if (!Adaptive.isDesktop(context)) return;
    final pending = _shell.takePendingCourse();
    if (pending != null) {
      _openCourseInPlace(pending, l10n);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!Adaptive.isDesktop(context)) return;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _configureDesktopSearch(l10n);
      _consumePendingCourseOpen(l10n);
    });
  }

  @override
  void dispose() {
    _searchWorker?.dispose();
    _pendingCourseWorker?.dispose();
    if (Get.isRegistered<DesktopShellController>()) {
      if (_shell.hasDetailHeader) {
        _shell.clearDetailHeader();
      }
      _shell.disableInlineSearch();
    }
    _inlineSearchEnabled = false;
    _tabController.dispose();
    super.dispose();
  }

  List<CourseData> _filterCourses(List<CourseData> courses, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return courses;

    return courses.where((course) {
      final title = (course.title ?? '').toLowerCase();
      final description = (course.description ?? '').toLowerCase();
      final teacher = course.teacher;
      final teacherName =
          '${teacher?.firstName ?? ''} ${teacher?.lastName ?? ''}'.trim().toLowerCase();
      return title.contains(q) ||
          description.contains(q) ||
          teacherName.contains(q);
    }).toList();
  }

  int _desktopPageSize(BuildContext context) =>
      Adaptive.courseColumns(context) * 2;

  int _totalDesktopPages(BuildContext context, int itemCount) {
    if (itemCount == 0) return 1;
    return (itemCount / _desktopPageSize(context)).ceil();
  }

  List<CourseData> _paginatedCourses(
    BuildContext context,
    List<CourseData> courses, {
    required int page,
  }) {
    final pageSize = _desktopPageSize(context);
    final totalPages = _totalDesktopPages(context, courses.length);
    final safePage = page.clamp(0, math.max(0, totalPages - 1)).toInt();
    final start = safePage * pageSize;
    if (start >= courses.length) return const [];
    final end = math.min(start + pageSize, courses.length);
    return courses.sublist(start, end);
  }

  void _setDesktopPage(int page, int totalPages) {
    setState(() {
      _desktopPage = page.clamp(0, math.max(0, totalPages - 1)).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Adaptive.isDesktop(context);

    return Obx(() {
      final filtered = _filterCourses(
        dataController.courses,
        _shell.searchQuery.value,
      );
      final totalPages = _totalDesktopPages(context, filtered.length);
      final effectivePage =
          _desktopPage.clamp(0, math.max(0, totalPages - 1)).toInt();
      final visibleCourses = isDesktop
          ? _paginatedCourses(context, filtered, page: effectivePage)
          : filtered;

      return Scaffold(
        backgroundColor:
            isDark ? CbsColors.darkBg : CbsColors.backgroundColor,
        appBar: isDesktop
            ? null
            : AppBar(
                title: Text(
                  _widgetIndex == 0
                      ? l10n.navCourses
                      : (selectedCourse?.title?.trim().isNotEmpty == true
                          ? selectedCourse!.title!
                          : l10n.courseDefault),
                  style: smallStyle18.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: false,
                leading: _widgetIndex == 0
                    ? null
                    : IconButton(
                        onPressed: _closeCourseDetail,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                actions: _widgetIndex == 0
                    ? [
                        IconButton(
                          onPressed: fetchData,
                          icon: const Icon(Icons.refresh_rounded),
                          tooltip: l10n.refresh,
                        ),
                      ]
                    : null,
              ),
        body: SafeArea(
          child: DesktopPageFrame(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 20 : 20,
              vertical: 8,
            ),
            child: IndexedStack(
              index: _widgetIndex,
              children: [
                isDesktop
                    ? _buildDesktopCoursesBody(
                        context,
                        l10n,
                        isDark,
                        visibleCourses,
                        filtered.length,
                        totalPages,
                        effectivePage,
                      )
                    : _buildMobileCoursesBody(
                        context,
                        l10n,
                        isDark,
                        dataController.courses,
                      ),
                LessonPage(
                  key: ValueKey(selectedCourse?.id ?? 'course-detail'),
                  courseData: selectedCourse,
                  onBack: _closeCourseDetail,
                  onOpenAssignments: isDesktop
                      ? (courseId) => _openAssignmentsInPlace(courseId, l10n)
                      : null,
                ),
                if (_assignmentsCourseId != null)
                  CourseAssignmentsPage(
                    courseId: _assignmentsCourseId!,
                    embedded: isDesktop,
                    onOpenAssignment: isDesktop
                        ? (assignmentId) =>
                            _openAssignmentInPlace(assignmentId, l10n)
                        : null,
                  )
                else
                  const SizedBox.shrink(),
                if (_assignmentId != null)
                  AssignmentPage(
                    assignmentId: _assignmentId!,
                    embedded: isDesktop,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDesktopCoursesBody(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    List<CourseData> courses,
    int totalMatches,
    int totalPages,
    int currentPage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (totalMatches == 0)
          Expanded(
            child: Center(
              child: Text(
                l10n.noItemsFound,
                style: smallStyle18.copyWith(
                  color: isDark
                      ? CbsColors.darkTextSecondary
                      : CbsColors.hintColor,
                ),
              ),
            ),
          )
        else ...[
          Expanded(child: _coursesGrid(courses)),
          _CoursesPaginationBar(
            currentPage: currentPage,
            totalPages: totalPages,
            l10n: l10n,
            isDark: isDark,
            onPrevious: currentPage > 0
                ? () => _setDesktopPage(currentPage - 1, totalPages)
                : null,
            onNext: currentPage < totalPages - 1
                ? () => _setDesktopPage(currentPage + 1, totalPages)
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildMobileCoursesBody(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    List<CourseData> courses,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark
                ? CbsColors.darkElevated
                : CbsColors.primaryBrown.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? CbsColors.darkBorder.withValues(alpha: 0.9)
                  : CbsColors.primaryBrown.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: TabBar(
            tabAlignment: TabAlignment.fill,
            dividerHeight: 0,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color:
                            CbsColors.primaryBrown.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            labelColor: isDark ? CbsColors.brownNight : CbsColors.white,
            unselectedLabelColor: isDark
                ? CbsColors.caramel
                : CbsColors.primaryBrown.withValues(alpha: 0.85),
            labelStyle: smallStyle18.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: smallStyle18.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: isDark
                  ? CbsColors.caramel
                  : CbsColors.primaryBrown.withValues(alpha: 0.85),
            ),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 6,
            ),
            padding: EdgeInsets.zero,
            tabs: [
              Tab(text: l10n.tabAll),
              Tab(text: l10n.tabInProgress),
              Tab(text: l10n.tabCompleted),
            ],
          ),
        ),
        gapH10,
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _coursesGrid(courses),
              _coursesGrid(courses),
              _coursesGrid(courses),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coursesGrid(List<CourseData> courses) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    void open(CourseData course) => _openCourse(course, l10n);

    final columns = Adaptive.courseColumns(context);
    if (columns == 1) {
      return ListView(
        children: courses
            .map(
              (course) => CourseCard(
                courseData: course,
                onPressed: () => open(course),
              ),
            )
            .toList(),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: courses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        mainAxisExtent: 243,
      ),
      itemBuilder: (_, i) => CourseCard(
        courseData: courses[i],
        onPressed: () => open(courses[i]),
      ),
    );
  }
}

class _CoursesPaginationBar extends StatelessWidget {
  const _CoursesPaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.l10n,
    required this.isDark,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final disabled = isDark
        ? CbsColors.darkTextSecondary.withValues(alpha: 0.45)
        : CbsColors.hintColor.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            icon: Icons.chevron_left_rounded,
            onPressed: onPrevious,
            accent: accent,
            disabled: disabled,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? CbsColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isDark
                    ? CbsColors.darkBorder.withValues(alpha: 0.9)
                    : CbsColors.creamDark,
              ),
            ),
            child: Text(
              l10n.pageCounter(currentPage + 1, totalPages),
              style: smallStyle18.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryBrown,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _PaginationButton(
            icon: Icons.chevron_right_rounded,
            onPressed: onNext,
            accent: accent,
            disabled: disabled,
          ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.icon,
    required this.onPressed,
    required this.accent,
    required this.disabled,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color accent;
  final Color disabled;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: enabled
                ? accent.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled
                  ? accent.withValues(alpha: 0.35)
                  : disabled.withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: enabled ? accent : disabled,
          ),
        ),
      ),
    );
  }
}

class _CourseDetailsPage extends StatelessWidget {
  const _CourseDetailsPage({required this.course});
  final CourseData course;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = (course.title ?? '').trim();
    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkBg : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          title.isNotEmpty ? title : l10n.courseDefault,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: DesktopPageFrame(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: LessonPage(
            courseData: course,
          ),
        ),
      ),
    );
  }
}
