import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
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
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DataController dataController = Get.find<DataController>();
  final SupabaseService apiService = SupabaseService();
  bool _loading = false;
  _DailyVerse? _dailyVerse;
  bool _loadingVerse = false;
  static const _verseCacheDateKey = 'daily_verse_cache_date';
  static const _verseCacheTextKey = 'daily_verse_cache_text';
  static const _verseCacheRefKey = 'daily_verse_cache_ref';

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
    if (mounted) setState(() => _loading = false);
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
    _fetchDailyVerseFromApi();
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
    final user = AuthService.currentUser;
    final meta = user?.userMetadata ?? {};
    final firstName = meta['first_name']?.toString().trim();
    final lastName = meta['last_name']?.toString().trim();
    final nameFromMeta = meta['name']?.toString().trim();
    final username = firstName ??
        nameFromMeta ??
        user?.email?.split('@').first ??
        lastName ??
        '—';
    final today = DateFormat.yMMMMEEEEd(languageCode).format(DateTime.now());
    final verse = _dailyVerse;
    final greeting = _greeting(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    '$greeting, $username',
                    style: mediumStyle24Medium.copyWith(
                      color: isDark
                          ? CbsColors.darkText
                          : CbsColors.primaryDark[800],
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
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
                    final courseCount = dc.courses.length;
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
                                      itemCount: teachers.take(5).length,
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
                          title: l10n.coursesSection,
                          moreText: '',
                        ),
                        gapH12,
                        _loading
                            ? const SizedBox.shrink()
                            : courseCount == 0
                                ? _emptyBlock(l10n.noItemsFound)
                                : Column(
                                    children: courses
                                        .take(5)
                                        .map(
                                          (course) => CourseCard(
                                            courseData: course,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      _CourseDetailsPage(
                                                    course: course,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
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
                  title: Text(name.isEmpty ? '—' : name),
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
  final localeCode = Localizations.localeOf(context).languageCode;
  final id = (teacher.id ?? '').trim();
  String? phone;
  if (id.isNotEmpty) {
    phone = await supabase.fetchTeacherWhatsAppNumber(id);
  }

  if (phone == null || phone.trim().isEmpty) {
    final message = localeCode == 'fr'
        ? 'Numero WhatsApp de cet enseignant indisponible.'
        : 'This teacher does not have a WhatsApp number yet.';
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    return;
  }

  await checkWhatsAppAndCall(phone);
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
      color: CbsColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: CbsColors.primaryBrown.withValues(alpha: 0.10),
                backgroundImage:
                    hasImage ? NetworkImage(teacher.pImage!) : null,
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
              gapH10,
              Text(
                name.isEmpty ? '—' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: mediumBodyStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CbsColors.primaryDark[800],
                ),
              ),
              gapH4,
              Text(
                teacher.email ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: smallBodyStyle.copyWith(
                  color: CbsColors.hintColor,
                  fontSize: 12,
                ),
              ),
              gapH10,
              CbsButton(
                width: double.infinity,
                height: 32,
                bgColor: CbsColors.primaryBrown,
                onPressed: onContact,
                child: Text(
                  contactLabel,
                  style: verySmallStyle10.copyWith(
                    fontWeight: FontWeight.w600,
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
    return Scaffold(
      backgroundColor: CbsColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: LessonPage(
            courseData: course,
            onBack: () => Navigator.of(context).pop(),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: CbsColors.primaryBrown.withValues(alpha: 0.12),
              backgroundImage: hasImage ? NetworkImage(teacher.pImage!) : null,
              child: hasImage
                  ? null
                  : Text(
                      initials,
                      style: largeStyle32Bold.copyWith(
                        fontSize: 34,
                        color: CbsColors.primaryBrown,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              name.isEmpty ? l10n.unnamedGroup : name,
              textAlign: TextAlign.center,
              style:
                  mediumStyle24Bold.copyWith(color: CbsColors.primaryDark[800]),
            ),
            const SizedBox(height: 6),
            Text(
              teacher.email ?? '',
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(
                  color: CbsColors.hintColor, fontSize: 14),
            ),
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
          ],
        ),
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
