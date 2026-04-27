import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/dashboard/dashboard_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeDashboardSupabaseService extends SupabaseService {
  const _FakeDashboardSupabaseService();
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('Dashboard greeting has no comma when username is empty',
      (tester) async {
    final dc = Get.put(DataController());
    dc.setCourses(const [
      CourseData(
        id: 'c1',
        title: 'Test Course',
        description: 'Course description',
        lessons: [],
      ),
    ]);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('fr')],
        home: DashboardPage(
          apiService: _FakeDashboardSupabaseService(),
          enableProfileLoad: false,
          enableVerseLoad: false,
        ),
      ),
    );

    await tester.pumpAndSettle();

    final hour = DateTime.now().hour;
    final expectedGreeting = hour < 12
        ? 'Good morning'
        : (hour < 18 ? 'Good afternoon' : 'Good evening');
    expect(find.text(expectedGreeting), findsOneWidget);
    expect(find.textContaining('$expectedGreeting,'), findsNothing);
  });

  testWidgets('Dashboard course card navigates to course details page',
      (tester) async {
    final dc = Get.put(DataController());
    dc.setCourses(const [
      CourseData(
        id: 'c1',
        title: 'Apologetics 101',
        description: 'Basics',
        lessons: [],
      ),
    ]);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('fr')],
        home: DashboardPage(
          apiService: _FakeDashboardSupabaseService(),
          enableProfileLoad: false,
          enableVerseLoad: false,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Apologetics 101'));
    await tester.pumpAndSettle();

    expect(find.text('Apologetics 101'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
  });
}
