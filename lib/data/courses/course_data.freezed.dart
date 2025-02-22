// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CourseData _$CourseDataFromJson(Map<String, dynamic> json) {
  return _CourseData.fromJson(json);
}

/// @nodoc
mixin _$CourseData {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get teacher => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  List<LessonData>? get lessons => throw _privateConstructorUsedError;

  /// Serializes this CourseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDataCopyWith<CourseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDataCopyWith<$Res> {
  factory $CourseDataCopyWith(
          CourseData value, $Res Function(CourseData) then) =
      _$CourseDataCopyWithImpl<$Res, CourseData>;
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? teacher,
      String? description,
      String? level,
      List<LessonData>? lessons});
}

/// @nodoc
class _$CourseDataCopyWithImpl<$Res, $Val extends CourseData>
    implements $CourseDataCopyWith<$Res> {
  _$CourseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? teacher = freezed,
    Object? description = freezed,
    Object? level = freezed,
    Object? lessons = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      teacher: freezed == teacher
          ? _value.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      lessons: freezed == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseDataImplCopyWith<$Res>
    implements $CourseDataCopyWith<$Res> {
  factory _$$CourseDataImplCopyWith(
          _$CourseDataImpl value, $Res Function(_$CourseDataImpl) then) =
      __$$CourseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? teacher,
      String? description,
      String? level,
      List<LessonData>? lessons});
}

/// @nodoc
class __$$CourseDataImplCopyWithImpl<$Res>
    extends _$CourseDataCopyWithImpl<$Res, _$CourseDataImpl>
    implements _$$CourseDataImplCopyWith<$Res> {
  __$$CourseDataImplCopyWithImpl(
      _$CourseDataImpl _value, $Res Function(_$CourseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? teacher = freezed,
    Object? description = freezed,
    Object? level = freezed,
    Object? lessons = freezed,
  }) {
    return _then(_$CourseDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      teacher: freezed == teacher
          ? _value.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      lessons: freezed == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonData>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDataImpl extends _CourseData {
  const _$CourseDataImpl(
      {this.id,
      this.title,
      this.teacher,
      this.description,
      this.level,
      final List<LessonData>? lessons})
      : _lessons = lessons,
        super._();

  factory _$CourseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? teacher;
  @override
  final String? description;
  @override
  final String? level;
  final List<LessonData>? _lessons;
  @override
  List<LessonData>? get lessons {
    final value = _lessons;
    if (value == null) return null;
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CourseData(id: $id, title: $title, teacher: $teacher, description: $description, level: $level, lessons: $lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, teacher, description,
      level, const DeepCollectionEquality().hash(_lessons));

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDataImplCopyWith<_$CourseDataImpl> get copyWith =>
      __$$CourseDataImplCopyWithImpl<_$CourseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDataImplToJson(
      this,
    );
  }
}

abstract class _CourseData extends CourseData {
  const factory _CourseData(
      {final String? id,
      final String? title,
      final String? teacher,
      final String? description,
      final String? level,
      final List<LessonData>? lessons}) = _$CourseDataImpl;
  const _CourseData._() : super._();

  factory _CourseData.fromJson(Map<String, dynamic> json) =
      _$CourseDataImpl.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get teacher;
  @override
  String? get description;
  @override
  String? get level;
  @override
  List<LessonData>? get lessons;

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDataImplCopyWith<_$CourseDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonData _$LessonDataFromJson(Map<String, dynamic> json) {
  return _LessonData.fromJson(json);
}

/// @nodoc
mixin _$LessonData {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  /// Serializes this LessonData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonDataCopyWith<LessonData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonDataCopyWith<$Res> {
  factory $LessonDataCopyWith(
          LessonData value, $Res Function(LessonData) then) =
      _$LessonDataCopyWithImpl<$Res, LessonData>;
  @useResult
  $Res call({String? id, String? title, int? duration});
}

/// @nodoc
class _$LessonDataCopyWithImpl<$Res, $Val extends LessonData>
    implements $LessonDataCopyWith<$Res> {
  _$LessonDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonDataImplCopyWith<$Res>
    implements $LessonDataCopyWith<$Res> {
  factory _$$LessonDataImplCopyWith(
          _$LessonDataImpl value, $Res Function(_$LessonDataImpl) then) =
      __$$LessonDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? title, int? duration});
}

/// @nodoc
class __$$LessonDataImplCopyWithImpl<$Res>
    extends _$LessonDataCopyWithImpl<$Res, _$LessonDataImpl>
    implements _$$LessonDataImplCopyWith<$Res> {
  __$$LessonDataImplCopyWithImpl(
      _$LessonDataImpl _value, $Res Function(_$LessonDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$LessonDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonDataImpl extends _LessonData {
  const _$LessonDataImpl({this.id, this.title, this.duration}) : super._();

  factory _$LessonDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final int? duration;

  @override
  String toString() {
    return 'LessonData(id: $id, title: $title, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, duration);

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonDataImplCopyWith<_$LessonDataImpl> get copyWith =>
      __$$LessonDataImplCopyWithImpl<_$LessonDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonDataImplToJson(
      this,
    );
  }
}

abstract class _LessonData extends LessonData {
  const factory _LessonData(
      {final String? id,
      final String? title,
      final int? duration}) = _$LessonDataImpl;
  const _LessonData._() : super._();

  factory _LessonData.fromJson(Map<String, dynamic> json) =
      _$LessonDataImpl.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  int? get duration;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonDataImplCopyWith<_$LessonDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
