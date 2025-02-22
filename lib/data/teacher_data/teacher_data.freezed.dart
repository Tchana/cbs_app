// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeacherData _$TeacherDataFromJson(Map<String, dynamic> json) {
  return _TeacherData.fromJson(json);
}

/// @nodoc
mixin _$TeacherData {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  ProfileImage? get profileImage => throw _privateConstructorUsedError;
  List<CourseData>? get courses => throw _privateConstructorUsedError;

  /// Serializes this TeacherData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherDataCopyWith<TeacherData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherDataCopyWith<$Res> {
  factory $TeacherDataCopyWith(
          TeacherData value, $Res Function(TeacherData) then) =
      _$TeacherDataCopyWithImpl<$Res, TeacherData>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      ProfileImage? profileImage,
      List<CourseData>? courses});

  $ProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class _$TeacherDataCopyWithImpl<$Res, $Val extends TeacherData>
    implements $TeacherDataCopyWith<$Res> {
  _$TeacherDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? profileImage = freezed,
    Object? courses = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as ProfileImage?,
      courses: freezed == courses
          ? _value.courses
          : courses // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ) as $Val);
  }

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileImageCopyWith<$Res>? get profileImage {
    if (_value.profileImage == null) {
      return null;
    }

    return $ProfileImageCopyWith<$Res>(_value.profileImage!, (value) {
      return _then(_value.copyWith(profileImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeacherDataImplCopyWith<$Res>
    implements $TeacherDataCopyWith<$Res> {
  factory _$$TeacherDataImplCopyWith(
          _$TeacherDataImpl value, $Res Function(_$TeacherDataImpl) then) =
      __$$TeacherDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      ProfileImage? profileImage,
      List<CourseData>? courses});

  @override
  $ProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class __$$TeacherDataImplCopyWithImpl<$Res>
    extends _$TeacherDataCopyWithImpl<$Res, _$TeacherDataImpl>
    implements _$$TeacherDataImplCopyWith<$Res> {
  __$$TeacherDataImplCopyWithImpl(
      _$TeacherDataImpl _value, $Res Function(_$TeacherDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? profileImage = freezed,
    Object? courses = freezed,
  }) {
    return _then(_$TeacherDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as ProfileImage?,
      courses: freezed == courses
          ? _value._courses
          : courses // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherDataImpl extends _TeacherData {
  const _$TeacherDataImpl(
      {this.id, this.name, this.profileImage, final List<CourseData>? courses})
      : _courses = courses,
        super._();

  factory _$TeacherDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final ProfileImage? profileImage;
  final List<CourseData>? _courses;
  @override
  List<CourseData>? get courses {
    final value = _courses;
    if (value == null) return null;
    if (_courses is EqualUnmodifiableListView) return _courses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TeacherData(id: $id, name: $name, profileImage: $profileImage, courses: $courses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality().equals(other._courses, _courses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage,
      const DeepCollectionEquality().hash(_courses));

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherDataImplCopyWith<_$TeacherDataImpl> get copyWith =>
      __$$TeacherDataImplCopyWithImpl<_$TeacherDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherDataImplToJson(
      this,
    );
  }
}

abstract class _TeacherData extends TeacherData {
  const factory _TeacherData(
      {final String? id,
      final String? name,
      final ProfileImage? profileImage,
      final List<CourseData>? courses}) = _$TeacherDataImpl;
  const _TeacherData._() : super._();

  factory _TeacherData.fromJson(Map<String, dynamic> json) =
      _$TeacherDataImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  ProfileImage? get profileImage;
  @override
  List<CourseData>? get courses;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherDataImplCopyWith<_$TeacherDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileImage _$ProfileImageFromJson(Map<String, dynamic> json) {
  return _ProfileImage.fromJson(json);
}

/// @nodoc
mixin _$ProfileImage {
  String? get id => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;

  /// Serializes this ProfileImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileImageCopyWith<ProfileImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileImageCopyWith<$Res> {
  factory $ProfileImageCopyWith(
          ProfileImage value, $Res Function(ProfileImage) then) =
      _$ProfileImageCopyWithImpl<$Res, ProfileImage>;
  @useResult
  $Res call({String? id, String? url, String? text});
}

/// @nodoc
class _$ProfileImageCopyWithImpl<$Res, $Val extends ProfileImage>
    implements $ProfileImageCopyWith<$Res> {
  _$ProfileImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImageImplCopyWith<$Res>
    implements $ProfileImageCopyWith<$Res> {
  factory _$$ProfileImageImplCopyWith(
          _$ProfileImageImpl value, $Res Function(_$ProfileImageImpl) then) =
      __$$ProfileImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? url, String? text});
}

/// @nodoc
class __$$ProfileImageImplCopyWithImpl<$Res>
    extends _$ProfileImageCopyWithImpl<$Res, _$ProfileImageImpl>
    implements _$$ProfileImageImplCopyWith<$Res> {
  __$$ProfileImageImplCopyWithImpl(
      _$ProfileImageImpl _value, $Res Function(_$ProfileImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? text = freezed,
  }) {
    return _then(_$ProfileImageImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImageImpl extends _ProfileImage {
  const _$ProfileImageImpl({this.id, this.url, this.text}) : super._();

  factory _$ProfileImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImageImplFromJson(json);

  @override
  final String? id;
  @override
  final String? url;
  @override
  final String? text;

  @override
  String toString() {
    return 'ProfileImage(id: $id, url: $url, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, text);

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImageImplCopyWith<_$ProfileImageImpl> get copyWith =>
      __$$ProfileImageImplCopyWithImpl<_$ProfileImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImageImplToJson(
      this,
    );
  }
}

abstract class _ProfileImage extends ProfileImage {
  const factory _ProfileImage(
      {final String? id,
      final String? url,
      final String? text}) = _$ProfileImageImpl;
  const _ProfileImage._() : super._();

  factory _ProfileImage.fromJson(Map<String, dynamic> json) =
      _$ProfileImageImpl.fromJson;

  @override
  String? get id;
  @override
  String? get url;
  @override
  String? get text;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImageImplCopyWith<_$ProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
