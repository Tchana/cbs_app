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
    @JsonKey(name: 'learning_objectives') String? learningObjectives,
    String? courseCover,
    bool? isEnrolled,
    @JsonKey(name: 'overview_videos')
    List<CourseOverviewVideoData>? overviewVideos,
    List<LessonData>? lessons,
  }) = _CourseData;

  factory CourseData.fromJson(Map<String, dynamic> json) =>
      _$CourseDataFromJson(json);
}

@freezed
abstract class CourseOverviewVideoData with _$CourseOverviewVideoData {
  const CourseOverviewVideoData._();

  const factory CourseOverviewVideoData({
    String? id,
    String? title,
    String? url,
    @JsonKey(name: 'sort_order') int? sortOrder,
  }) = _CourseOverviewVideoData;

  factory CourseOverviewVideoData.fromJson(Map<String, dynamic> json) =>
      _$CourseOverviewVideoDataFromJson(json);
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
    List<LessonResourceData>? resources,
  }) = _LessonData;

  factory LessonData.fromJson(Map<String, dynamic> json) =>
      _$LessonDataFromJson(json);
}

@freezed
abstract class LessonResourceData with _$LessonResourceData {
  const LessonResourceData._();

  const factory LessonResourceData({
    String? id,
    @JsonKey(name: 'lesson_id') String? lessonId,
    @JsonKey(name: 'resource_type') String? resourceType,
    String? title,
    String? url,
    @JsonKey(name: 'source_kind') String? sourceKind,
    @JsonKey(name: 'sort_order') int? sortOrder,
  }) = _LessonResourceData;

  factory LessonResourceData.fromJson(Map<String, dynamic> json) =>
      _$LessonResourceDataFromJson(json);
}

@freezed
abstract class CourseCommentData with _$CourseCommentData {
  const CourseCommentData._();

  const factory CourseCommentData({
    String? id,
    @JsonKey(name: 'course_id') String? courseId,
    @JsonKey(name: 'user_id') String? userId,
    String? content,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    String? authorName,
    String? authorRole,
  }) = _CourseCommentData;

  factory CourseCommentData.fromJson(Map<String, dynamic> json) =>
      _$CourseCommentDataFromJson(json);
}
