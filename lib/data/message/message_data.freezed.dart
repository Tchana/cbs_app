// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageData {

 String? get uuid; String? get room; UserData? get user; String? get content; String? get timestamp; String? get message_type; bool? get is_deleted; String? get deleted_at;
/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDataCopyWith<MessageData> get copyWith => _$MessageDataCopyWithImpl<MessageData>(this as MessageData, _$identity);

  /// Serializes this MessageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageData&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.room, room) || other.room == room)&&(identical(other.user, user) || other.user == user)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message_type, message_type) || other.message_type == message_type)&&(identical(other.is_deleted, is_deleted) || other.is_deleted == is_deleted)&&(identical(other.deleted_at, deleted_at) || other.deleted_at == deleted_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,room,user,content,timestamp,message_type,is_deleted,deleted_at);

@override
String toString() {
  return 'MessageData(uuid: $uuid, room: $room, user: $user, content: $content, timestamp: $timestamp, message_type: $message_type, is_deleted: $is_deleted, deleted_at: $deleted_at)';
}


}

/// @nodoc
abstract mixin class $MessageDataCopyWith<$Res>  {
  factory $MessageDataCopyWith(MessageData value, $Res Function(MessageData) _then) = _$MessageDataCopyWithImpl;
@useResult
$Res call({
 String? uuid, String? room, UserData? user, String? content, String? timestamp, String? message_type, bool? is_deleted, String? deleted_at
});


$UserDataCopyWith<$Res>? get user;

}
/// @nodoc
class _$MessageDataCopyWithImpl<$Res>
    implements $MessageDataCopyWith<$Res> {
  _$MessageDataCopyWithImpl(this._self, this._then);

  final MessageData _self;
  final $Res Function(MessageData) _then;

/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = freezed,Object? room = freezed,Object? user = freezed,Object? content = freezed,Object? timestamp = freezed,Object? message_type = freezed,Object? is_deleted = freezed,Object? deleted_at = freezed,}) {
  return _then(_self.copyWith(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserData?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,message_type: freezed == message_type ? _self.message_type : message_type // ignore: cast_nullable_to_non_nullable
as String?,is_deleted: freezed == is_deleted ? _self.is_deleted : is_deleted // ignore: cast_nullable_to_non_nullable
as bool?,deleted_at: freezed == deleted_at ? _self.deleted_at : deleted_at // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserDataCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [MessageData].
extension MessageDataPatterns on MessageData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageData value)  $default,){
final _that = this;
switch (_that) {
case _MessageData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageData value)?  $default,){
final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uuid,  String? room,  UserData? user,  String? content,  String? timestamp,  String? message_type,  bool? is_deleted,  String? deleted_at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that.uuid,_that.room,_that.user,_that.content,_that.timestamp,_that.message_type,_that.is_deleted,_that.deleted_at);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uuid,  String? room,  UserData? user,  String? content,  String? timestamp,  String? message_type,  bool? is_deleted,  String? deleted_at)  $default,) {final _that = this;
switch (_that) {
case _MessageData():
return $default(_that.uuid,_that.room,_that.user,_that.content,_that.timestamp,_that.message_type,_that.is_deleted,_that.deleted_at);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uuid,  String? room,  UserData? user,  String? content,  String? timestamp,  String? message_type,  bool? is_deleted,  String? deleted_at)?  $default,) {final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that.uuid,_that.room,_that.user,_that.content,_that.timestamp,_that.message_type,_that.is_deleted,_that.deleted_at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageData extends MessageData {
  const _MessageData({this.uuid, this.room, this.user, this.content, this.timestamp, this.message_type, this.is_deleted, this.deleted_at}): super._();
  factory _MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);

@override final  String? uuid;
@override final  String? room;
@override final  UserData? user;
@override final  String? content;
@override final  String? timestamp;
@override final  String? message_type;
@override final  bool? is_deleted;
@override final  String? deleted_at;

/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDataCopyWith<_MessageData> get copyWith => __$MessageDataCopyWithImpl<_MessageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageData&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.room, room) || other.room == room)&&(identical(other.user, user) || other.user == user)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message_type, message_type) || other.message_type == message_type)&&(identical(other.is_deleted, is_deleted) || other.is_deleted == is_deleted)&&(identical(other.deleted_at, deleted_at) || other.deleted_at == deleted_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,room,user,content,timestamp,message_type,is_deleted,deleted_at);

@override
String toString() {
  return 'MessageData(uuid: $uuid, room: $room, user: $user, content: $content, timestamp: $timestamp, message_type: $message_type, is_deleted: $is_deleted, deleted_at: $deleted_at)';
}


}

/// @nodoc
abstract mixin class _$MessageDataCopyWith<$Res> implements $MessageDataCopyWith<$Res> {
  factory _$MessageDataCopyWith(_MessageData value, $Res Function(_MessageData) _then) = __$MessageDataCopyWithImpl;
@override @useResult
$Res call({
 String? uuid, String? room, UserData? user, String? content, String? timestamp, String? message_type, bool? is_deleted, String? deleted_at
});


@override $UserDataCopyWith<$Res>? get user;

}
/// @nodoc
class __$MessageDataCopyWithImpl<$Res>
    implements _$MessageDataCopyWith<$Res> {
  __$MessageDataCopyWithImpl(this._self, this._then);

  final _MessageData _self;
  final $Res Function(_MessageData) _then;

/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = freezed,Object? room = freezed,Object? user = freezed,Object? content = freezed,Object? timestamp = freezed,Object? message_type = freezed,Object? is_deleted = freezed,Object? deleted_at = freezed,}) {
  return _then(_MessageData(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserData?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,message_type: freezed == message_type ? _self.message_type : message_type // ignore: cast_nullable_to_non_nullable
as String?,is_deleted: freezed == is_deleted ? _self.is_deleted : is_deleted // ignore: cast_nullable_to_non_nullable
as bool?,deleted_at: freezed == deleted_at ? _self.deleted_at : deleted_at // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MessageData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserDataCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
