import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_data.freezed.dart';
part 'teacher_data.g.dart';

@freezed
class TeacherData with _$TeacherData {
  const TeacherData._();

  const factory TeacherData({
    String? id,
    String? name,
    ProfileImage? profileImage,
    List<CourseData>? courses,
  }) = _TeacherData;

  factory TeacherData.fromJson(Map<String, dynamic> json) =>
      _$TeacherDataFromJson(json);
}

@freezed
class ProfileImage with _$ProfileImage {
  const ProfileImage._();

  const factory ProfileImage({
    String? id,
    String? url,
    String? text,
  }) = _ProfileImage;

  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageFromJson(json);
}
