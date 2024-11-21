import 'package:center_for_biblical_studies/shared/book_card.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/shared/tab_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  int _widgetIndex = 0;

  void _nextPage() {
    setState(() {
      _widgetIndex++;
    });
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
              SectionHeader(
                title: "Bibles",
                moreText: "",
              ),
              gapH8,
              Divider(
                color: CbsColors.primaryDark,
              ),
              gapH8,
              TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white70.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
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
                                  itemCount: 5,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return BookCard(
                                      title: "English Standard version",
                                      bookImage: "",
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      gapH12,
                      Column(
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
                                itemCount: 5,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return BookCard(
                                    title: "Francais courant",
                                    bookImage: "",
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return CourseCard(
                          onPressed: _nextPage,
                        );
                      }),
                  ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return CourseCard(
                          onPressed: _nextPage,
                        );
                      }),
                  ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return CourseCard(
                          onPressed: _nextPage,
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
