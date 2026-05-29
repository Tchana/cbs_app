import 'dart:async';

import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/features/announcements/announcements_page.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/constants/text_styles.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:center_for_biblical_studies/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    SupabaseService? apiService,
    this.enableProfileLoad = true,
    this.enableVerseLoad = true,
  }) : apiService = apiService ?? const SupabaseService.testable();

  final SupabaseService apiService;
  final bool enableProfileLoad;
  final bool enableVerseLoad;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DataController dataController = Get.find<DataController>();
  bool _loading = false;
  _DailyVerse? _dailyVerse;
  bool _loadingVerse = false;
  int _unreadAnnouncements = 0;
  int _outstandingBalance = 0;
  List<Map<String, dynamic>> _announcements = const <Map<String, dynamic>>[];
  int _announcementIndex = 0;
  Timer? _announcementTimer;
  List<String> _recentCourseIds = const <String>[];
  List<String> _recentBookIds = const <String>[];
  static const _verseCacheDateKey = 'daily_verse_cache_date';
  static const _verseCacheTextKey = 'daily_verse_cache_text';
  static const _verseCacheRefKey = 'daily_verse_cache_ref';
  String? _profileLastName;

  SupabaseService get apiService => widget.apiService;

  Future<void> _contactTeacher(RegisterData teacher) async {
    await _openTeacherWhatsAppContact(
      context: context,
      supabase: apiService,
      teacher: teacher,
    );
  }

  Future<void> fetchData() async {
    setState(() => _loading = true);
    try {
      final courses = await apiService.fetchCourses();
      dataController.setCourses(courses);
    } catch (_) {}
    try {
      final books = await apiService.fetchBooks();
      dataController.setBooks(books);
    } catch (_) {}
    try {
      final teachers = await apiService.fetchTeachers();
      dataController.setTeachers(teachers);
    } catch (_) {}
    try {
      final announcements = await apiService.fetchVisibleAnnouncements(limit: 20);
      final unreadCount = await apiService.fetchUnreadAnnouncementsCount();
      final balanceDue = await apiService.fetchMyOutstandingBalance();
      if (mounted) {
        setState(() {
          _announcements = announcements;
          if (_announcementIndex >= _announcements.length) {
            _announcementIndex = 0;
          }
          _unreadAnnouncements = unreadCount;
          _outstandingBalance = balanceDue;
        });
        _configureAnnouncementTimer();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadProfileLastName() async {
    final email = AuthService.currentUser?.email?.trim();
    if (email == null || email.isEmpty) return;
    final lastName = await apiService.fetchProfileLastNameByEmail(email);
    if (!mounted) return;
    setState(() {
      _profileLastName = lastName;
    });
  }

  Future<void> _loadRecentAccess() async {
    final courseIds = await RecentAccessService.getRecentCourseIds();
    final bookIds = await RecentAccessService.getRecentBookIds();
    if (!mounted) return;
    setState(() {
      _recentCourseIds = courseIds;
      _recentBookIds = bookIds;
    });
  }

  Future<void> _openCourseDetails(CourseData course) async {
    await RecentAccessService.markCourseAccessed(course.id);
    await _loadRecentAccess();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CourseDetailsPage(course: course),
      ),
    );
  }

  Future<void> _openBookQuick(LibraryData book, AppLocalizations l10n) async {
    final url = (book.book ?? '').trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noItemsFound)),
      );
      return;
    }
    await RecentAccessService.markBookAccessed(book.id);
    await _loadRecentAccess();
    if (!mounted) return;
    await openRemoteFile(url, title: book.title, bookId: book.id);
  }

  Future<void> _fetchDailyVerseFromApi() async {
    if (mounted) {
      setState(() {
        _loadingVerse = true;
      });
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final cachedDate = prefs.getString(_verseCacheDateKey);
      final cachedText = prefs.getString(_verseCacheTextKey);
      final cachedRef = prefs.getString(_verseCacheRefKey);

      if (cachedDate == todayKey &&
          cachedText != null &&
          cachedText.isNotEmpty &&
          cachedRef != null &&
          cachedRef.isNotEmpty) {
        if (mounted) {
          setState(() {
            _dailyVerse =
                _DailyVerse(en: cachedText, fr: cachedText, ref: cachedRef);
            _loadingVerse = false;
          });
        }
        return;
      }

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ));
      final response = await dio.get<Map<String, dynamic>>(
        'https://beta.ourmanna.com/api/v1/get/?format=json&order=daily',
      );

      final data = response.data ?? {};
      final details = (data['verse'] as Map?)?['details'] as Map?;
      final text = details?['text']?.toString().trim();
      final reference = details?['reference']?.toString().trim();

      if (text != null &&
          text.isNotEmpty &&
          reference != null &&
          reference.isNotEmpty) {
        await prefs.setString(_verseCacheDateKey, todayKey);
        await prefs.setString(_verseCacheTextKey, text);
        await prefs.setString(_verseCacheRefKey, reference);
        if (mounted) {
          setState(() {
            _dailyVerse = _DailyVerse(en: text, fr: text, ref: reference);
          });
        }
      }
    } catch (_) {
      // Silent fail: UI will show localized fallback.
    } finally {
      if (mounted) {
        setState(() {
          _loadingVerse = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (dataController.courses.isEmpty &&
        dataController.books.isEmpty &&
        dataController.teachers.isEmpty) {
      fetchData();
    }
    if (widget.enableProfileLoad) {
      _loadProfileLastName();
    }
    _loadRecentAccess();
    if (widget.enableVerseLoad) {
      _fetchDailyVerseFromApi();
    }
  }

  void _configureAnnouncementTimer() {
    _announcementTimer?.cancel();
    if (_announcements.length <= 1) return;
    _announcementTimer =
        Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _announcements.isEmpty) return;
      setState(() {
        _announcementIndex = (_announcementIndex + 1) % _announcements.length;
      });
    });
  }

  @override
  void dispose() {
    _announcementTimer?.cancel();
    super.dispose();
  }

  void _openSearch(AppLocalizations l10n) {
    showSearch<void>(
      context: context,
      delegate: _DashboardSearchDelegate(
        l10n: l10n,
      ),
    );
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final languageCode = l10n.locale.languageCode;
    final user = _currentUserOrNull();
    final meta = user?.userMetadata ?? {};
    final firstName = meta['first_name']?.toString().trim();
    final lastName = meta['last_name']?.toString().trim();
    final nameFromMeta = meta['name']?.toString().trim();
    final username =
        _profileLastName ?? lastName ?? firstName ?? nameFromMeta ?? '';
    final today = DateFormat.yMMMMEEEEd(languageCode).format(DateTime.now());
    final verse = _dailyVerse;
    final greeting = _greeting(l10n);
    final greetingText = username.isEmpty ? greeting : '$greeting, $username';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final latest = _announcements.isEmpty
        ? null
        : _announcements[_announcementIndex % _announcements.length];

    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          today,
          style: smallStyle18.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AnnouncementsPage(apiService: apiService),
                    ),
                  );
                  if (mounted) {
                    final unread = await apiService.fetchUnreadAnnouncementsCount();
                    setState(() {
                      _unreadAnnouncements = unread;
                    });
                  }
                },
                icon: const Icon(Icons.notifications_outlined),
                tooltip: l10n.notificationsTooltip,
              ),
              if (_unreadAnnouncements > 0)
                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _unreadAnnouncements > 99
                          ? '99+'
                          : _unreadAnnouncements.toString(),
                      style: verySmallStyle12.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () => _openSearch(l10n),
            icon: const Icon(Icons.search_rounded),
            tooltip: l10n.searchHint,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchData,
          color: CbsColors.primaryBrown,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greetingText,
                    style: mediumStyle24Medium.copyWith(
                      color: isDark
                          ? CbsColors.darkText
                          : CbsColors.primaryDark[800],
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_outstandingBalance > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: CbsColors.errorColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CbsColors.errorColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: CbsColors.errorColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.outstandingBalance(
                                NumberFormat.decimalPattern().format(
                                  _outstandingBalance,
                                ),
                              ),
                              style: smallStyle18.copyWith(
                                color: CbsColors.errorColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: isDark ? CbsColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.campaign_outlined,
                              color: CbsColors.primaryBrown,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.latestAnnouncement,
                              style: smallStyle18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: CbsColors.primaryBrown,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          latest == null
                              ? l10n.noAnnouncementsYet
                              : (latest['title'] ?? l10n.announcementFallback)
                                  .toString(),
                          style: smallStyle18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? CbsColors.darkText
                                : CbsColors.primaryDark[800],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          latest == null
                              ? l10n.announcementsEmptyHint
                              : (latest['body'] ?? '').toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: smallStyle18.copyWith(
                            fontSize: 14,
                            color:
                                isDark ? CbsColors.darkHint : CbsColors.hintColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AnnouncementsPage(apiService: apiService),
                                ),
                              );
                              if (mounted) {
                                final unread = await apiService
                                    .fetchUnreadAnnouncementsCount();
                                setState(() {
                                  _unreadAnnouncements = unread;
                                });
                              }
                            },
                            icon: const Icon(Icons.open_in_new_rounded, size: 16),
                            label: Text(l10n.viewAll),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CbsColors.primaryBrown.withValues(alpha: 0.95),
                          CbsColors.brandDeepBlue.withValues(alpha: 0.95),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.verseOfTheDay,
                          style: smallStyle18.copyWith(
                            color: CbsColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (verse?.ref != null && verse!.ref.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CbsColors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              verse.ref,
                              style: verySmallStyle12.copyWith(
                                color: CbsColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        _loadingVerse
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: CbsColors.white,
                                ),
                              )
                            : Text(
                                verse != null
                                    ? (languageCode == 'fr'
                                        ? verse.fr
                                        : verse.en)
                                    : l10n.verseUnavailable,
                                style: smallStyle18.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CbsColors.white,
                                  height: 1.4,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  GetX<DataController>(builder: (dc) {
                    final teacherCount = dc.teachers.length;
                    final teachers = dc.teachers.toList(growable: false);
                    final courses = dc.courses.toList(growable: false);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: l10n.teachersSection,
                          moreText: l10n.seeAll,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const _AllTeachersPage(),
                              ),
                            );
                          },
                        ),
                        gapH12,
                        _loading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: CbsColors.primaryBrown,
                                  ),
                                ),
                              )
                            : teacherCount == 0
                                ? _emptyBlock(l10n.noItemsFound)
                                : SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: teachers.length,
                                      separatorBuilder: (_, __) => gapW16,
                                      itemBuilder: (_, i) => _TeacherCard(
                                        teacher: teachers[i],
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  _TeacherDetailsPage(
                                                teacher: teachers[i],
                                                onContact: () =>
                                                    _contactTeacher(
                                                  teachers[i],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onContact: () => _contactTeacher(
                                          teachers[i],
                                        ),
                                        contactLabel: l10n.contact,
                                      ),
                                    ),
                                  ),
                        gapH28,
                        SectionHeader(
                          title: l10n.recentlyAccessed,
                          moreText: '',
                        ),
                        gapH12,
                        _loading
                            ? const SizedBox.shrink()
                            : _buildRecentAccessBlock(
                                l10n: l10n,
                                dc: dc,
                                courses: courses,
                              ),
                      ],
                    );
                  }),
                  gapH16,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyBlock(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          text,
          style: smallStyle18.copyWith(
            color: CbsColors.hintColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentAccessBlock({
    required AppLocalizations l10n,
    required DataController dc,
    required List<CourseData> courses,
  }) {
    final byCourseId = <String, CourseData>{
      for (final c in courses)
        if ((c.id ?? '').trim().isNotEmpty) c.id!.trim(): c,
    };
    final byBookId = <String, LibraryData>{
      for (final b in dc.books)
        if ((b.id ?? '').trim().isNotEmpty) b.id!.trim(): b,
    };

    final recentCourses = _recentCourseIds
        .map((id) => byCourseId[id])
        .whereType<CourseData>()
        .take(4)
        .toList();
    final recentBooks = _recentBookIds
        .map((id) => byBookId[id])
        .whereType<LibraryData>()
        .take(4)
        .toList();

    if (recentCourses.isEmpty && recentBooks.isEmpty) {
      return _emptyBlock(l10n.noRecentAccessYet);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentCourses.isNotEmpty) ...[
          Text(
            l10n.recentCourses,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              color: CbsColors.primaryBrown,
            ),
          ),
          const SizedBox(height: 8),
          ...recentCourses.map(
            (course) => CourseCard(
              courseData: course,
              onPressed: () => _openCourseDetails(course),
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (recentBooks.isNotEmpty) ...[
          Text(
            l10n.recentBooks,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              color: CbsColors.primaryBrown,
            ),
          ),
          const SizedBox(height: 8),
          ...recentBooks.map(
            (book) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: const Icon(Icons.menu_book_rounded),
              title: Text(book.title ?? l10n.dash),
              subtitle: Text((book.author ?? '').trim().isEmpty
                  ? l10n.book
                  : (book.author ?? '')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _openBookQuick(book, l10n),
            ),
          ),
        ],
      ],
    );
  }

  dynamic _currentUserOrNull() {
    try {
      return AuthService.currentUser;
    } catch (_) {
      return null;
    }
  }
}

