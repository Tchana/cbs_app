// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) {
  return _RegisterData.fromJson(json);
}

/// @nodoc
mixin _$RegisterData {
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get p_image => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this RegisterData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterDataCopyWith<RegisterData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterDataCopyWith<$Res> {
  factory $RegisterDataCopyWith(
          RegisterData value, $Res Function(RegisterData) then) =
      _$RegisterDataCopyWithImpl<$Res, RegisterData>;
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? p_image,
      String? role});
}

/// @nodoc
class _$RegisterDataCopyWithImpl<$Res, $Val extends RegisterData>
    implements $RegisterDataCopyWith<$Res> {
  _$RegisterDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? p_image = freezed,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      p_image: freezed == p_image
          ? _value.p_image
          : p_image // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterDataImplCopyWith<$Res>
    implements $RegisterDataCopyWith<$Res> {
  factory _$$RegisterDataImplCopyWith(
          _$RegisterDataImpl value, $Res Function(_$RegisterDataImpl) then) =
      __$$RegisterDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? p_image,
      String? role});
}

/// @nodoc
class __$$RegisterDataImplCopyWithImpl<$Res>
    extends _$RegisterDataCopyWithImpl<$Res, _$RegisterDataImpl>
    implements _$$RegisterDataImplCopyWith<$Res> {
  __$$RegisterDataImplCopyWithImpl(
      _$RegisterDataImpl _value, $Res Function(_$RegisterDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? p_image = freezed,
    Object? role = freezed,
  }) {
    return _then(_$RegisterDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      p_image: freezed == p_image
          ? _value.p_image
          : p_image // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterDataImpl extends _RegisterData {
  const _$RegisterDataImpl(
      {this.id,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.p_image,
      this.role})
      : super._();

  factory _$RegisterDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? password;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? p_image;
  @override
  final String? role;

  @override
  String toString() {
    return 'RegisterData(id: $id, email: $email, password: $password, firstName: $firstName, lastName: $lastName, p_image: $p_image, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.p_image, p_image) || other.p_image == p_image) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, email, password, firstName, lastName, p_image, role);

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterDataImplCopyWith<_$RegisterDataImpl> get copyWith =>
      __$$RegisterDataImplCopyWithImpl<_$RegisterDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterDataImplToJson(
      this,
    );
  }
}

abstract class _RegisterData extends RegisterData {
  const factory _RegisterData(
      {final String? id,
      final String? email,
      final String? password,
      final String? firstName,
      final String? lastName,
      final String? p_image,
      final String? role}) = _$RegisterDataImpl;
  const _RegisterData._() : super._();

  factory _RegisterData.fromJson(Map<String, dynamic> json) =
      _$RegisterDataImpl.fromJson;

  @override
  String? get id;
  @override
  String? get email;
  @override
  String? get password;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get p_image;
  @override
  String? get role;

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterDataImplCopyWith<_$RegisterDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
