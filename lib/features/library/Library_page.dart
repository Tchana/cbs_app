// ignore_for_file: file_names

import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/services/book_reading_progress_service.dart';
import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_campus_ui.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_shell_controller.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SliverGridDelegate _libraryBookGridDelegate(BuildContext context) {
  if (Adaptive.isCompact(context)) {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.66,
    );
  }
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: Adaptive.bookColumns(context),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: Adaptive.bookAspectRatio(context),
  );
}

int _desktopLibraryColumns(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 1400) return 5;
  if (width >= 1100) return 4;
  if (width >= 860) return 3;
  return 2;
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
    SupabaseService? apiService,
  }) : apiService = apiService ?? const SupabaseService.testable();

  final SupabaseService apiService;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  final DataController dataController = Get.find<DataController>();
  final BookReadingProgressService _readingProgressService =
      BookReadingProgressService();
  TabController? _tabController;
  ContinueReadingEntry? _continueReading;
  List<BookType> _categories = const [
    BookType.bible,
    BookType.commentary,
    BookType.dictionnaire,
  ];

  DesktopShellController? _shellController;
  Worker? _searchWorker;
  bool _inlineSearchEnabled = false;
  BookType? _desktopCategoryFilter;

  DesktopShellController get _shell => _shellController!;

  Future<void> fetchData() async {
    final dataController = Get.find<DataController>();
    try {
      final books = await apiService.fetchBooks();
      dataController.setBooks(books);
      await _refreshContinueReading();
    } catch (_) {}
  }

  Future<void> _refreshContinueReading() async {
    final continueEntry = await _readingProgressService.resolveContinueReading(
      dataController.books,
    );
    if (mounted) {
      setState(() => _continueReading = continueEntry);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await apiService.fetchBookCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories.isEmpty
            ? const [
                BookType.bible,
                BookType.commentary,
                BookType.dictionnaire,
              ]
            : categories;
      });
      _rebuildTabController();
    } catch (_) {
      _rebuildTabController();
    }
  }

  void _rebuildTabController() {
    _tabController?.dispose();
    _tabController = TabController(length: _categories.length + 1, vsync: this);
    if (mounted) setState(() {});
  }

  void _configureDesktopSearch(AppLocalizations l10n) {
    if (_inlineSearchEnabled || !Adaptive.isDesktop(context)) return;
    _inlineSearchEnabled = true;
    _shell.enableInlineSearch(l10n.librarySearchHint);
  }

  List<LibraryData> _filterBooks({
    required List<LibraryData> books,
    required String query,
    BookType? category,
  }) {
    var list = books;
    final q = query.trim().toLowerCase();

    if (category != null) {
      list = list.where((book) => book.category == category).toList();
    }

    if (q.isEmpty) return list;

    return list.where((book) {
      final title = (book.title ?? '').toLowerCase();
      final author = (book.author ?? '').toLowerCase();
      final categoryLabel = book.category?.name.toLowerCase() ?? '';
      final language = (book.language ?? '').toLowerCase();
      return title.contains(q) ||
          author.contains(q) ||
          categoryLabel.contains(q) ||
          language.contains(q);
    }).toList();
  }

  Future<void> _openBook(LibraryData book, AppLocalizations l10n) async {
    final url = (book.book ?? '').trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noItemsFound)),
      );
      return;
    }
    RecentAccessService.markBookAccessed(book.id);
    await _readingProgressService.markLastOpened(book.id);
    if (mounted) await _refreshContinueReading();
    await openRemoteFile(url, title: book.title, bookId: book.id);
    if (mounted) await _refreshContinueReading();
  }

  @override
  void initState() {
    super.initState();
    _shellController = ensureDesktopShellController();
    _rebuildTabController();
    _loadCategories();
    fetchData();
    _searchWorker = ever<String>(_shell.searchQuery, (_) {
      if (!mounted) return;
      setState(() {});
    });
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
    });
  }

  @override
  void dispose() {
    _searchWorker?.dispose();
    if (Get.isRegistered<DesktopShellController>()) {
      _shell.disableInlineSearch();
    }
    _inlineSearchEnabled = false;
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Adaptive.isDesktop(context);
    final tabController = _tabController;

    if (tabController == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: CbsColors.primaryBrown),
          ),
        ),
      );
    }

    return Obx(() {
      return Scaffold(
        backgroundColor:
            isDark ? CbsColors.darkBg : CbsColors.backgroundColor,
        appBar: isDesktop
            ? null
            : AppBar(
                title: Text(
                  l10n.library,
                  style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
                ),
                centerTitle: false,
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.favorite_border_rounded),
                  ),
                ],
              ),
        body: SafeArea(
          child: isDesktop
              ? _buildDesktopBody(context, l10n, isDark)
              : _buildMobileBody(context, l10n, isDark, tabController),
        ),
      );
    });
  }

  Widget _buildDesktopBody(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final allBooks = dataController.books.toList();
    final filtered = _filterBooks(
      books: allBooks,
      query: _shell.searchQuery.value,
      category: _desktopCategoryFilter,
    );
    final categoryCount = allBooks.map((b) => b.category).whereType<BookType>().toSet().length;
    final bibleCount =
        allBooks.where((b) => b.category == BookType.bible).length;
    final commentaryCount =
        allBooks.where((b) => b.category == BookType.commentary).length;

    return DesktopPageFrame(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1100 ? 4 : 2;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: columns == 4 ? 2.9 : 2.5,
                children: [
                  CampusStatTile(
                    label: l10n.libraryStatTotalBooks,
                    value: '${allBooks.length}',
                    icon: Icons.menu_book_rounded,
                  ),
                  CampusStatTile(
                    label: l10n.libraryStatCategories,
                    value: '$categoryCount',
                    icon: Icons.category_rounded,
                  ),
                  CampusStatTile(
                    label: l10n.tabBibles,
                    value: '$bibleCount',
                    icon: Icons.auto_stories_rounded,
                  ),
                  CampusStatTile(
                    label: l10n.categoryCommentary,
                    value: '$commentaryCount',
                    icon: Icons.library_books_rounded,
                  ),
                ],
              );
            },
          ),
          gapH16,
          Expanded(
            child: CampusCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DesktopLibraryToolbar(
                    l10n: l10n,
                    isDark: isDark,
                    categories: _categories,
                    selectedCategory: _desktopCategoryFilter,
                    bookCount: filtered.length,
                    continueReading: _continueReading,
                    onContinueReadingTap: _continueReading == null
                        ? null
                        : () => _openBook(_continueReading!.book, l10n),
                    onCategoryChanged: (value) {
                      setState(() => _desktopCategoryFilter = value);
                    },
                    onRefresh: fetchData,
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptyState(l10n)
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _desktopLibraryColumns(context),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (_, index) => _LibraryDesktopBookCard(
                              book: filtered[index],
                              l10n: l10n,
                              isDark: isDark,
                              onPressed: () =>
                                  _openBook(filtered[index], l10n),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    TabController tabController,
  ) {
    return DesktopPageFrame(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          gapH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
                ),
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color:
                      isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor:
                    isDark ? CbsColors.brownNight : CbsColors.white,
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
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: EdgeInsets.zero,
                tabs: [
                  Tab(text: l10n.tabAll),
                  ..._categories
                      .map((c) => Tab(text: _categoryLabel(c, l10n))),
                ],
              ),
            ),
          ),
          gapH16,
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildAllTab(l10n),
                ..._categories.map((c) => _buildCategoryTab(c, l10n)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 48,
              color: CbsColors.hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noItemsFound,
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(
                color: CbsColors.hintColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTab(AppLocalizations l10n) {
    final items = dataController.books.toList();
    if (items.isEmpty) return _buildEmptyState(l10n);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            gridDelegate: _libraryBookGridDelegate(context),
            itemBuilder: (_, index) => BookItem(
              book: items[index],
              compact: !Adaptive.isCompact(context),
              onPressed: () => _openBook(items[index], l10n),
            ),
          ),
        ),
        if (_continueReading != null) ...[
          const SizedBox(height: 6),
          _buildContinueReading(l10n, _continueReading!),
        ],
      ],
    );
  }

  Widget _buildContinueReading(
    AppLocalizations l10n,
    ContinueReadingEntry entry,
  ) {
    final book = entry.book;
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final progress = entry.progress.clamp(0.0, 1.0);
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CbsColors.darkElevated : CbsColors.white;
    final borderColor = isDark
        ? CbsColors.goldDeep.withValues(alpha: 0.7)
        : CbsColors.primaryBrown.withValues(alpha: 0.14);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final subtitleColor =
        isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.continueReading,
          style: smallStyle18.copyWith(
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openBook(book, l10n),
            child: Ink(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 64,
                      width: 46,
                      decoration: BoxDecoration(
                        color: isDark
                            ? CbsColors.darkSurface
                            : CbsColors.primaryBrown.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: hasCover
                            ? Image.network(
                                book.bookCover!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _bookCoverFallback(),
                              )
                            : _bookCoverFallback(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.isEmpty ? l10n.dash : title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: smallStyle18.copyWith(
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            author.isEmpty
                                ? l10n.authorUnknown
                                : l10n.authorPrefix(author),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: smallStyle18.copyWith(
                              color: subtitleColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: isDark
                                  ? CbsColors.darkProgressBg
                                  : CbsColors.primaryBrown
                                      .withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark
                                    ? CbsColors.brandGold
                                    : CbsColors.primaryBrown,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.bookDownloadProgress(
                              (progress * 100).round(),
                            ),
                            style: smallStyle18.copyWith(
                              color: isDark
                                  ? CbsColors.brandGold
                                  : CbsColors.primaryBrown,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
        ),
      ],
    );
  }

  Widget _bookCoverFallback() {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 22,
        color: CbsColors.primaryBrown.withValues(alpha: 0.55),
      ),
    );
  }

  Widget _buildCategoryTab(BookType category, AppLocalizations l10n) {
    final items =
        dataController.books.where((book) => book.category == category).toList();

    if (items.isEmpty) return _buildEmptyState(l10n);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            gridDelegate: _libraryBookGridDelegate(context),
            itemBuilder: (_, index) => BookItem(
              book: items[index],
              compact: !Adaptive.isCompact(context),
              onPressed: () => _openBook(items[index], l10n),
            ),
          ),
        ),
        if (_continueReading != null) ...[
          const SizedBox(height: 6),
          _buildContinueReading(l10n, _continueReading!),
        ],
      ],
    );
  }

  String _categoryLabel(BookType category, AppLocalizations l10n) {
    return l10n.bookCategoryLabel(category.name);
  }

  SupabaseService get apiService => widget.apiService;
}

