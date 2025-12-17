// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String? get uuid => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  bool? get online_status => throw _privateConstructorUsedError;
  String? get last_seen => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String? uuid,
      String? firstName,
      String? email,
      String? lastName,
      String? bio,
      bool? online_status,
      String? last_seen});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? firstName = freezed,
    Object? email = freezed,
    Object? lastName = freezed,
    Object? bio = freezed,
    Object? online_status = freezed,
    Object? last_seen = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      online_status: freezed == online_status
          ? _value.online_status
          : online_status // ignore: cast_nullable_to_non_nullable
              as bool?,
      last_seen: freezed == last_seen
          ? _value.last_seen
          : last_seen // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uuid,
      String? firstName,
      String? email,
      String? lastName,
      String? bio,
      bool? online_status,
      String? last_seen});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? firstName = freezed,
    Object? email = freezed,
    Object? lastName = freezed,
    Object? bio = freezed,
    Object? online_status = freezed,
    Object? last_seen = freezed,
  }) {
    return _then(_$UserDataImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      online_status: freezed == online_status
          ? _value.online_status
          : online_status // ignore: cast_nullable_to_non_nullable
              as bool?,
      last_seen: freezed == last_seen
          ? _value.last_seen
          : last_seen // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl extends _UserData {
  const _$UserDataImpl(
      {this.uuid,
      this.firstName,
      this.email,
      this.lastName,
      this.bio,
      this.online_status,
      this.last_seen})
      : super._();

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String? uuid;
  @override
  final String? firstName;
  @override
  final String? email;
  @override
  final String? lastName;
  @override
  final String? bio;
  @override
  final bool? online_status;
  @override
  final String? last_seen;

  @override
  String toString() {
    return 'UserData(uuid: $uuid, firstName: $firstName, email: $email, lastName: $lastName, bio: $bio, online_status: $online_status, last_seen: $last_seen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.online_status, online_status) ||
                other.online_status == online_status) &&
            (identical(other.last_seen, last_seen) ||
                other.last_seen == last_seen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, firstName, email, lastName,
      bio, online_status, last_seen);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  const factory _UserData(
      {final String? uuid,
      final String? firstName,
      final String? email,
      final String? lastName,
      final String? bio,
      final bool? online_status,
      final String? last_seen}) = _$UserDataImpl;
  const _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String? get uuid;
  @override
  String? get firstName;
  @override
  String? get email;
  @override
  String? get lastName;
  @override
  String? get bio;
  @override
  bool? get online_status;
  @override
  String? get last_seen;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
