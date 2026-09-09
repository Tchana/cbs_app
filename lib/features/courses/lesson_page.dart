import 'package:center_for_biblical_studies/core/platform/platform_capabilities.dart';
import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/features/assignments/course_assignments_page.dart';
import 'package:center_for_biblical_studies/features/courses/inline_video_player.dart';
import 'package:center_for_biblical_studies/features/courses/video_viewer_screen.dart';
import 'package:center_for_biblical_studies/features/forum/group_chat_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/services/chat_notification_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/cached_remote_image.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/shared/remote_file_icons.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:center_for_biblical_studies/shared/rich_text_content.dart';
import 'package:center_for_biblical_studies/shared/video_url_utils.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonPage extends StatefulWidget {
  final CourseData? courseData;
  final VoidCallback? onBack;
  final void Function(String courseId)? onOpenAssignments;

  const LessonPage({
    super.key,
    this.courseData,
    this.onBack,
    this.onOpenAssignments,
  });

  static String _teacherDisplayName(
    RegisterData? teacher,
    AppLocalizations l10n,
  ) {
    if (teacher == null) return l10n.dash;
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    return name.isEmpty ? l10n.dash : name;
  }

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage>
    with SingleTickerProviderStateMixin {
  final SupabaseService _apiService = const SupabaseService();

  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  GroupData? _forumGroup;
  bool _forumLoading = false;
  String? _forumCourseTitle;

  CourseData? get _courseData => widget.courseData;

  @override
  void initState() {
    super.initState();
    _loadForumGroup();
  }

  @override
  void didUpdateWidget(covariant LessonPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldTitle = (oldWidget.courseData?.title ?? '').trim();
    final newTitle = (_courseData?.title ?? '').trim();
    if (oldTitle != newTitle) {
      _forumGroup = null;
      _forumCourseTitle = null;
      _loadForumGroup();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadForumGroup() async {
    final title = (_courseData?.title ?? '').trim();
    if (title.isEmpty) return;
    if (_forumCourseTitle == title && (_forumGroup != null || _forumLoading)) {
      return;
    }

    _forumCourseTitle = title;
    setState(() => _forumLoading = true);
    try {
      final group = await _apiService.fetchGroupForCourse(courseTitle: title);
      if (group?.uuid != null) {
        await _apiService.ensureRoomMembership(group!.uuid!);
        await ChatNotificationService.instance.refreshMemberships();
      }
      if (mounted && _forumCourseTitle == title) {
        setState(() => _forumGroup = group);
      }
    } catch (_) {
    } finally {
      if (mounted && _forumCourseTitle == title) {
        setState(() => _forumLoading = false);
      }
    }
  }

  Future<GroupData?> _createCourseDiscussion() async {
    final title = (_courseData?.title ?? '').trim();
    if (title.isEmpty) return null;
    setState(() => _forumLoading = true);
    try {
      final result =
          await _apiService.createCourseDiscussionRoom(courseTitle: title);
      if (result['success'] == true && result['data'] is GroupData) {
        final group = result['data'] as GroupData;
        await ChatNotificationService.instance.refreshMemberships();
        if (mounted) {
          setState(() {
            _forumGroup = group;
            _forumCourseTitle = title;
          });
        }
        return group;
      }
      return null;
    } catch (_) {
      return null;
    } finally {
      if (mounted) setState(() => _forumLoading = false);
    }
  }

  List<_CourseResourceEntry> _collectResources(AppLocalizations l10n) {
    final lessons = _courseData?.lessons ?? const [];
    final entries = <_CourseResourceEntry>[];

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final rawTitle = (lesson.title ?? '').trim();
      final lessonLabel = rawTitle.isEmpty
          ? '${l10n.lessonLabel} ${i + 1}'
          : '${l10n.lessonLabel} ${i + 1}: $rawTitle';

      final fromList = lesson.resources ?? const [];
      if (fromList.isNotEmpty) {
        for (final resource in fromList) {
          entries.add(
            _CourseResourceEntry(
              resource: resource,
              lessonId: lesson.id,
              lessonLabel: lessonLabel,
            ),
          );
        }
        continue;
      }

      final legacyUrl = (lesson.file ?? '').trim();
      if (legacyUrl.isEmpty) continue;

      entries.add(
        _CourseResourceEntry(
          resource: LessonResourceData(
            resourceType: 'pdf',
            title: lesson.title,
            url: legacyUrl,
            sourceKind: 'upload',
          ),
          lessonId: lesson.id,
          lessonLabel: lessonLabel,
        ),
      );
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final description = (_courseData?.description ?? '').trim();
    final learningObjectives = (_courseData?.learningObjectives ?? '').trim();
    final overviewVideos = _courseData?.overviewVideos ?? const [];
    final lessonCount = _courseData?.lessons?.length ?? 0;
    final resources = _collectResources(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CbsColors.darkSurface : CbsColors.white;
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.2);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final bodyColor =
        isDark ? CbsColors.darkTextSecondary : CbsColors.primaryDark[500];
    final tabIndicatorColor =
        isDark ? CbsColors.brandGold : CbsColors.primaryBrown;

    return DesktopPageFrame(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (description.isNotEmpty) ...[
                      Text(
                        l10n.descriptionLabel,
                        style: smallStyle18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      gapH8,
                      Text(
                        description,
                        style: verySmallStyle12.copyWith(
                          color: bodyColor,
                          height: 1.4,
                        ),
                      ),
                      gapH16,
                    ],
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.person_outline_rounded,
                          label: l10n.teacherLabel,
                          value: LessonPage._teacherDisplayName(
                            _courseData?.teacher,
                            l10n,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _InfoChip(
                          icon: Icons.menu_book_rounded,
                          label: l10n.lessonsLabel,
                          value: '$lessonCount',
                        ),
                      ],
                    ),
                    gapH16,
                    CbsButton(
                      width: double.infinity,
                      height: 50,
                      bgColor: isDark
                          ? CbsColors.primaryYellow
                          : CbsColors.primaryBrown,
                      borderColor: isDark
                          ? CbsColors.primaryYellow
                          : CbsColors.primaryBrown,
                      onPressed: () {
                        final courseId = _courseData?.id;
                        if (courseId == null) return;
                        final openInShell = widget.onOpenAssignments;
                        if (openInShell != null) {
                          openInShell(courseId);
                          return;
                        }
                        Get.to(() => CourseAssignmentsPage(courseId: courseId));
                      },
                      child: Text(
                        l10n.viewAssignments,
                        style: verySmallStyle12.copyWith(
                          color: isDark ? CbsColors.brownNight : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (overviewVideos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.overviewVideosLabel,
                        style: smallStyle18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      gapH12,
                      ...overviewVideos.map(
                        (video) => _OverviewVideoTile(
                          video: video,
                          l10n: l10n,
                          isDark: isDark,
                          borderColor: borderColor,
                          cardColor: cardColor,
                          titleColor: titleColor,
                          bodyColor: bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _LessonTabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    labelColor: tabIndicatorColor,
                    unselectedLabelColor: bodyColor,
                    indicatorColor: tabIndicatorColor,
                    labelStyle: verySmallStyle12.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: verySmallStyle12,
                    tabs: [
                      Tab(text: l10n.tabOverview),
                      Tab(text: l10n.resourcesLabel),
                      Tab(text: l10n.courseDiscussionLabel),
                    ],
                  ),
                  backgroundColor:
                      isDark ? CbsColors.darkBg : CbsColors.backgroundColor,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(
              learningObjectives: learningObjectives,
              l10n: l10n,
              titleColor: titleColor,
              bodyColor: bodyColor,
            ),
            _ResourcesTab(
              resources: resources,
              l10n: l10n,
              isDark: isDark,
              borderColor: borderColor,
              cardColor: cardColor,
              titleColor: titleColor,
              bodyColor: bodyColor,
            ),
            _DiscussionsTab(
              group: _forumGroup,
              loading: _forumLoading,
              courseTitle: (_courseData?.title ?? '').trim(),
              l10n: l10n,
              isDark: isDark,
              bodyColor: bodyColor,
              onCreateRoom: _createCourseDiscussion,
              onRoomReady: (group) {
                if (!mounted) return;
                setState(() => _forumGroup = group);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseResourceEntry {
  const _CourseResourceEntry({
    required this.resource,
    required this.lessonId,
    required this.lessonLabel,
  });

  final LessonResourceData resource;
  final String? lessonId;
  final String lessonLabel;
}

class _LessonTabBarDelegate extends SliverPersistentHeaderDelegate {
  _LessonTabBarDelegate({
    required this.tabBar,
    required this.backgroundColor,
  });

  final TabBar tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _LessonTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.learningObjectives,
    required this.l10n,
    required this.titleColor,
    required this.bodyColor,
  });

  final String learningObjectives;
  final AppLocalizations l10n;
  final Color? titleColor;
  final Color? bodyColor;

  @override
  Widget build(BuildContext context) {
    final hasObjectives = !isRichTextEmpty(learningObjectives);

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey<String>('course-overview-tab'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            if (!hasObjectives)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    l10n.notAvailable,
                    style: verySmallStyle14.copyWith(color: bodyColor),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      l10n.learningObjectivesLabel,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    gapH8,
                    RichTextContent(
                      html: learningObjectives,
                      textStyle: verySmallStyle12.copyWith(
                        color: bodyColor,
                        height: 1.4,
                      ),
                    ),
                  ]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ResourcesTab extends StatefulWidget {
  const _ResourcesTab({
    required this.resources,
    required this.l10n,
    required this.isDark,
    required this.borderColor,
    required this.cardColor,
    required this.titleColor,
    required this.bodyColor,
  });

  final List<_CourseResourceEntry> resources;
  final AppLocalizations l10n;
  final bool isDark;
  final Color borderColor;
  final Color cardColor;
  final Color? titleColor;
  final Color? bodyColor;

  @override
  State<_ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<_ResourcesTab> {
  String? _playingUrl;

  @override
  Widget build(BuildContext context) {
    final resources = widget.resources;
    final l10n = widget.l10n;
    final isDark = widget.isDark;
    final borderColor = widget.borderColor;
    final cardColor = widget.cardColor;
    final titleColor = widget.titleColor;
    final bodyColor = widget.bodyColor;

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey<String>('course-resources-tab'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            if (resources.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_open_rounded,
                        size: 48,
                        color: isDark
                            ? CbsColors.brandGold.withValues(alpha: 0.65)
                            : CbsColors.primaryBrown.withValues(alpha: 0.4),
                      ),
                      gapH12,
                      Text(
                        l10n.noResourcesYet,
                        style: verySmallStyle14.copyWith(color: bodyColor),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                sliver: SliverList.separated(
                  itemCount: resources.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = resources[index];
                    final url = (entry.resource.url ?? '').trim();
                    final isVideo = isInAppVideoResource(
                      url: url,
                      resourceType: entry.resource.resourceType,
                    );

                    if (isVideo) {
                      return _VideoResourceTile(
                        resource: entry.resource,
                        lessonLabel: entry.lessonLabel,
                        l10n: l10n,
                        isDark: isDark,
                        borderColor: borderColor,
                        cardColor: cardColor,
                        titleColor: titleColor,
                        bodyColor: bodyColor,
                        playing: (PlatformCapabilities.supportsInAppWebView ||
                                PlatformCapabilities.supportsHtmlIFrameEmbed) &&
                            _playingUrl == url &&
                            url.isNotEmpty,
                        onPlay: () {
                          if (!PlatformCapabilities.supportsInAppWebView &&
                              !PlatformCapabilities.supportsHtmlIFrameEmbed) {
                            openVideoInApp(url, title: entry.resource.title);
                            return;
                          }
                          setState(() => _playingUrl = url);
                        },
                        onStop: () {
                          if (_playingUrl == url) {
                            setState(() => _playingUrl = null);
                          }
                        },
                      );
                    }

                    return _ResourceTile(
                      resource: entry.resource,
                      lessonId: entry.lessonId,
                      lessonLabel: entry.lessonLabel,
                      l10n: l10n,
                      isDark: isDark,
                      borderColor: borderColor,
                      cardColor: cardColor,
                      titleColor: titleColor,
                      bodyColor: bodyColor,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DiscussionsTab extends StatelessWidget {
  const _DiscussionsTab({
    required this.group,
    required this.loading,
    required this.courseTitle,
    required this.l10n,
    required this.isDark,
    required this.bodyColor,
    required this.onCreateRoom,
    required this.onRoomReady,
  });

  final GroupData? group;
  final bool loading;
  final String courseTitle;
  final AppLocalizations l10n;
  final bool isDark;
  final Color? bodyColor;
  final Future<GroupData?> Function() onCreateRoom;
  final void Function(GroupData group) onRoomReady;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Widget body;
        if (loading) {
          body = Center(
            child: CircularProgressIndicator(
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          );
        } else if (group == null) {
          body = _CreateCourseDiscussionPanel(
            l10n: l10n,
            isDark: isDark,
            bodyColor: bodyColor,
            courseTitle: courseTitle,
            onCreateRoom: onCreateRoom,
            onRoomReady: onRoomReady,
          );
        } else {
          body = GroupChatPage(group: group!, embedded: true);
        }

        return CustomScrollView(
          key: const PageStorageKey<String>('course-discussions-tab'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverFillRemaining(
              hasScrollBody: group != null && !loading,
              child: body,
            ),
          ],
        );
      },
    );
  }
}

class _CreateCourseDiscussionPanel extends StatefulWidget {
  const _CreateCourseDiscussionPanel({
    required this.l10n,
    required this.isDark,
    required this.bodyColor,
    required this.courseTitle,
    required this.onCreateRoom,
    required this.onRoomReady,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final Color? bodyColor;
  final String courseTitle;
  final Future<GroupData?> Function() onCreateRoom;
  final void Function(GroupData group) onRoomReady;

  @override
  State<_CreateCourseDiscussionPanel> createState() =>
      _CreateCourseDiscussionPanelState();
}

class _CreateCourseDiscussionPanelState
    extends State<_CreateCourseDiscussionPanel> {
  bool _creating = false;

  Future<void> _create() async {
    if (_creating) return;
    setState(() => _creating = true);
    try {
      final group = await widget.onCreateRoom();
      if (!mounted) return;
      if (group != null) {
        widget.onRoomReady(group);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.l10n.courseDiscussionCreated)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.l10n.groupCreateError),
            backgroundColor: CbsColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        widget.isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 48,
              color: accent.withValues(alpha: 0.85),
            ),
            gapH12,
            Text(
              widget.l10n.courseDiscussionUnavailable,
              textAlign: TextAlign.center,
              style: verySmallStyle14.copyWith(color: widget.bodyColor),
            ),
            gapH8,
            Text(
              widget.l10n.createCourseDiscussionHint,
              textAlign: TextAlign.center,
              style: verySmallStyle12.copyWith(
                color: widget.bodyColor?.withValues(alpha: 0.9),
                height: 1.35,
              ),
            ),
            gapH20,
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.courseTitle.isEmpty || _creating
                    ? null
                    : _create,
                icon: _creating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_comment_rounded),
                label: Text(widget.l10n.createCourseDiscussion),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor:
                      widget.isDark ? CbsColors.brownNight : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewVideoTile extends StatelessWidget {
  const _OverviewVideoTile({
    required this.video,
    required this.l10n,
    required this.isDark,
    required this.borderColor,
    required this.cardColor,
    required this.titleColor,
    required this.bodyColor,
  });

  final CourseOverviewVideoData video;
  final AppLocalizations l10n;
  final bool isDark;
  final Color borderColor;
  final Color cardColor;
  final Color? titleColor;
  final Color? bodyColor;

  @override
  Widget build(BuildContext context) {
    final url = (video.url ?? '').trim();
    final label = (video.title ?? '').trim().isNotEmpty
        ? video.title!.trim()
        : l10n.watchVideo;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: url.isEmpty ? null : () => launchExternalUrl(url),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_outline_rounded,
                  size: 24,
                  color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: verySmallStyle14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                  color: bodyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? CbsColors.darkElevated
              : CbsColors.primaryBrown.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: isDark
              ? Border.all(
                  color: CbsColors.darkBorder.withValues(alpha: 0.9),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: verySmallStyle10.copyWith(
                      color: isDark
                          ? CbsColors.darkTextMetadata
                          : CbsColors.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: verySmallStyle12.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? CbsColors.darkTextPrimary
                          : CbsColors.primaryDark[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoResourceTile extends StatelessWidget {
  const _VideoResourceTile({
    required this.resource,
    required this.lessonLabel,
    required this.l10n,
    required this.isDark,
    required this.borderColor,
    required this.cardColor,
    required this.titleColor,
    required this.bodyColor,
    required this.playing,
    required this.onPlay,
    required this.onStop,
  });

  final LessonResourceData resource;
  final String lessonLabel;
  final AppLocalizations l10n;
  final bool isDark;
  final Color borderColor;
  final Color cardColor;
  final Color? titleColor;
  final Color? bodyColor;
  final bool playing;
  final VoidCallback onPlay;
  final VoidCallback onStop;

  Future<void> _openFullscreen(BuildContext context) async {
    final url = (resource.url ?? '').trim();
    if (url.isEmpty) return;
    final signed = await resolveStorageViewUrl(url);
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => VideoViewerScreen(
          url: signed,
          originalUrl: url,
          title: resource.title,
          autoplay: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = (resource.url ?? '').trim();
    final label = (resource.title ?? '').trim().isNotEmpty
        ? resource.title!.trim()
        : l10n.watchVideo;
    final accent = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final thumbnailUrl = videoThumbnailUrl(url);

    final fallbackPoster = ColoredBox(
      color: isDark ? CbsColors.darkElevated : const Color(0xFF1A1410),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.18),
              Colors.black.withValues(alpha: 0.55),
            ],
          ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: playing
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      InlineVideoPlayer(
                        key: ValueKey('inline-video-$url'),
                        url: url,
                        originalUrl: url,
                        autoplay: true,
                        onFullscreen: () => _openFullscreen(context),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: MaterialLocalizations.of(context)
                                .closeButtonTooltip,
                            onPressed: onStop,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: url.isEmpty ? null : onPlay,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (thumbnailUrl != null)
                            CachedRemoteImage(
                              url: thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: fallbackPoster,
                              error: fallbackPoster,
                            )
                          else
                            fallbackPoster,
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x33000000),
                                  Color(0x66000000),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.play_circle_filled_rounded,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.videocam_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.watchVideo,
                                    style: verySmallStyle10.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: verySmallStyle14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lessonLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: verySmallStyle10.copyWith(color: bodyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.resource,
    required this.lessonId,
    required this.lessonLabel,
    required this.l10n,
    required this.isDark,
    required this.borderColor,
    required this.cardColor,
    required this.titleColor,
    required this.bodyColor,
  });

  final LessonResourceData resource;
  final String? lessonId;
  final String lessonLabel;
  final AppLocalizations l10n;
  final bool isDark;
  final Color borderColor;
  final Color cardColor;
  final Color? titleColor;
  final Color? bodyColor;

  @override
  Widget build(BuildContext context) {
    final url = (resource.url ?? '').trim();
    final kind = lessonResourceKindFromType(resource.resourceType);
    final label = (resource.title ?? '').trim().isNotEmpty
        ? resource.title!.trim()
        : l10n.openFile;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: url.isEmpty
            ? null
            : () => openRemoteFile(
                  url,
                  title: resource.title,
                  lessonId: lessonId,
                  resourceType: resource.resourceType,
                ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                iconForLessonResource(kind),
                size: 24,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: verySmallStyle14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lessonLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: verySmallStyle10.copyWith(color: bodyColor),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: bodyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
