// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseData {
  String? get id;
  String? get title;
  RegisterData? get teacher;
  String? get description;
  String? get level;
  bool? get isEnrolled;
  List<LessonData>? get lessons;

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseDataCopyWith<CourseData> get copyWith =>
      _$CourseDataCopyWithImpl<CourseData>(this as CourseData, _$identity);

  /// Serializes this CourseData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isEnrolled, isEnrolled) ||
                other.isEnrolled == isEnrolled) &&
            const DeepCollectionEquality().equals(other.lessons, lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, teacher, description,
      level, isEnrolled, const DeepCollectionEquality().hash(lessons));

  @override
  String toString() {
    return 'CourseData(id: $id, title: $title, teacher: $teacher, description: $description, level: $level, isEnrolled: $isEnrolled, lessons: $lessons)';
  }
}

/// @nodoc
abstract mixin class $CourseDataCopyWith<$Res> {
  factory $CourseDataCopyWith(
          CourseData value, $Res Function(CourseData) _then) =
      _$CourseDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? title,
      RegisterData? teacher,
      String? description,
      String? level,
      bool? isEnrolled,
      List<LessonData>? lessons});

  $RegisterDataCopyWith<$Res>? get teacher;
}

/// @nodoc
class _$CourseDataCopyWithImpl<$Res> implements $CourseDataCopyWith<$Res> {
  _$CourseDataCopyWithImpl(this._self, this._then);

  final CourseData _self;
  final $Res Function(CourseData) _then;

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
    Object? isEnrolled = freezed,
    Object? lessons = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      teacher: freezed == teacher
          ? _self.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as RegisterData?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnrolled: freezed == isEnrolled
          ? _self.isEnrolled
          : isEnrolled // ignore: cast_nullable_to_non_nullable
              as bool?,
      lessons: freezed == lessons
          ? _self.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonData>?,
    ));
  }

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterDataCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
      return null;
    }

    return $RegisterDataCopyWith<$Res>(_self.teacher!, (value) {
      return _then(_self.copyWith(teacher: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CourseData].
extension CourseDataPatterns on CourseData {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CourseData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CourseData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CourseData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? id,
            String? title,
            RegisterData? teacher,
            String? description,
            String? level,
            bool? isEnrolled,
            List<LessonData>? lessons)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(_that.id, _that.title, _that.teacher, _that.description,
            _that.level, _that.isEnrolled, _that.lessons);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? id,
            String? title,
            RegisterData? teacher,
            String? description,
            String? level,
            bool? isEnrolled,
            List<LessonData>? lessons)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData():
        return $default(_that.id, _that.title, _that.teacher, _that.description,
            _that.level, _that.isEnrolled, _that.lessons);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? id,
            String? title,
            RegisterData? teacher,
            String? description,
            String? level,
            bool? isEnrolled,
            List<LessonData>? lessons)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(_that.id, _that.title, _that.teacher, _that.description,
            _that.level, _that.isEnrolled, _that.lessons);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourseData extends CourseData {
  const _CourseData(
      {this.id,
      this.title,
      this.teacher,
      this.description,
      this.level,
      this.isEnrolled,
      final List<LessonData>? lessons})
      : _lessons = lessons,
        super._();
  factory _CourseData.fromJson(Map<String, dynamic> json) =>
      _$CourseDataFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final RegisterData? teacher;
  @override
  final String? description;
  @override
  final String? level;
  @override
  final bool? isEnrolled;
  final List<LessonData>? _lessons;
  @override
  List<LessonData>? get lessons {
    final value = _lessons;
    if (value == null) return null;
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseDataCopyWith<_CourseData> get copyWith =>
      __$CourseDataCopyWithImpl<_CourseData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isEnrolled, isEnrolled) ||
                other.isEnrolled == isEnrolled) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, teacher, description,
      level, isEnrolled, const DeepCollectionEquality().hash(_lessons));

  @override
  String toString() {
    return 'CourseData(id: $id, title: $title, teacher: $teacher, description: $description, level: $level, isEnrolled: $isEnrolled, lessons: $lessons)';
  }
}

