// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class UserData with _$UserData {
  const UserData._();

  const factory UserData({
    String? uuid,
    String? firstName,
    String? email,
    String? lastName,
    String? bio,
    bool? online_status,
    String? last_seen,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
