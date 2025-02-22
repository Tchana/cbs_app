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
    String? p_image,
    String? role,
  }) = _RegisterData;

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);
}
