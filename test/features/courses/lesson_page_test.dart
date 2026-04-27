import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LessonPage renders description and no inline back button',
      (tester) async {
    const course = CourseData(
      title: 'Intro to Theology',
      description: 'Foundational principles',
      lessons: [],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LessonPage(courseData: course),
        ),
      ),
    );

    expect(find.text('Foundational principles'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
  });
}