class _DesktopLibraryToolbar extends StatelessWidget {
  const _DesktopLibraryToolbar({
    required this.l10n,
    required this.isDark,
    required this.categories,
    required this.selectedCategory,
    required this.bookCount,
    required this.onCategoryChanged,
    required this.onRefresh,
    this.continueReading,
    this.onContinueReadingTap,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final List<BookType> categories;
  final BookType? selectedCategory;
  final int bookCount;
  final ValueChanged<BookType?> onCategoryChanged;
  final VoidCallback onRefresh;
  final ContinueReadingEntry? continueReading;
  final VoidCallback? onContinueReadingTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.creamDark;
    final fieldFill =
        isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 560;
          final categoryFilter = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: narrow ? double.infinity : 220),
            child: Container(
              width: narrow ? double.infinity : null,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: fieldFill,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButton<BookType?>(
                value: selectedCategory,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(10),
                dropdownColor: isDark ? CbsColors.darkSurface : Colors.white,
                style: smallStyle18.copyWith(
                  fontSize: 13,
                  color: isDark
                      ? CbsColors.darkTextPrimary
                      : CbsColors.primaryBrown,
                ),
                items: [
                  DropdownMenuItem<BookType?>(
                    value: null,
                    child: Text(l10n.libraryAllCategories),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem<BookType?>(
                      value: category,
                      child: Text(l10n.bookCategoryLabel(category.name)),
                    ),
                  ),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
          );

          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.libraryBooksCount(bookCount),
                style: smallStyle18.copyWith(
                  fontSize: 13,
                  color: isDark
                      ? CbsColors.darkTextSecondary
                      : CbsColors.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: l10n.refresh,
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh_rounded,
                  color:
                      isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                ),
              ),
            ],
          );

