import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/services/authentication.dart';
import 'package:center_for_biblical_studies/shared/book_card.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/shared/tab_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  final ApiService apiService = ApiService();
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
  initState() {
    if (dataController.books.isEmpty) {
      fetchData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 60,
          ),
          child: Column(
            children: [
              gapH16,
              PageHeader(
                title: 'Bibliotheque',
                titleIcon: const Icon(
                  Icons.library_books,
                  color: CbsColors.primaryBlue,
                ),
              ),
              gapH32,
              Theme(
                data: ThemeData(),
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0,
                  isScrollable: true,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: CbsColors.primaryBlue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  unselectedLabelColor: CbsColors.primaryBlue,
                  labelColor: CbsColors.white,
                  tabs: [
                    Tab(
                      child: TabButton(label: "Tout"),
                    ),
                    Tab(
                      child: TabButton(label: "Bibles"),
                    ),
                    Tab(
                      child: TabButton(label: "Livres"),
                    ),
                    Tab(
                      child: TabButton(label: "Dictionnaires"),
                    ),
                  ],
                ),
              ),
              gapH20,
              SizedBox(
                height: 606,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        SectionHeader(
                          title: "Bibles",
                          moreText: "",
                        ),
                        Divider(
                          color: CbsColors.primaryDark,
                          thickness: 3,
                        ),
                        gapH16,
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFF4F8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ENG"),
                                gapH12,
                                SizedBox(
                                  height: 175,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dataController.books.length,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return BookCard(
                                          book: dataController.books[index],
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        gapH12,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("FR"),
                              gapH12,
                              SizedBox(
                                height: 175,
                                width: double.infinity,
                                child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dataController.books.length,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return BookCard(
                                        book: dataController.books[index],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      children: dataController.books
                              .where((book) => book.category == BookType.bible)
                              .map((book) {
                                return BookItem(book: book);
                              })
                              .toList()
                              .isEmpty
                          ? [Center(child: Text('No items found'))]
                          : dataController.books
                              .where((book) => book.category == BookType.bible)
                              .map((book) {
                              return BookItem(book: book);
                            }).toList(),
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      children: dataController.books
                              .where((book) =>
                                  book.category == BookType.commentary)
                              .map((book) {
                                return BookItem(book: book);
                              })
                              .toList()
                              .isEmpty
                          ? [Center(child: Text('No items found'))]
                          : dataController.books
                              .where((book) =>
                                  book.category == BookType.commentary)
                              .map((book) {
                              return BookItem(book: book);
                            }).toList(),
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      children: dataController.books
                              .where((book) =>
                                  book.category == BookType.dictionnaire)
                              .map((book) {
                                return BookItem(book: book);
                              })
                              .toList()
                              .isEmpty
                          ? [Center(child: Text('No items found'))]
                          : dataController.books
                              .where((book) =>
                                  book.category == BookType.dictionnaire)
                              .map((book) {
                              return BookItem(book: book);
                            }).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
