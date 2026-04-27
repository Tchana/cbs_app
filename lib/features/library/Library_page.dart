import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/features/courses/pdf_viewer.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  TabController? _tabController;
  List<BookType> _categories = const [
    BookType.bible,
    BookType.commentary,
    BookType.dictionnaire,
  ];

  void fetchData() async {
    final dataController = Get.find<DataController>();
    try {
      final books = await apiService.fetchBooks();
      dataController.setBooks(books);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Handle errors if needed
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await apiService.fetchBookCategories();
      debugPrint(
        '[LibraryPage] fetched categories: ${categories.map((c) => c.name).toList()}',
      );
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
    } catch (e) {
      debugPrint('Failed to fetch enum categories from Supabase: $e');
      _rebuildTabController();
    }
  }

  void _rebuildTabController() {
    _tabController?.dispose();
    _tabController = TabController(length: _categories.length + 1, vsync: this);
    if (mounted) setState(() {});
  }

  void _openBook(LibraryData book, AppLocalizations l10n) {
    final url = (book.book ?? '').trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noItemsFound)),
      );
      return;
    }
    Get.to(() => PdfViewerScreen(pdfUrl: url));
  }

  @override
  void initState() {
    _rebuildTabController();
    _loadCategories();
    if (dataController.books.isEmpty) {
      fetchData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.library,
          style: smallStyle18.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gapH20,
            // Tabs - compact, less circular
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CbsColors.primaryBrown.withValues(alpha: 0.18),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0,
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: CbsColors.primaryBrown,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  labelColor: CbsColors.white,
                  unselectedLabelColor:
                      CbsColors.primaryBrown.withValues(alpha: 0.85),
                  labelStyle: smallStyle18.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: smallStyle18.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: CbsColors.primaryBrown.withValues(alpha: 0.85),
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
      ),
    );
  }

  Widget _buildAllTab(AppLocalizations l10n) {
    final items = dataController.books.toList();
    if (items.isEmpty) {
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

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (_, index) => BookItem(
              book: items[index],
              onPressed: () => _openBook(items[index], l10n),
            ),
          ),
        ),
        if (dataController.books.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildContinueReading(l10n),
        ],
      ],
    );
  }

  Widget _buildContinueReading(AppLocalizations l10n) {
    final book = dataController.books.first;
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final progress = 0.38;
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CbsColors.darkSurface : CbsColors.white;
    final titleColor = isDark ? CbsColors.darkText : CbsColors.primaryDark[800];
    final subtitleColor = isDark ? CbsColors.darkHint : CbsColors.hintColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue reading',
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
                  border: Border.all(
                    color: CbsColors.primaryBrown.withValues(alpha: 0.14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 64,
                        width: 46,
                        decoration: BoxDecoration(
                          color: CbsColors.primaryBrown.withValues(alpha: 0.10),
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
                              title.isEmpty ? '—' : title,
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
                              author.isEmpty ? 'Author: —' : 'Author: $author',
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
                                backgroundColor: CbsColors.primaryBrown
                                    .withValues(alpha: 0.15),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  CbsColors.primaryBrown,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progress * 100).round()}%',
                              style: smallStyle18.copyWith(
                                color: CbsColors.primaryBrown,
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
      ),
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
    final items = dataController.books
        .where((book) => book.category == category)
        .toList();

    if (items.isEmpty) {
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

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (_, index) => BookItem(
              book: items[index],
              onPressed: () => _openBook(items[index], l10n),
            ),
          ),
        ),
        if (dataController.books.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildContinueReading(l10n),
        ],
      ],
    );
  }

  String _categoryLabel(BookType category, AppLocalizations l10n) {
    return category.name;
  }

  SupabaseService get apiService => widget.apiService;
}