          final continueReadingChip = continueReading == null ||
                  onContinueReadingTap == null
              ? null
              : _DesktopContinueReadingChip(
                  entry: continueReading!,
                  l10n: l10n,
                  isDark: isDark,
                  onTap: onContinueReadingTap!,
                );

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                categoryFilter,
                if (continueReadingChip != null) ...[
                  const SizedBox(height: 12),
                  continueReadingChip,
                ],
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }

          return Row(
            children: [
              categoryFilter,
              if (continueReadingChip != null) ...[
                const SizedBox(width: 12),
                Expanded(child: continueReadingChip),
              ] else
                const Spacer(),
              const SizedBox(width: 12),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _DesktopContinueReadingChip extends StatelessWidget {
  const _DesktopContinueReadingChip({
    required this.entry,
    required this.l10n,
    required this.isDark,
    required this.onTap,
  });

  final ContinueReadingEntry entry;
  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final book = entry.book;
    final title = (book.title ?? '').trim();
    final progress = entry.progress.clamp(0.0, 1.0);
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final borderColor = isDark
        ? CbsColors.goldDeep.withValues(alpha: 0.55)
        : CbsColors.primaryBrown.withValues(alpha: 0.18);
    final fillColor =
        isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? CbsColors.darkSurface
                      : CbsColors.primaryBrown.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasCover
                    ? Image.network(
                        book.bookCover!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _coverFallback(),
                      )
                    : _coverFallback(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.continueReading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: verySmallStyle10.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? CbsColors.brandGold
                            : CbsColors.primaryBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title.isEmpty ? l10n.dash : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: verySmallStyle12.copyWith(
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: isDark
                            ? CbsColors.darkProgressBg
                            : CbsColors.primaryBrown.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? CbsColors.brandGold
                              : CbsColors.primaryBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverFallback() {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 16,
        color: CbsColors.primaryBrown.withValues(alpha: 0.55),
      ),
    );
  }
}

class _LibraryDesktopBookCard extends StatelessWidget {
  const _LibraryDesktopBookCard({
    required this.book,
    required this.l10n,
    required this.isDark,
    required this.onPressed,
  });

  final LibraryData book;
  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final category = book.category;
    final languageLabel = bookLanguageBadgeLabel(book.language, l10n);
    final cardColor = isDark ? CbsColors.darkElevated : const Color(0xFFFBF7F1);
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.16);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : const Color(0xFF2A1608);
    final subtitleColor =
        isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: AspectRatio(
                    aspectRatio: 5 / 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? CbsColors.darkSurface
                            : CbsColors.primaryBrown.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.8),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasCover
                          ? Image.network(
                              book.bookCover!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _coverFallback(),
                            )
                          : _coverFallback(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? l10n.dash : title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.25,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author.isEmpty
                          ? l10n.authorUnknown
                          : l10n.authorPrefix(author),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontSize: 11,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (category != null)
                          _BookMetaChip(
                            label: l10n.bookCategoryLabel(category.name),
                            isDark: isDark,
                          ),
                        if (languageLabel != null)
                          _BookMetaChip(
                            label: languageLabel,
                            isDark: isDark,
                            accent: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverFallback() {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 32,
        color: CbsColors.brandGold.withValues(alpha: 0.7),
      ),
    );
  }
}

class _BookMetaChip extends StatelessWidget {
  const _BookMetaChip({
    required this.label,
    required this.isDark,
    this.accent = false,
  });

  final String label;
  final bool isDark;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: accent
            ? (isDark
                ? CbsColors.brandGold.withValues(alpha: 0.16)
                : CbsColors.goldPale)
            : (isDark
                ? CbsColors.darkSurface
                : CbsColors.primaryBrown.withValues(alpha: 0.06)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: accent
              ? (isDark
                  ? CbsColors.brandGold.withValues(alpha: 0.45)
                  : CbsColors.primaryBrown.withValues(alpha: 0.2))
              : (isDark
                  ? CbsColors.darkBorder.withValues(alpha: 0.9)
                  : CbsColors.primaryBrown.withValues(alpha: 0.14)),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: verySmallStyle10.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: accent
              ? (isDark ? CbsColors.brandGold : CbsColors.primaryBrown)
              : (isDark
                  ? CbsColors.darkTextSecondary
                  : CbsColors.hintColor),
        ),
      ),
    );
  }
}
