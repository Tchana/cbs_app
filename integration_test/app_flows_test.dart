import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/authentication/auth_choice_page.dart';
import 'package:center_for_biblical_studies/features/dashboard/dashboard_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

class _FakeDashboardSupabaseService extends SupabaseService {
  const _FakeDashboardSupabaseService();
}

Widget _appHarness(Widget home) {
  return GetMaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('fr')],
    locale: const Locale('en'),
    home: home,
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('Auth choice exposes both sign in and sign up actions',
      (tester) async {
    await tester.pumpWidget(_appHarness(const AuthChoicePage()));
    await tester.pumpAndSettle();

    final filledButtons = find.byType(FilledButton);
    final outlinedButtons = find.byType(OutlinedButton);
    expect(filledButtons, findsOneWidget);
    expect(outlinedButtons, findsOneWidget);
  });

  testWidgets('Dashboard course opens course details flow', (tester) async {
    final dc = Get.put(DataController());
    dc.setCourses(const [
      CourseData(
        id: 'course-1',
        title: 'Biblical Hermeneutics',
        description: 'Course intro',
        lessons: [],
      ),
    ]);

    await tester.pumpWidget(
      _appHarness(
        const DashboardPage(
          apiService: _FakeDashboardSupabaseService(),
          enableProfileLoad: false,
          enableVerseLoad: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Biblical Hermeneutics'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Biblical Hermeneutics'), findsWidgets);
  });
}
