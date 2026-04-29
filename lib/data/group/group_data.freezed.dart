// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupData {

 String? get uuid; String? get name; String? get description; String? get created_at; String? get created_by; bool? get is_private; bool? get is_deleted; String? get deleted_at; String? get deleted_by; int? get participants_count; int? get online_count; bool? get can_delete;
/// Create a copy of GroupData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupDataCopyWith<GroupData> get copyWith => _$GroupDataCopyWithImpl<GroupData>(this as GroupData, _$identity);

  /// Serializes this GroupData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupData&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.created_by, created_by) || other.created_by == created_by)&&(identical(other.is_private, is_private) || other.is_private == is_private)&&(identical(other.is_deleted, is_deleted) || other.is_deleted == is_deleted)&&(identical(other.deleted_at, deleted_at) || other.deleted_at == deleted_at)&&(identical(other.deleted_by, deleted_by) || other.deleted_by == deleted_by)&&(identical(other.participants_count, participants_count) || other.participants_count == participants_count)&&(identical(other.online_count, online_count) || other.online_count == online_count)&&(identical(other.can_delete, can_delete) || other.can_delete == can_delete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name,description,created_at,created_by,is_private,is_deleted,deleted_at,deleted_by,participants_count,online_count,can_delete);

@override
String toString() {
  return 'GroupData(uuid: $uuid, name: $name, description: $description, created_at: $created_at, created_by: $created_by, is_private: $is_private, is_deleted: $is_deleted, deleted_at: $deleted_at, deleted_by: $deleted_by, participants_count: $participants_count, online_count: $online_count, can_delete: $can_delete)';
}


}

