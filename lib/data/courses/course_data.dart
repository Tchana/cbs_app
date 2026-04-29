import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_data.freezed.dart';
part 'course_data.g.dart';

@freezed
abstract class CourseData with _$CourseData {
  const CourseData._();

  const factory CourseData({
    String? id,
    String? title,
    RegisterData? teacher,
    String? description,
    String? level,
    bool? isEnrolled,
    List<LessonData>? lessons,
  }) = _CourseData;

  factory CourseData.fromJson(Map<String, dynamic> json) =>
      _$CourseDataFromJson(json);
}

@freezed
abstract class LessonData with _$LessonData {
  const LessonData._();

  const factory LessonData({
    String? id,
    String? course,
    String? title,
    String? description,
    String? file,
  }) = _LessonData;

  factory LessonData.fromJson(Map<String, dynamic> json) =>
      _$LessonDataFromJson(json);
}
