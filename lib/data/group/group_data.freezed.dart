// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupData _$GroupDataFromJson(Map<String, dynamic> json) {
  return _GroupData.fromJson(json);
}

/// @nodoc
mixin _$GroupData {
  String? get uuid => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get created_at => throw _privateConstructorUsedError;
  String? get created_by => throw _privateConstructorUsedError;
  bool? get is_private => throw _privateConstructorUsedError;
  bool? get is_deleted => throw _privateConstructorUsedError;
  String? get deleted_at => throw _privateConstructorUsedError;
  String? get deleted_by => throw _privateConstructorUsedError;
  int? get participants_count => throw _privateConstructorUsedError;
  int? get online_count => throw _privateConstructorUsedError;
  bool? get can_delete => throw _privateConstructorUsedError;

  /// Serializes this GroupData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupDataCopyWith<GroupData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupDataCopyWith<$Res> {
  factory $GroupDataCopyWith(GroupData value, $Res Function(GroupData) then) =
      _$GroupDataCopyWithImpl<$Res, GroupData>;
  @useResult
  $Res call(
      {String? uuid,
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
      bool? can_delete});
}

/// @nodoc
class _$GroupDataCopyWithImpl<$Res, $Val extends GroupData>
    implements $GroupDataCopyWith<$Res> {
  _$GroupDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? created_at = freezed,
    Object? created_by = freezed,
    Object? is_private = freezed,
    Object? is_deleted = freezed,
    Object? deleted_at = freezed,
    Object? deleted_by = freezed,
    Object? participants_count = freezed,
    Object? online_count = freezed,
    Object? can_delete = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: freezed == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String?,
      is_private: freezed == is_private
          ? _value.is_private
          : is_private // ignore: cast_nullable_to_non_nullable
              as bool?,
      is_deleted: freezed == is_deleted
          ? _value.is_deleted
          : is_deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as String?,
      participants_count: freezed == participants_count
          ? _value.participants_count
          : participants_count // ignore: cast_nullable_to_non_nullable
              as int?,
      online_count: freezed == online_count
          ? _value.online_count
          : online_count // ignore: cast_nullable_to_non_nullable
              as int?,
      can_delete: freezed == can_delete
          ? _value.can_delete
          : can_delete // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupDataImplCopyWith<$Res>
    implements $GroupDataCopyWith<$Res> {
  factory _$$GroupDataImplCopyWith(
          _$GroupDataImpl value, $Res Function(_$GroupDataImpl) then) =
      __$$GroupDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uuid,
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
      bool? can_delete});
}

/// @nodoc
class __$$GroupDataImplCopyWithImpl<$Res>
    extends _$GroupDataCopyWithImpl<$Res, _$GroupDataImpl>
    implements _$$GroupDataImplCopyWith<$Res> {
  __$$GroupDataImplCopyWithImpl(
      _$GroupDataImpl _value, $Res Function(_$GroupDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? created_at = freezed,
    Object? created_by = freezed,
    Object? is_private = freezed,
    Object? is_deleted = freezed,
    Object? deleted_at = freezed,
    Object? deleted_by = freezed,
    Object? participants_count = freezed,
    Object? online_count = freezed,
    Object? can_delete = freezed,
  }) {
    return _then(_$GroupDataImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      created_at: freezed == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: freezed == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as String?,
      is_private: freezed == is_private
          ? _value.is_private
          : is_private // ignore: cast_nullable_to_non_nullable
              as bool?,
      is_deleted: freezed == is_deleted
          ? _value.is_deleted
          : is_deleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as String?,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as String?,
      participants_count: freezed == participants_count
          ? _value.participants_count
          : participants_count // ignore: cast_nullable_to_non_nullable
              as int?,
      online_count: freezed == online_count
          ? _value.online_count
          : online_count // ignore: cast_nullable_to_non_nullable
              as int?,
      can_delete: freezed == can_delete
          ? _value.can_delete
          : can_delete // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupDataImpl extends _GroupData {
  const _$GroupDataImpl(
      {this.uuid,
      this.name,
      this.description,
      this.created_at,
      this.created_by,
      this.is_private,
      this.is_deleted,
      this.deleted_at,
      this.deleted_by,
      this.participants_count,
      this.online_count,
      this.can_delete})
      : super._();

  factory _$GroupDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupDataImplFromJson(json);

  @override
  final String? uuid;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? created_at;
  @override
  final String? created_by;
  @override
  final bool? is_private;
  @override
  final bool? is_deleted;
  @override
  final String? deleted_at;
  @override
  final String? deleted_by;
  @override
  final int? participants_count;
  @override
  final int? online_count;
  @override
  final bool? can_delete;

  @override
  String toString() {
    return 'GroupData(uuid: $uuid, name: $name, description: $description, created_at: $created_at, created_by: $created_by, is_private: $is_private, is_deleted: $is_deleted, deleted_at: $deleted_at, deleted_by: $deleted_by, participants_count: $participants_count, online_count: $online_count, can_delete: $can_delete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupDataImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.is_private, is_private) ||
                other.is_private == is_private) &&
            (identical(other.is_deleted, is_deleted) ||
                other.is_deleted == is_deleted) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at) &&
            (identical(other.deleted_by, deleted_by) ||
                other.deleted_by == deleted_by) &&
            (identical(other.participants_count, participants_count) ||
                other.participants_count == participants_count) &&
            (identical(other.online_count, online_count) ||
                other.online_count == online_count) &&
            (identical(other.can_delete, can_delete) ||
                other.can_delete == can_delete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      name,
      description,
      created_at,
      created_by,
      is_private,
      is_deleted,
      deleted_at,
      deleted_by,
      participants_count,
      online_count,
      can_delete);

  /// Create a copy of GroupData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupDataImplCopyWith<_$GroupDataImpl> get copyWith =>
      __$$GroupDataImplCopyWithImpl<_$GroupDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupDataImplToJson(
      this,
    );
  }
}

abstract class _GroupData extends GroupData {
  const factory _GroupData(
      {final String? uuid,
      final String? name,
      final String? description,
      final String? created_at,
      final String? created_by,
      final bool? is_private,
      final bool? is_deleted,
      final String? deleted_at,
      final String? deleted_by,
      final int? participants_count,
      final int? online_count,
      final bool? can_delete}) = _$GroupDataImpl;
  const _GroupData._() : super._();

  factory _GroupData.fromJson(Map<String, dynamic> json) =
      _$GroupDataImpl.fromJson;

  @override
  String? get uuid;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get created_at;
  @override
  String? get created_by;
  @override
  bool? get is_private;
  @override
  bool? get is_deleted;
  @override
  String? get deleted_at;
  @override
  String? get deleted_by;
  @override
  int? get participants_count;
  @override
  int? get online_count;
  @override
  bool? get can_delete;

  /// Create a copy of GroupData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupDataImplCopyWith<_$GroupDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
