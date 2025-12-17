// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageData _$MessageDataFromJson(Map<String, dynamic> json) {
  return _MessageData.fromJson(json);
}

/// @nodoc
mixin _$MessageData {
  String? get uuid => throw _privateConstructorUsedError;
  String? get room => throw _privateConstructorUsedError;
  UserData? get user => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get timestamp => throw _privateConstructorUsedError;
  String? get message_type => throw _privateConstructorUsedError;
  bool? get is_deleted => throw _privateConstructorUsedError;
  String? get deleted_at => throw _privateConstructorUsedError;

  /// Serializes this MessageData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageDataCopyWith<MessageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDataCopyWith<$Res> {
  factory $MessageDataCopyWith(
          MessageData value, $Res Function(MessageData) then) =
      _$MessageDataCopyWithImpl<$Res, MessageData>;
  @useResult
  $Res call(
      {String? uuid,
      String? room,
      UserData? user,
      String? content,
      String? timestamp,
      String? message_type,
      bool? is_deleted,
      String? deleted_at});

  $UserDataCopyWith<$Res>? get user;
}

/// @nodoc
class _$MessageDataCopyWithImpl<$Res, $Val extends MessageData>
    implements $MessageDataCopyWith<$Res> {
  _$MessageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? room = freezed,
    Object? user = freezed,
    Object? content = freezed,
    Object? timestamp = freezed,
    Object? message_type = freezed,
    Object? is_deleted = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      room: freezed == room
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      message_type: freezed == message_type
          ? _value.message_type
          : message_type // ignore: cast_nullable_to_non_nullable
              as String?,
      is_deleted: freezed == is_deleted
          ? _value.is_deleted
          : is_deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserDataCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDataImplCopyWith<$Res>
    implements $MessageDataCopyWith<$Res> {
  factory _$$MessageDataImplCopyWith(
          _$MessageDataImpl value, $Res Function(_$MessageDataImpl) then) =
      __$$MessageDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uuid,
      String? room,
      UserData? user,
      String? content,
      String? timestamp,
      String? message_type,
      bool? is_deleted,
      String? deleted_at});

  @override
  $UserDataCopyWith<$Res>? get user;
}

/// @nodoc
class __$$MessageDataImplCopyWithImpl<$Res>
    extends _$MessageDataCopyWithImpl<$Res, _$MessageDataImpl>
    implements _$$MessageDataImplCopyWith<$Res> {
  __$$MessageDataImplCopyWithImpl(
      _$MessageDataImpl _value, $Res Function(_$MessageDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? room = freezed,
    Object? user = freezed,
    Object? content = freezed,
    Object? timestamp = freezed,
    Object? message_type = freezed,
    Object? is_deleted = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$MessageDataImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      room: freezed == room
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      message_type: freezed == message_type
          ? _value.message_type
          : message_type // ignore: cast_nullable_to_non_nullable
              as String?,
      is_deleted: freezed == is_deleted
          ? _value.is_deleted
          : is_deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDataImpl extends _MessageData {
  const _$MessageDataImpl(
      {this.uuid,
      this.room,
      this.user,
      this.content,
      this.timestamp,
      this.message_type,
      this.is_deleted,
      this.deleted_at})
      : super._();

  factory _$MessageDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDataImplFromJson(json);

  @override
  final String? uuid;
  @override
  final String? room;
  @override
  final UserData? user;
  @override
  final String? content;
  @override
  final String? timestamp;
  @override
  final String? message_type;
  @override
  final bool? is_deleted;
  @override
  final String? deleted_at;

  @override
  String toString() {
    return 'MessageData(uuid: $uuid, room: $room, user: $user, content: $content, timestamp: $timestamp, message_type: $message_type, is_deleted: $is_deleted, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDataImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.message_type, message_type) ||
                other.message_type == message_type) &&
            (identical(other.is_deleted, is_deleted) ||
                other.is_deleted == is_deleted) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, room, user, content,
      timestamp, message_type, is_deleted, deleted_at);

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDataImplCopyWith<_$MessageDataImpl> get copyWith =>
      __$$MessageDataImplCopyWithImpl<_$MessageDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDataImplToJson(
      this,
    );
  }
}

abstract class _MessageData extends MessageData {
  const factory _MessageData(
      {final String? uuid,
      final String? room,
      final UserData? user,
      final String? content,
      final String? timestamp,
      final String? message_type,
      final bool? is_deleted,
      final String? deleted_at}) = _$MessageDataImpl;
  const _MessageData._() : super._();

  factory _MessageData.fromJson(Map<String, dynamic> json) =
      _$MessageDataImpl.fromJson;

  @override
  String? get uuid;
  @override
  String? get room;
  @override
  UserData? get user;
  @override
  String? get content;
  @override
  String? get timestamp;
  @override
  String? get message_type;
  @override
  bool? get is_deleted;
  @override
  String? get deleted_at;

  /// Create a copy of MessageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageDataImplCopyWith<_$MessageDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
