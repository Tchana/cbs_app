import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/book_card.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  final SupabaseService apiService = SupabaseService();
  final DataController dataController = Get.find<DataController>();

  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  void fetchData() async {
    final dataController = Get.find<DataController>();
    try {
      final books = await apiService.fetchBooks();
      dataController.setBooks(books);
    } catch (e) {
      // Handle errors if needed
    }
  }

  @override
  void initState() {
    if (dataController.books.isEmpty) {
      fetchData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gapH16,
            PageHeader(
              title: l10n.library,
              titleIcon: const Icon(
                Icons.library_books_rounded,
                color: CbsColors.primaryBrown,
              ),
            ),
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
                  tabAlignment: TabAlignment.fill,
                  dividerHeight: 0,
                  controller: _tabController,
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
                  unselectedLabelColor: CbsColors.primaryBrown.withValues(alpha: 0.85),
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
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  padding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: l10n.tabAll),
                    Tab(text: l10n.tabBibles),
                    Tab(text: l10n.tabBooks),
                    Tab(text: l10n.tabDictionaries),
                  ],
                ),
              ),
            ),
            gapH16,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllTab(l10n),
                  _buildCategoryTab(BookType.bible, l10n),
                  _buildCategoryTab(BookType.commentary, l10n),
                  _buildCategoryTab(BookType.dictionnaire, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTab(AppLocalizations l10n) {
    final bibles = dataController.books
        .where((b) => b.category == BookType.bible)
        .toList();
    final engBibles =
        bibles.where((b) => (b.language ?? '').toUpperCase() == 'ENG').toList();
    final frBibles =
        bibles.where((b) => (b.language ?? '').toUpperCase() != 'ENG').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (engBibles.isNotEmpty) ...[
            _sectionTitle(l10n.sectionBibles, 'ENG'),
            gapH12,
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: engBibles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) => BookCard(book: engBibles[index]),
              ),
            ),
            gapH24,
          ],
          if (frBibles.isNotEmpty) ...[
            _sectionTitle(l10n.sectionBibles, 'FR'),
            gapH12,
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: frBibles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) => BookCard(book: frBibles[index]),
              ),
            ),
            gapH24,
          ],
          if (bibles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Center(
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
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String sectionName, String lang) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CbsColors.primaryBrown.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$sectionName · $lang',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: CbsColors.primaryBrown,
              fontSize: 14,
            ),
          ),
        ),
      ],
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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) => BookItem(book: items[index]),
    );
  }
}