/// @nodoc
abstract mixin class $GroupDataCopyWith<$Res>  {
  factory $GroupDataCopyWith(GroupData value, $Res Function(GroupData) _then) = _$GroupDataCopyWithImpl;
@useResult
$Res call({
 String? uuid, String? name, String? description, String? created_at, String? created_by, bool? is_private, bool? is_deleted, String? deleted_at, String? deleted_by, int? participants_count, int? online_count, bool? can_delete
});




}
/// @nodoc
class _$GroupDataCopyWithImpl<$Res>
    implements $GroupDataCopyWith<$Res> {
  _$GroupDataCopyWithImpl(this._self, this._then);

  final GroupData _self;
  final $Res Function(GroupData) _then;

/// Create a copy of GroupData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = freezed,Object? name = freezed,Object? description = freezed,Object? created_at = freezed,Object? created_by = freezed,Object? is_private = freezed,Object? is_deleted = freezed,Object? deleted_at = freezed,Object? deleted_by = freezed,Object? participants_count = freezed,Object? online_count = freezed,Object? can_delete = freezed,}) {
  return _then(_self.copyWith(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,created_at: freezed == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String?,created_by: freezed == created_by ? _self.created_by : created_by // ignore: cast_nullable_to_non_nullable
as String?,is_private: freezed == is_private ? _self.is_private : is_private // ignore: cast_nullable_to_non_nullable
as bool?,is_deleted: freezed == is_deleted ? _self.is_deleted : is_deleted // ignore: cast_nullable_to_non_nullable
as bool?,deleted_at: freezed == deleted_at ? _self.deleted_at : deleted_at // ignore: cast_nullable_to_non_nullable
as String?,deleted_by: freezed == deleted_by ? _self.deleted_by : deleted_by // ignore: cast_nullable_to_non_nullable
as String?,participants_count: freezed == participants_count ? _self.participants_count : participants_count // ignore: cast_nullable_to_non_nullable
as int?,online_count: freezed == online_count ? _self.online_count : online_count // ignore: cast_nullable_to_non_nullable
as int?,can_delete: freezed == can_delete ? _self.can_delete : can_delete // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupData].
extension GroupDataPatterns on GroupData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupData value)  $default,){
final _that = this;
switch (_that) {
case _GroupData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupData value)?  $default,){
final _that = this;
switch (_that) {
case _GroupData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uuid,  String? name,  String? description,  String? created_at,  String? created_by,  bool? is_private,  bool? is_deleted,  String? deleted_at,  String? deleted_by,  int? participants_count,  int? online_count,  bool? can_delete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupData() when $default != null:
return $default(_that.uuid,_that.name,_that.description,_that.created_at,_that.created_by,_that.is_private,_that.is_deleted,_that.deleted_at,_that.deleted_by,_that.participants_count,_that.online_count,_that.can_delete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uuid,  String? name,  String? description,  String? created_at,  String? created_by,  bool? is_private,  bool? is_deleted,  String? deleted_at,  String? deleted_by,  int? participants_count,  int? online_count,  bool? can_delete)  $default,) {final _that = this;
switch (_that) {
case _GroupData():
return $default(_that.uuid,_that.name,_that.description,_that.created_at,_that.created_by,_that.is_private,_that.is_deleted,_that.deleted_at,_that.deleted_by,_that.participants_count,_that.online_count,_that.can_delete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uuid,  String? name,  String? description,  String? created_at,  String? created_by,  bool? is_private,  bool? is_deleted,  String? deleted_at,  String? deleted_by,  int? participants_count,  int? online_count,  bool? can_delete)?  $default,) {final _that = this;
switch (_that) {
case _GroupData() when $default != null:
return $default(_that.uuid,_that.name,_that.description,_that.created_at,_that.created_by,_that.is_private,_that.is_deleted,_that.deleted_at,_that.deleted_by,_that.participants_count,_that.online_count,_that.can_delete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupData extends GroupData {
  const _GroupData({this.uuid, this.name, this.description, this.created_at, this.created_by, this.is_private, this.is_deleted, this.deleted_at, this.deleted_by, this.participants_count, this.online_count, this.can_delete}): super._();
  factory _GroupData.fromJson(Map<String, dynamic> json) => _$GroupDataFromJson(json);

@override final  String? uuid;
@override final  String? name;
@override final  String? description;
@override final  String? created_at;
@override final  String? created_by;
@override final  bool? is_private;
@override final  bool? is_deleted;
@override final  String? deleted_at;
@override final  String? deleted_by;
@override final  int? participants_count;
@override final  int? online_count;
@override final  bool? can_delete;

/// Create a copy of GroupData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupDataCopyWith<_GroupData> get copyWith => __$GroupDataCopyWithImpl<_GroupData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupData&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.created_by, created_by) || other.created_by == created_by)&&(identical(other.is_private, is_private) || other.is_private == is_private)&&(identical(other.is_deleted, is_deleted) || other.is_deleted == is_deleted)&&(identical(other.deleted_at, deleted_at) || other.deleted_at == deleted_at)&&(identical(other.deleted_by, deleted_by) || other.deleted_by == deleted_by)&&(identical(other.participants_count, participants_count) || other.participants_count == participants_count)&&(identical(other.online_count, online_count) || other.online_count == online_count)&&(identical(other.can_delete, can_delete) || other.can_delete == can_delete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name,description,created_at,created_by,is_private,is_deleted,deleted_at,deleted_by,participants_count,online_count,can_delete);

@override
String toString() {
  return 'GroupData(uuid: $uuid, name: $name, description: $description, created_at: $created_at, created_by: $created_by, is_private: $is_private, is_deleted: $is_deleted, deleted_at: $deleted_at, deleted_by: $deleted_by, participants_count: $participants_count, online_count: $online_count, can_delete: $can_delete)';
}


}

/// @nodoc
abstract mixin class _$GroupDataCopyWith<$Res> implements $GroupDataCopyWith<$Res> {
  factory _$GroupDataCopyWith(_GroupData value, $Res Function(_GroupData) _then) = __$GroupDataCopyWithImpl;
@override @useResult
$Res call({
 String? uuid, String? name, String? description, String? created_at, String? created_by, bool? is_private, bool? is_deleted, String? deleted_at, String? deleted_by, int? participants_count, int? online_count, bool? can_delete
});




}
/// @nodoc
class __$GroupDataCopyWithImpl<$Res>
    implements _$GroupDataCopyWith<$Res> {
  __$GroupDataCopyWithImpl(this._self, this._then);

  final _GroupData _self;
  final $Res Function(_GroupData) _then;

/// Create a copy of GroupData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = freezed,Object? name = freezed,Object? description = freezed,Object? created_at = freezed,Object? created_by = freezed,Object? is_private = freezed,Object? is_deleted = freezed,Object? deleted_at = freezed,Object? deleted_by = freezed,Object? participants_count = freezed,Object? online_count = freezed,Object? can_delete = freezed,}) {
  return _then(_GroupData(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,created_at: freezed == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String?,created_by: freezed == created_by ? _self.created_by : created_by // ignore: cast_nullable_to_non_nullable
as String?,is_private: freezed == is_private ? _self.is_private : is_private // ignore: cast_nullable_to_non_nullable
as bool?,is_deleted: freezed == is_deleted ? _self.is_deleted : is_deleted // ignore: cast_nullable_to_non_nullable
as bool?,deleted_at: freezed == deleted_at ? _self.deleted_at : deleted_at // ignore: cast_nullable_to_non_nullable
as String?,deleted_by: freezed == deleted_by ? _self.deleted_by : deleted_by // ignore: cast_nullable_to_non_nullable
as String?,participants_count: freezed == participants_count ? _self.participants_count : participants_count // ignore: cast_nullable_to_non_nullable
as int?,online_count: freezed == online_count ? _self.online_count : online_count // ignore: cast_nullable_to_non_nullable
as int?,can_delete: freezed == can_delete ? _self.can_delete : can_delete // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
