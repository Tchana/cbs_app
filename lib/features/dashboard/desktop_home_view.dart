import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:center_for_biblical_studies/shared/cached_remote_image.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({
    super.key,
    required this.greeting,
    required this.today,
    required this.unreadAnnouncements,
    required this.latestAnnouncement,
    required this.announcements,
    required this.verseText,
    required this.verseRef,
    required this.verseLoading,
    required this.recentAccess,
    required this.onRefresh,
    required this.onSearch,
    required this.onOpenAnnouncements,
    required this.onOpenCourse,
    required this.onOpenBook,
    required this.onOpenTeacher,
    required this.onSeeAllTeachers,
    required this.onContactTeacher,
  });

  final String greeting;
  final String today;
  final int unreadAnnouncements;
  final Map<String, dynamic>? latestAnnouncement;
  final List<Map<String, dynamic>> announcements;
  final String? verseText;
  final String? verseRef;
  final bool verseLoading;
  final List<RecentAccessItem> recentAccess;
  final Future<void> Function() onRefresh;
  final VoidCallback onSearch;
  final VoidCallback onOpenAnnouncements;
  final void Function(CourseData course) onOpenCourse;
  final void Function(LibraryData book) onOpenBook;
  final void Function(RegisterData teacher) onOpenTeacher;
  final VoidCallback onSeeAllTeachers;
  final void Function(RegisterData teacher) onContactTeacher;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? CbsColors.darkBg : const Color(0xFFF7F4EE);

    return ColoredBox(
      color: pageBg,
      child: Obx(() {
        final dc = Get.find<DataController>();
        final allCourses = dc.courses.toList(growable: false);
        final enrolled = allCourses
            .where((c) => c.isEnrolled == true)
            .toList(growable: false);
        final courses = enrolled.isNotEmpty ? enrolled : allCourses;
        final teachers = dc.teachers.toList(growable: false);
        final books = _recentBooks(dc.books.toList(growable: false));

        return RefreshIndicator(
          color: CbsColors.primaryBrown,
          onRefresh: onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _WelcomeBanner(
                  greeting: greeting,
                  today: today,
                  verseText: verseText,
                  verseRef: verseRef,
                  verseLoading: verseLoading,
                  l10n: l10n,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 36),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _BlockTitle(
                              '${l10n.enrolled} · ${l10n.navCourses}',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _EnrolledCourses(
                              l10n: l10n,
                              isDark: isDark,
                              courses: courses,
                              onOpen: onOpenCourse,
                            ),
                            const SizedBox(height: 28),
                            _BlockTitle(l10n.tabBooks, isDark: isDark),
                            const SizedBox(height: 12),
                            _RecentBooks(
                              l10n: l10n,
                              isDark: isDark,
                              books: books,
                              onOpen: onOpenBook,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _BlockTitle(
                              l10n.teachersSection,
                              isDark: isDark,
                              actionLabel: l10n.seeAll,
                              onAction: onSeeAllTeachers,
                            ),
                            const SizedBox(height: 12),
                            _TeachersRow(
                              l10n: l10n,
                              isDark: isDark,
                              teachers: teachers,
                              onOpen: onOpenTeacher,
                            ),
                            const SizedBox(height: 28),
                            _BlockTitle(
                              l10n.notificationsTitle,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _NotificationsCard(
                              l10n: l10n,
                              isDark: isDark,
                              announcements: announcements,
                              onViewAll: onOpenAnnouncements,
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
      }),
    );
  }

  List<LibraryData> _recentBooks(List<LibraryData> all) {
    final byId = {
      for (final b in all)
        if ((b.id ?? '').trim().isNotEmpty) b.id!.trim(): b,
    };
    final picked = <LibraryData>[];
    for (final entry in recentAccess) {
      if (entry.kind != RecentAccessKind.book) continue;
      final book = byId[entry.id];
      if (book == null) continue;
      picked.add(book);
      if (picked.length == 3) return picked;
    }
    for (final book in all) {
      if (picked.any((b) => b.id == book.id)) continue;
      picked.add(book);
      if (picked.length == 3) break;
    }
    return picked;
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({
    required this.greeting,
    required this.today,
    required this.verseText,
    required this.verseRef,
    required this.verseLoading,
    required this.l10n,
  });

  final String greeting;
  final String today;
  final String? verseText;
  final String? verseRef;
  final bool verseLoading;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      padding: const EdgeInsets.fromLTRB(32, 22, 16, 22),
      decoration: BoxDecoration(
        color: const Color(0xFF3D240C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: smallStyle18.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  today,
                  style: smallStyle18.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                if (verseLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CbsColors.brandGold,
                    ),
                  )
                else
                  Text(
                    [
                      if ((verseText ?? '').isNotEmpty) verseText!,
                      if ((verseRef ?? '').isNotEmpty) verseRef!,
                    ].join(' — '),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: smallStyle18.copyWith(
                      color: CbsColors.brandGold,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/home_banner_3d.png',
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.menu_book_rounded,
              size: 88,
              color: CbsColors.brandGold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle(
    this.text, {
    required this.isDark,
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final bool isDark;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: smallStyle18.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF2A1608),
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor:
                  isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel!,
              style: smallStyle18.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}

class _EnrolledCourses extends StatelessWidget {
  const _EnrolledCourses({
    required this.l10n,
    required this.isDark,
    required this.courses,
    required this.onOpen,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final List<CourseData> courses;
  final void Function(CourseData) onOpen;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Text(
        l10n.noItemsFound,
        style: smallStyle18.copyWith(color: CbsColors.hintColor),
      );
    }
    final visible = courses.take(3).toList();
    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(
              child: _CourseCard(
                l10n: l10n,
                isDark: isDark,
                course: visible[i],
                onOpen: onOpen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.l10n,
    required this.isDark,
    required this.course,
    required this.onOpen,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final CourseData course;
  final void Function(CourseData) onOpen;

  @override
  Widget build(BuildContext context) {
    final teacher =
        '${course.teacher?.firstName ?? ''} ${course.teacher?.lastName ?? ''}'
            .trim();

    return Material(
      color: isDark ? CbsColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOpen(course),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: isDark ? const Color(0xFF2A1608) : const Color(0xFFF3E6C8),
              child: SizedBox(
                height: 88,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/course_card_3d.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.menu_book_rounded,
                      color: CbsColors.brandGold,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title ?? l10n.courseDefault,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.25,
                        color: isDark ? Colors.white : const Color(0xFF2A1608),
                      ),
                    ),
                    if (teacher.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        teacher,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: smallStyle18.copyWith(
                          fontSize: 12,
                          color: CbsColors.hintColor,
                        ),
                      ),
                    ],
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => onOpen(course),
                        style: FilledButton.styleFrom(
                          backgroundColor: CbsColors.primaryBrown,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(l10n.view),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentBooks extends StatelessWidget {
  const _RecentBooks({
    required this.l10n,
    required this.isDark,
    required this.books,
    required this.onOpen,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final List<LibraryData> books;
  final void Function(LibraryData) onOpen;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Text(
        l10n.noItemsFound,
        style: smallStyle18.copyWith(color: CbsColors.hintColor),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < books.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: HomeBookCard(
              book: books[i],
              onView: () => onOpen(books[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _TeachersRow extends StatelessWidget {
  const _TeachersRow({
    required this.l10n,
    required this.isDark,
    required this.teachers,
    required this.onOpen,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final List<RegisterData> teachers;
  final void Function(RegisterData) onOpen;

  @override
  Widget build(BuildContext context) {
    if (teachers.isEmpty) {
      return Text(
        l10n.noItemsFound,
        style: smallStyle18.copyWith(color: CbsColors.hintColor),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = teachers.length;
        const gap = 12.0;
        final available = constraints.maxWidth - gap * (count - 1);
        final size = (available / count).clamp(52.0, 96.0);
        return SizedBox(
          height: size,
          child: Row(
            children: [
              for (var i = 0; i < count; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                Expanded(
                  child: Center(
                    child: _TeacherAvatar(
                      teacher: teachers[i],
                      diameter: size,
                      onTap: () => onOpen(teachers[i]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _TeacherAvatar extends StatelessWidget {
  const _TeacherAvatar({
    required this.teacher,
    required this.diameter,
    required this.onTap,
  });

  final RegisterData teacher;
  final double diameter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photo = (teacher.pImage ?? '').trim();
    final first = (teacher.firstName ?? '').trim();
    final last = (teacher.lastName ?? '').trim();
    final initials = first.isNotEmpty && last.isNotEmpty
        ? '${first[0]}${last[0]}'.toUpperCase()
        : (first.isNotEmpty
            ? first[0].toUpperCase()
            : (last.isNotEmpty ? last[0].toUpperCase() : 'T'));

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: CircleAvatar(
          radius: diameter / 2,
          backgroundColor: CbsColors.primaryBrown,
          backgroundImage:
              photo.isNotEmpty ? cachedRemoteImageProvider(photo) : null,
          child: photo.isNotEmpty
              ? null
              : Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: diameter * 0.32,
                  ),
                ),
        ),
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({
    required this.l10n,
    required this.isDark,
    required this.announcements,
    required this.onViewAll,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final List<Map<String, dynamic>> announcements;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final items = announcements.take(4).toList();
    if (items.isEmpty) {
      return Text(
        l10n.noAnnouncementsYet,
        style: smallStyle18.copyWith(color: CbsColors.hintColor),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? CbsColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ...items.map((item) {
            final title =
                (item['title'] ?? l10n.announcementFallback).toString();
            final body = (item['body'] ?? '').toString();
            return InkWell(
              onTap: onViewAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.campaign_outlined, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: smallStyle18.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          if (body.isNotEmpty)
                            Text(
                              body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: smallStyle18.copyWith(
                                fontSize: 12,
                                color: CbsColors.hintColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onViewAll,
              child: Text(l10n.viewAll),
            ),
          ),
        ],
      ),
    );
  }
}