/// @nodoc
abstract mixin class _$CourseDataCopyWith<$Res>
    implements $CourseDataCopyWith<$Res> {
  factory _$CourseDataCopyWith(
          _CourseData value, $Res Function(_CourseData) _then) =
      __$CourseDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      RegisterData? teacher,
      String? description,
      String? level,
      bool? isEnrolled,
      List<LessonData>? lessons});

  @override
  $RegisterDataCopyWith<$Res>? get teacher;
}

/// @nodoc
class __$CourseDataCopyWithImpl<$Res> implements _$CourseDataCopyWith<$Res> {
  __$CourseDataCopyWithImpl(this._self, this._then);

  final _CourseData _self;
  final $Res Function(_CourseData) _then;

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? teacher = freezed,
    Object? description = freezed,
    Object? level = freezed,
    Object? isEnrolled = freezed,
    Object? lessons = freezed,
  }) {
    return _then(_CourseData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      teacher: freezed == teacher
          ? _self.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as RegisterData?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnrolled: freezed == isEnrolled
          ? _self.isEnrolled
          : isEnrolled // ignore: cast_nullable_to_non_nullable
              as bool?,
      lessons: freezed == lessons
          ? _self._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonData>?,
    ));
  }

  /// Create a copy of CourseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterDataCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
      return null;
    }

    return $RegisterDataCopyWith<$Res>(_self.teacher!, (value) {
      return _then(_self.copyWith(teacher: value));
    });
  }
}

/// @nodoc
mixin _$LessonData {
  String? get id;
  String? get course;
  String? get title;
  String? get description;
  String? get file;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LessonDataCopyWith<LessonData> get copyWith =>
      _$LessonDataCopyWithImpl<LessonData>(this as LessonData, _$identity);

  /// Serializes this LessonData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LessonData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.file, file) || other.file == file));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, course, title, description, file);

  @override
  String toString() {
    return 'LessonData(id: $id, course: $course, title: $title, description: $description, file: $file)';
  }
}

/// @nodoc
abstract mixin class $LessonDataCopyWith<$Res> {
  factory $LessonDataCopyWith(
          LessonData value, $Res Function(LessonData) _then) =
      _$LessonDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? course,
      String? title,
      String? description,
      String? file});
}

/// @nodoc
class _$LessonDataCopyWithImpl<$Res> implements $LessonDataCopyWith<$Res> {
  _$LessonDataCopyWithImpl(this._self, this._then);

  final LessonData _self;
  final $Res Function(LessonData) _then;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? course = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? file = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LessonData].
extension LessonDataPatterns on LessonData {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LessonData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LessonData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LessonData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? id, String? course, String? title,
            String? description, String? file)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(
            _that.id, _that.course, _that.title, _that.description, _that.file);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? id, String? course, String? title,
            String? description, String? file)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData():
        return $default(
            _that.id, _that.course, _that.title, _that.description, _that.file);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? id, String? course, String? title,
            String? description, String? file)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(
            _that.id, _that.course, _that.title, _that.description, _that.file);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LessonData extends LessonData {
  const _LessonData(
      {this.id, this.course, this.title, this.description, this.file})
      : super._();
  factory _LessonData.fromJson(Map<String, dynamic> json) =>
      _$LessonDataFromJson(json);

  @override
  final String? id;
  @override
  final String? course;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? file;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LessonDataCopyWith<_LessonData> get copyWith =>
      __$LessonDataCopyWithImpl<_LessonData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LessonDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LessonData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.file, file) || other.file == file));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, course, title, description, file);

  @override
  String toString() {
    return 'LessonData(id: $id, course: $course, title: $title, description: $description, file: $file)';
  }
}

/// @nodoc
abstract mixin class _$LessonDataCopyWith<$Res>
    implements $LessonDataCopyWith<$Res> {
  factory _$LessonDataCopyWith(
          _LessonData value, $Res Function(_LessonData) _then) =
      __$LessonDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? course,
      String? title,
      String? description,
      String? file});
}

/// @nodoc
class __$LessonDataCopyWithImpl<$Res> implements _$LessonDataCopyWith<$Res> {
  __$LessonDataCopyWithImpl(this._self, this._then);

  final _LessonData _self;
  final $Res Function(_LessonData) _then;

  /// Create a copy of LessonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? course = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? file = freezed,
  }) {
    return _then(_LessonData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
