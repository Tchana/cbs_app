import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_data.freezed.dart';
part 'message_data.g.dart';

@freezed
class MessageData with _$MessageData {
  const MessageData._();

  const factory MessageData({
    String? uuid,
    String? room,
    String? content,
    String? created_at,
    String? created_by,
    String? sender_name,
    String? sender_email,
    bool? is_deleted,
    String? deleted_at,
    String? deleted_by,
  }) = _MessageData;

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);
}

