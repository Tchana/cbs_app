import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_data.freezed.dart';
part 'group_data.g.dart';

@freezed
class GroupData with _$GroupData {
  const GroupData._();

  const factory GroupData({
    String? uuid,
    String? name,
    String? description,
    String? created_at,
    String? created_by,
    bool? is_private,
    bool? is_deleted,
    String? deleted_at,
    String? deleted_by,
    int? participants_count,
    int? online_count,
    bool? can_delete,
  }) = _GroupData;

  factory GroupData.fromJson(Map<String, dynamic> json) =>
      _$GroupDataFromJson(json);
}

