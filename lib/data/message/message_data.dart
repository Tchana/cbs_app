import 'package:center_for_biblical_studies/data/message/user_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_data.freezed.dart';
part 'message_data.g.dart';

@freezed
class MessageData with _$MessageData {
  const MessageData._();

  const factory MessageData({
    String? uuid,
    String? room,
    UserData? user,
    String? content,
    String? timestamp,
    String? message_type,
    bool? is_deleted,
    String? deleted_at,
  }) = _MessageData;

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);
}
