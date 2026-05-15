import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put(DataController());
  });

  testWidgets('LessonPage renders description and no inline back button',
      (tester) async {
    const course = CourseData(
      title: 'Intro to Theology',
      description: 'Foundational principles',
      lessons: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LessonPage(courseData: course),
        ),
      ),
    );

    expect(find.text('Foundational principles'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
  });
}
