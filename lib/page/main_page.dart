import 'package:center_for_biblical_studies/features/courses/courses_page.dart';
import 'package:center_for_biblical_studies/features/dashboard/dashboard_page.dart';
import 'package:center_for_biblical_studies/features/forum/forum_pages.dart';
import 'package:center_for_biblical_studies/features/library/Library_page.dart';
import 'package:center_for_biblical_studies/features/menu/menu.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    DashboardPage(),
    LibraryPage(),
    CoursesPage(),
    ForumPage(),
    Menu(),
  ];

  int currentStep = 0;
  void onTap(int index) {
    setState(() {
      currentStep = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentStep],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentStep,
        selectedItemColor: CbsColors.primaryBrown,
        unselectedItemColor: CbsColors.primaryBrown.withOpacity(0.5),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            label: "Acceuil",
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: "Bibliotheque",
            icon: Icon(Icons.my_library_books_rounded),
          ),
          BottomNavigationBarItem(
            label: "Cours",
            icon: Icon(Icons.school),
          ),
          BottomNavigationBarItem(
            label: "Forum",
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: "Menu",
            icon: Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