class _DashboardSearchDelegate extends SearchDelegate<void> {
  _DashboardSearchDelegate({
    required this.l10n,
  });

  final AppLocalizations l10n;
  final SupabaseService _supabase = SupabaseService();

  @override
  String? get searchFieldLabel => l10n.searchHint;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildBody(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildBody(context);

  Future<_DashboardSearchData> _searchFromDb() async {
    final q = query.trim();
    final results = await Future.wait([
      _supabase.searchTeachers(q),
      _supabase.searchCourses(q),
      _supabase.searchBooks(q),
    ]);
    return _DashboardSearchData(
      teachers: results[0] as List<RegisterData>,
      courses: results[1] as List<CourseData>,
      books: results[2] as List<LibraryData>,
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<_DashboardSearchData>(
      future: _searchFromDb(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              l10n.noItemsFound,
              style: smallStyle18.copyWith(color: CbsColors.hintColor),
            ),
          );
        }
        final data = snapshot.data ??
            const _DashboardSearchData(
              teachers: [],
              courses: [],
              books: [],
            );
        final fTeachers = data.teachers;
        final fCourses = data.courses;
        final fBooks = data.books;

        if (fTeachers.isEmpty && fCourses.isEmpty && fBooks.isEmpty) {
          return Center(
            child: Text(
              l10n.noItemsFound,
              style: smallStyle18.copyWith(color: CbsColors.hintColor),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            if (fTeachers.isNotEmpty) ...[
              Text(
                l10n.teachersSection,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CbsColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 8),
              ...fTeachers.map((t) {
                final name = '${t.firstName ?? ''} ${t.lastName ?? ''}'.trim();
                final hasImage =
                    t.pImage != null && t.pImage!.trim().isNotEmpty;
                final initials = _teacherInitials(t);
                return ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        CbsColors.primaryBrown.withValues(alpha: 0.12),
                    backgroundImage: hasImage ? NetworkImage(t.pImage!) : null,
                    child: hasImage
                        ? null
                        : Text(
                            initials,
                            style: verySmallStyle12.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: CbsColors.primaryBrown,
                            ),
                          ),
                  ),
                  title: Text(name.isEmpty ? l10n.dash : name),
                  subtitle: Text(t.email ?? ''),
                  onTap: () {
                    final navigator = Navigator.of(context);
                    close(context, null);
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => _TeacherDetailsPage(
                          teacher: t,
                          onContact: () => _openTeacherWhatsAppContact(
                            context: context,
                            supabase: _supabase,
                            teacher: t,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
            if (fCourses.isNotEmpty) ...[
              Text(
                l10n.coursesSection,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CbsColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 8),
              ...fCourses.map((c) {
                return ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: Text(c.title ?? ''),
                  subtitle: Text(c.description ?? ''),
                  onTap: () {
                    final navigator = Navigator.of(context);
                    close(context, null);
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => _CourseDetailsPage(course: c),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
            if (fBooks.isNotEmpty) ...[
              Text(
                l10n.tabBooks,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CbsColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 8),
              ...fBooks.map((b) {
                return ListTile(
                  leading: const Icon(Icons.library_books_outlined),
                  title: Text(b.title ?? ''),
                  subtitle: Text(
                      (b.author ?? '').isNotEmpty ? b.author! : (b.book ?? '')),
                  onTap: () {
                    final navigator = Navigator.of(context);
                    close(context, null);
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => _BookDetailsPage(book: b),
                      ),
                    );
                  },
                );
              }),
            ],
          ],
        );
      },
    );
  }
}

class _DashboardSearchData {
  const _DashboardSearchData({
    required this.teachers,
    required this.courses,
    required this.books,
  });

  final List<RegisterData> teachers;
  final List<CourseData> courses;
  final List<LibraryData> books;
}

Future<void> _openTeacherWhatsAppContact({
  required BuildContext context,
  required SupabaseService supabase,
  required RegisterData teacher,
}) async {
  final l10n =
      AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
  final id = (teacher.id ?? '').trim();
  String phone = (teacher.phone ?? '').trim();
  if (id.isNotEmpty) {
    phone = phone.isNotEmpty
        ? phone
        : ((await supabase.fetchTeacherWhatsAppNumber(id)) ?? '').trim();
  }

  if (phone.trim().isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teacherWhatsAppUnavailable)),
      );
    }
    return;
  }

  final opened = await openTeacherWhatsApp(phone);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.teacherWhatsAppUnavailable)),
    );
  }
}

