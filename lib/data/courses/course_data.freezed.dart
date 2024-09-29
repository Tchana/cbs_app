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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CourseData _$CourseDataFromJson(Map<String, dynamic> json) {
  return _CourseData.fromJson(json);
}

/// @nodoc
mixin _$CourseData {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<LessonData>? get lessons => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseDataCopyWith<CourseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDataCopyWith<$Res> {
  factory $CourseDataCopyWith(
          CourseData value, $Res Function(CourseData) then) =
      _$CourseDataCopyWithImpl<$Res, CourseData>;
  @useResult
  $Res call({String? id, String? name, List<LessonData>? lessons});
}

/// @nodoc
class _$CourseDataCopyWithImpl<$Res, $Val extends CourseData>
    implements $CourseDataCopyWith<$Res> {
  _$CourseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lessons = freezed,
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
      lessons: freezed == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CourseDataCopyWith<$Res>
    implements $CourseDataCopyWith<$Res> {
  factory _$$_CourseDataCopyWith(
          _$_CourseData value, $Res Function(_$_CourseData) then) =
      __$$_CourseDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, List<LessonData>? lessons});
}

/// @nodoc
class __$$_CourseDataCopyWithImpl<$Res>
    extends _$CourseDataCopyWithImpl<$Res, _$_CourseData>
    implements _$$_CourseDataCopyWith<$Res> {
  __$$_CourseDataCopyWithImpl(
      _$_CourseData _value, $Res Function(_$_CourseData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lessons = freezed,
  }) {
    return _then(_$_CourseData(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
class _$_CourseData extends _CourseData {
  const _$_CourseData({this.id, this.name, final List<LessonData>? lessons})
      : _lessons = lessons,
        super._();

  factory _$_CourseData.fromJson(Map<String, dynamic> json) =>
      _$$_CourseDataFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
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
    return 'CourseData(id: $id, name: $name, lessons: $lessons)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CourseData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_lessons));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CourseDataCopyWith<_$_CourseData> get copyWith =>
      __$$_CourseDataCopyWithImpl<_$_CourseData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CourseDataToJson(
      this,
    );
  }
}

abstract class _CourseData extends CourseData {
  const factory _CourseData(
      {final String? id,
      final String? name,
      final List<LessonData>? lessons}) = _$_CourseData;
  const _CourseData._() : super._();

  factory _CourseData.fromJson(Map<String, dynamic> json) =
      _$_CourseData.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  List<LessonData>? get lessons;
  @override
  @JsonKey(ignore: true)
  _$$_CourseDataCopyWith<_$_CourseData> get copyWith =>
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_LessonDataCopyWith<$Res>
    implements $LessonDataCopyWith<$Res> {
  factory _$$_LessonDataCopyWith(
          _$_LessonData value, $Res Function(_$_LessonData) then) =
      __$$_LessonDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? title, int? duration});
}

/// @nodoc
class __$$_LessonDataCopyWithImpl<$Res>
    extends _$LessonDataCopyWithImpl<$Res, _$_LessonData>
    implements _$$_LessonDataCopyWith<$Res> {
  __$$_LessonDataCopyWithImpl(
      _$_LessonData _value, $Res Function(_$_LessonData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$_LessonData(
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
class _$_LessonData extends _LessonData {
  const _$_LessonData({this.id, this.title, this.duration}) : super._();

  factory _$_LessonData.fromJson(Map<String, dynamic> json) =>
      _$$_LessonDataFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LessonData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LessonDataCopyWith<_$_LessonData> get copyWith =>
      __$$_LessonDataCopyWithImpl<_$_LessonData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LessonDataToJson(
      this,
    );
  }
}

abstract class _LessonData extends LessonData {
  const factory _LessonData(
      {final String? id,
      final String? title,
      final int? duration}) = _$_LessonData;
  const _LessonData._() : super._();

  factory _LessonData.fromJson(Map<String, dynamic> json) =
      _$_LessonData.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  int? get duration;
  @override
  @JsonKey(ignore: true)
  _$$_LessonDataCopyWith<_$_LessonData> get copyWith =>
      throw _privateConstructorUsedError;
}
