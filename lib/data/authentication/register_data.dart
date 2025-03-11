import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_data.freezed.dart';
part 'register_data.g.dart';

@freezed
class RegisterData with _$RegisterData {
  const RegisterData._();

  const factory RegisterData({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? pImage,
    String? role,
    List<CourseData>? course,
  }) = _RegisterData;

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);
}