class _AllTeachersPage extends StatefulWidget {
  const _AllTeachersPage();

  @override
  State<_AllTeachersPage> createState() => _AllTeachersPageState();
}

class _AllTeachersPageState extends State<_AllTeachersPage> {
  final SupabaseService _supabase = SupabaseService();
  late Future<List<RegisterData>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _supabase.fetchTeachers();
  }

  Future<void> _reload() async {
    final future = _supabase.fetchTeachers();
    setState(() {
      _teachersFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.teachersSection),
      ),
      body: FutureBuilder<List<RegisterData>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: CbsColors.primaryBrown),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.errorPrefix,
                  textAlign: TextAlign.center,
                  style: smallStyle18.copyWith(color: CbsColors.hintColor),
                ),
              ),
            );
          }

          final teachers = snapshot.data ?? <RegisterData>[];
          if (teachers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.noItemsFound,
                  textAlign: TextAlign.center,
                  style: smallStyle18.copyWith(color: CbsColors.hintColor),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: CbsColors.primaryBrown,
            onRefresh: _reload,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: teachers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final teacher = teachers[i];
                return _TeacherCard(
                  teacher: teacher,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _TeacherDetailsPage(
                          teacher: teacher,
                          onContact: () => _openTeacherWhatsAppContact(
                            context: context,
                            supabase: _supabase,
                            teacher: teacher,
                          ),
                        ),
                      ),
                    );
                  },
                  onContact: () => _openTeacherWhatsAppContact(
                    context: context,
                    supabase: _supabase,
                    teacher: teacher,
                  ),
                  contactLabel: l10n.contact,
                  compact: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.teacher,
    required this.onTap,
    required this.onContact,
    required this.contactLabel,
    this.compact = true,
  });

  final RegisterData teacher;
  final VoidCallback onTap;
  final VoidCallback onContact;
  final String contactLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    final hasImage =
        teacher.pImage != null && teacher.pImage!.trim().isNotEmpty;
    final initials = _teacherInitials(teacher);
    final card = compact
        ? _buildCompactCard(name, hasImage, initials)
        : _buildExpandedCard(name, hasImage, initials);

    return compact ? SizedBox(width: 152, child: card) : card;
  }

  Widget _buildCompactCard(String name, bool hasImage, String initials) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                CbsColors.white,
                CbsColors.primaryBrown.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: CbsColors.primaryBrown.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        CbsColors.primaryBrown.withValues(alpha: 0.85),
                        CbsColors.brandDeepBlue.withValues(alpha: 0.80),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor:
                        CbsColors.primaryBrown.withValues(alpha: 0.10),
                    backgroundImage: hasImage ? NetworkImage(teacher.pImage!) : null,
                    child: hasImage
                        ? null
                        : Text(
                            initials,
                            style: mediumStyle24Bold.copyWith(
                              fontSize: 22,
                              color: CbsColors.primaryBrown,
                            ),
                          ),
                  ),
                ),
                gapH10,
                Text(
                  name.isEmpty ? '—' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: mediumBodyStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: CbsColors.primaryDark[800],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  teacher.email ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: smallBodyStyle.copyWith(
                    color: CbsColors.hintColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                CbsButton(
                  width: double.infinity,
                  height: 34,
                  bgColor: CbsColors.primaryBrown,
                  onPressed: onContact,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_outlined,
                          size: 14, color: CbsColors.white),
                      const SizedBox(width: 6),
                      Text(
                        contactLabel,
                        style: verySmallStyle10.copyWith(
                          fontWeight: FontWeight.w700,
                          color: CbsColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard(String name, bool hasImage, String initials) {
    return Material(
      color: CbsColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: CbsColors.primaryBrown.withValues(alpha: 0.10)),
            gradient: LinearGradient(
              colors: [
                CbsColors.white,
                CbsColors.primaryBrown.withValues(alpha: 0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: CbsColors.primaryBrown.withValues(alpha: 0.10),
                backgroundImage:
                    hasImage ? NetworkImage(teacher.pImage!) : null,
                child: hasImage
                    ? null
                    : Text(
                        initials,
                        style: mediumStyle24Bold.copyWith(
                          fontSize: 18,
                          color: CbsColors.primaryBrown,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? '—' : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: CbsColors.primaryDark[800],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      teacher.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallBodyStyle.copyWith(
                        color: CbsColors.hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CbsButton(
                width: 92,
                height: 34,
                bgColor: CbsColors.primaryBrown,
                onPressed: onContact,
                child: Text(
                  contactLabel,
                  style: verySmallStyle10.copyWith(
                    fontWeight: FontWeight.w700,
                    color: CbsColors.white,
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
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: LessonPage(
            courseData: course,
          ),
        ),
      ),
    );
  }
}

class _TeacherDetailsPage extends StatelessWidget {
  const _TeacherDetailsPage({
    required this.teacher,
    required this.onContact,
  });

  final RegisterData teacher;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    final hasImage =
        teacher.pImage != null && teacher.pImage!.trim().isNotEmpty;
    final initials = _teacherInitials(teacher);
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? l10n.unnamedGroup : name),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          Center(
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.22),
                  width: 2,
                ),
                color: CbsColors.primaryBrown.withValues(alpha: 0.12),
              ),
              child: ClipOval(
                child: hasImage
                    ? Image.network(
                        teacher.pImage!.trim(),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            initials,
                            style: largeStyle32Bold.copyWith(
                              fontSize: 34,
                              color: CbsColors.primaryBrown,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          initials,
                          style: largeStyle32Bold.copyWith(
                            fontSize: 34,
                            color: CbsColors.primaryBrown,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name.isEmpty ? l10n.unnamedGroup : name,
            textAlign: TextAlign.center,
            style: mediumStyle24Bold.copyWith(color: CbsColors.primaryDark[800]),
          ),
          const SizedBox(height: 6),
          if ((teacher.email ?? '').trim().isNotEmpty)
            Text(
              teacher.email!.trim(),
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(color: CbsColors.hintColor, fontSize: 14),
            ),
          if ((teacher.phone ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              teacher.phone!.trim(),
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(color: CbsColors.hintColor, fontSize: 14),
            ),
          ],
          const SizedBox(height: 20),
          CbsButton(
            width: double.infinity,
            height: 46,
            bgColor: CbsColors.primaryBrown,
            onPressed: onContact,
            child: Text(
              l10n.contact,
              style: smallStyle18.copyWith(
                color: CbsColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _TeacherInfoSection(
            title: 'Vocation',
            value: (teacher.vocation ?? '').trim(),
          ),
          const SizedBox(height: 12),
          _TeacherInfoSection(
            title: 'Testimony',
            value: (teacher.testimony ?? '').trim(),
          ),
          const SizedBox(height: 12),
          _TeacherInfoSection(
            title: 'Journey (Parcours)',
            value: (teacher.journey ?? '').trim(),
          ),
        ],
      ),
    );
  }
}

class _TeacherInfoSection extends StatelessWidget {
  const _TeacherInfoSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final v = value.trim();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CbsColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CbsColors.primaryBrown.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: [
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
          Text(
            title,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              color: CbsColors.primaryDark[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            v.isEmpty ? '—' : v,
            style: verySmallStyle14.copyWith(
              color: CbsColors.primaryDark[700],
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookDetailsPage extends StatelessWidget {
  const _BookDetailsPage({required this.book});
  final LibraryData book;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final desc = (book.description ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? l10n.tabBooks : title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (author.isNotEmpty)
              Text(
                author,
                style: smallStyle18.copyWith(
                  color: CbsColors.hintColor,
                  fontSize: 14,
                ),
              ),
            if (author.isNotEmpty) const SizedBox(height: 12),
            if (desc.isNotEmpty)
              Text(
                desc,
                style: smallStyle18.copyWith(
                  color: CbsColors.primaryDark[700],
                  fontSize: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DailyVerse {
  const _DailyVerse({
    required this.en,
    required this.fr,
    required this.ref,
  });

  final String en;
  final String fr;
  final String ref;
}

String _teacherInitials(RegisterData teacher) {
  final first = (teacher.firstName ?? '').trim();
  final last = (teacher.lastName ?? '').trim();
  if (first.isNotEmpty && last.isNotEmpty) {
    return '${first[0]}${last[0]}'.toUpperCase();
  }
  if (first.isNotEmpty) {
    return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
  }
  if (last.isNotEmpty) {
    return last.substring(0, last.length >= 2 ? 2 : 1).toUpperCase();
  }
  final email = (teacher.email ?? '').trim();
  if (email.isNotEmpty) {
    final part = email.split('@').first;
    return part.substring(0, part.length >= 2 ? 2 : 1).toUpperCase();
  }
  return 'NA';
}
