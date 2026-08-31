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
  @JsonKey(name: 'learning_objectives')
  String? get learningObjectives;
  String? get courseCover;
  bool? get isEnrolled;
  @JsonKey(name: 'overview_videos')
  List<CourseOverviewVideoData>? get overviewVideos;
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
            (identical(other.learningObjectives, learningObjectives) ||
                other.learningObjectives == learningObjectives) &&
            (identical(other.courseCover, courseCover) ||
                other.courseCover == courseCover) &&
            (identical(other.isEnrolled, isEnrolled) ||
                other.isEnrolled == isEnrolled) &&
            const DeepCollectionEquality()
                .equals(other.overviewVideos, overviewVideos) &&
            const DeepCollectionEquality().equals(other.lessons, lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      teacher,
      description,
      learningObjectives,
      courseCover,
      isEnrolled,
      const DeepCollectionEquality().hash(overviewVideos),
      const DeepCollectionEquality().hash(lessons));

  @override
  String toString() {
    return 'CourseData(id: $id, title: $title, teacher: $teacher, description: $description, learningObjectives: $learningObjectives, courseCover: $courseCover, isEnrolled: $isEnrolled, overviewVideos: $overviewVideos, lessons: $lessons)';
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
      @JsonKey(name: 'learning_objectives') String? learningObjectives,
      String? courseCover,
      bool? isEnrolled,
      @JsonKey(name: 'overview_videos')
      List<CourseOverviewVideoData>? overviewVideos,
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
    Object? learningObjectives = freezed,
    Object? courseCover = freezed,
    Object? isEnrolled = freezed,
    Object? overviewVideos = freezed,
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
      learningObjectives: freezed == learningObjectives
          ? _self.learningObjectives
          : learningObjectives // ignore: cast_nullable_to_non_nullable
              as String?,
      courseCover: freezed == courseCover
          ? _self.courseCover
          : courseCover // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnrolled: freezed == isEnrolled
          ? _self.isEnrolled
          : isEnrolled // ignore: cast_nullable_to_non_nullable
              as bool?,
      overviewVideos: freezed == overviewVideos
          ? _self.overviewVideos
          : overviewVideos // ignore: cast_nullable_to_non_nullable
              as List<CourseOverviewVideoData>?,
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
            @JsonKey(name: 'learning_objectives') String? learningObjectives,
            String? courseCover,
            bool? isEnrolled,
            @JsonKey(name: 'overview_videos')
            List<CourseOverviewVideoData>? overviewVideos,
            List<LessonData>? lessons)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.teacher,
            _that.description,
            _that.learningObjectives,
            _that.courseCover,
            _that.isEnrolled,
            _that.overviewVideos,
            _that.lessons);
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
            @JsonKey(name: 'learning_objectives') String? learningObjectives,
            String? courseCover,
            bool? isEnrolled,
            @JsonKey(name: 'overview_videos')
            List<CourseOverviewVideoData>? overviewVideos,
            List<LessonData>? lessons)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData():
        return $default(
            _that.id,
            _that.title,
            _that.teacher,
            _that.description,
            _that.learningObjectives,
            _that.courseCover,
            _that.isEnrolled,
            _that.overviewVideos,
            _that.lessons);
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
            @JsonKey(name: 'learning_objectives') String? learningObjectives,
            String? courseCover,
            bool? isEnrolled,
            @JsonKey(name: 'overview_videos')
            List<CourseOverviewVideoData>? overviewVideos,
            List<LessonData>? lessons)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseData() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.teacher,
            _that.description,
            _that.learningObjectives,
            _that.courseCover,
            _that.isEnrolled,
            _that.overviewVideos,
            _that.lessons);
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
      @JsonKey(name: 'learning_objectives') this.learningObjectives,
      this.courseCover,
      this.isEnrolled,
      @JsonKey(name: 'overview_videos')
      final List<CourseOverviewVideoData>? overviewVideos,
      final List<LessonData>? lessons})
      : _overviewVideos = overviewVideos,
        _lessons = lessons,
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
  @JsonKey(name: 'learning_objectives')
  final String? learningObjectives;
  @override
  final String? courseCover;
  @override
  final bool? isEnrolled;
  final List<CourseOverviewVideoData>? _overviewVideos;
  @override
  @JsonKey(name: 'overview_videos')
  List<CourseOverviewVideoData>? get overviewVideos {
    final value = _overviewVideos;
    if (value == null) return null;
    if (_overviewVideos is EqualUnmodifiableListView) return _overviewVideos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
            (identical(other.learningObjectives, learningObjectives) ||
                other.learningObjectives == learningObjectives) &&
            (identical(other.courseCover, courseCover) ||
                other.courseCover == courseCover) &&
            (identical(other.isEnrolled, isEnrolled) ||
                other.isEnrolled == isEnrolled) &&
            const DeepCollectionEquality()
                .equals(other._overviewVideos, _overviewVideos) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      teacher,
      description,
      learningObjectives,
      courseCover,
      isEnrolled,
      const DeepCollectionEquality().hash(_overviewVideos),
      const DeepCollectionEquality().hash(_lessons));

  @override
  String toString() {
    return 'CourseData(id: $id, title: $title, teacher: $teacher, description: $description, learningObjectives: $learningObjectives, courseCover: $courseCover, isEnrolled: $isEnrolled, overviewVideos: $overviewVideos, lessons: $lessons)';
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
      @JsonKey(name: 'learning_objectives') String? learningObjectives,
      String? courseCover,
      bool? isEnrolled,
      @JsonKey(name: 'overview_videos')
      List<CourseOverviewVideoData>? overviewVideos,
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
    Object? learningObjectives = freezed,
    Object? courseCover = freezed,
    Object? isEnrolled = freezed,
    Object? overviewVideos = freezed,
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
      learningObjectives: freezed == learningObjectives
          ? _self.learningObjectives
          : learningObjectives // ignore: cast_nullable_to_non_nullable
              as String?,
      courseCover: freezed == courseCover
          ? _self.courseCover
          : courseCover // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnrolled: freezed == isEnrolled
          ? _self.isEnrolled
          : isEnrolled // ignore: cast_nullable_to_non_nullable
              as bool?,
      overviewVideos: freezed == overviewVideos
          ? _self._overviewVideos
          : overviewVideos // ignore: cast_nullable_to_non_nullable
              as List<CourseOverviewVideoData>?,
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
mixin _$CourseOverviewVideoData {
  String? get id;
  String? get title;
  String? get url;
  @JsonKey(name: 'sort_order')
  int? get sortOrder;

  /// Create a copy of CourseOverviewVideoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseOverviewVideoDataCopyWith<CourseOverviewVideoData> get copyWith =>
      _$CourseOverviewVideoDataCopyWithImpl<CourseOverviewVideoData>(
          this as CourseOverviewVideoData, _$identity);

  /// Serializes this CourseOverviewVideoData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseOverviewVideoData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, url, sortOrder);

  @override
  String toString() {
    return 'CourseOverviewVideoData(id: $id, title: $title, url: $url, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $CourseOverviewVideoDataCopyWith<$Res> {
  factory $CourseOverviewVideoDataCopyWith(CourseOverviewVideoData value,
          $Res Function(CourseOverviewVideoData) _then) =
      _$CourseOverviewVideoDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? url,
      @JsonKey(name: 'sort_order') int? sortOrder});
}

/// @nodoc
class _$CourseOverviewVideoDataCopyWithImpl<$Res>
    implements $CourseOverviewVideoDataCopyWith<$Res> {
  _$CourseOverviewVideoDataCopyWithImpl(this._self, this._then);

  final CourseOverviewVideoData _self;
  final $Res Function(CourseOverviewVideoData) _then;

  /// Create a copy of CourseOverviewVideoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? sortOrder = freezed,
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
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CourseOverviewVideoData].
extension CourseOverviewVideoDataPatterns on CourseOverviewVideoData {
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
    TResult Function(_CourseOverviewVideoData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData() when $default != null:
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
    TResult Function(_CourseOverviewVideoData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData():
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
    TResult? Function(_CourseOverviewVideoData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData() when $default != null:
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
    TResult Function(String? id, String? title, String? url,
            @JsonKey(name: 'sort_order') int? sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData() when $default != null:
        return $default(_that.id, _that.title, _that.url, _that.sortOrder);
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
    TResult Function(String? id, String? title, String? url,
            @JsonKey(name: 'sort_order') int? sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData():
        return $default(_that.id, _that.title, _that.url, _that.sortOrder);
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
    TResult? Function(String? id, String? title, String? url,
            @JsonKey(name: 'sort_order') int? sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseOverviewVideoData() when $default != null:
        return $default(_that.id, _that.title, _that.url, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourseOverviewVideoData extends CourseOverviewVideoData {
  const _CourseOverviewVideoData(
      {this.id,
      this.title,
      this.url,
      @JsonKey(name: 'sort_order') this.sortOrder})
      : super._();
  factory _CourseOverviewVideoData.fromJson(Map<String, dynamic> json) =>
      _$CourseOverviewVideoDataFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? url;
  @override
  @JsonKey(name: 'sort_order')
  final int? sortOrder;

  /// Create a copy of CourseOverviewVideoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseOverviewVideoDataCopyWith<_CourseOverviewVideoData> get copyWith =>
      __$CourseOverviewVideoDataCopyWithImpl<_CourseOverviewVideoData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseOverviewVideoDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseOverviewVideoData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, url, sortOrder);

  @override
  String toString() {
    return 'CourseOverviewVideoData(id: $id, title: $title, url: $url, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$CourseOverviewVideoDataCopyWith<$Res>
    implements $CourseOverviewVideoDataCopyWith<$Res> {
  factory _$CourseOverviewVideoDataCopyWith(_CourseOverviewVideoData value,
          $Res Function(_CourseOverviewVideoData) _then) =
      __$CourseOverviewVideoDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? url,
      @JsonKey(name: 'sort_order') int? sortOrder});
}

/// @nodoc
class __$CourseOverviewVideoDataCopyWithImpl<$Res>
    implements _$CourseOverviewVideoDataCopyWith<$Res> {
  __$CourseOverviewVideoDataCopyWithImpl(this._self, this._then);

  final _CourseOverviewVideoData _self;
  final $Res Function(_CourseOverviewVideoData) _then;

  /// Create a copy of CourseOverviewVideoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_CourseOverviewVideoData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$LessonData {
  String? get id;
  String? get course;
  String? get title;
  String? get description;
  String? get file;
  List<LessonResourceData>? get resources;

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
            (identical(other.file, file) || other.file == file) &&
            const DeepCollectionEquality().equals(other.resources, resources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, course, title, description,
      file, const DeepCollectionEquality().hash(resources));

  @override
  String toString() {
    return 'LessonData(id: $id, course: $course, title: $title, description: $description, file: $file, resources: $resources)';
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
      String? file,
      List<LessonResourceData>? resources});
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
    Object? resources = freezed,
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
      resources: freezed == resources
          ? _self.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<LessonResourceData>?,
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
    TResult Function(
            String? id,
            String? course,
            String? title,
            String? description,
            String? file,
            List<LessonResourceData>? resources)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(_that.id, _that.course, _that.title, _that.description,
            _that.file, _that.resources);
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
            String? course,
            String? title,
            String? description,
            String? file,
            List<LessonResourceData>? resources)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData():
        return $default(_that.id, _that.course, _that.title, _that.description,
            _that.file, _that.resources);
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
            String? course,
            String? title,
            String? description,
            String? file,
            List<LessonResourceData>? resources)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonData() when $default != null:
        return $default(_that.id, _that.course, _that.title, _that.description,
            _that.file, _that.resources);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LessonData extends LessonData {
  const _LessonData(
      {this.id,
      this.course,
      this.title,
      this.description,
      this.file,
      final List<LessonResourceData>? resources})
      : _resources = resources,
        super._();
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
  final List<LessonResourceData>? _resources;
  @override
  List<LessonResourceData>? get resources {
    final value = _resources;
    if (value == null) return null;
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
            (identical(other.file, file) || other.file == file) &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, course, title, description,
      file, const DeepCollectionEquality().hash(_resources));

  @override
  String toString() {
    return 'LessonData(id: $id, course: $course, title: $title, description: $description, file: $file, resources: $resources)';
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
      String? file,
      List<LessonResourceData>? resources});
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
    Object? resources = freezed,
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
      resources: freezed == resources
          ? _self._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<LessonResourceData>?,
    ));
  }
}

/// @nodoc
mixin _$LessonResourceData {
  String? get id;
  @JsonKey(name: 'lesson_id')
  String? get lessonId;
  @JsonKey(name: 'resource_type')
  String? get resourceType;
  String? get title;
  String? get url;
  @JsonKey(name: 'source_kind')
  String? get sourceKind;
  @JsonKey(name: 'sort_order')
  int? get sortOrder;

  /// Create a copy of LessonResourceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LessonResourceDataCopyWith<LessonResourceData> get copyWith =>
      _$LessonResourceDataCopyWithImpl<LessonResourceData>(
          this as LessonResourceData, _$identity);

  /// Serializes this LessonResourceData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LessonResourceData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.sourceKind, sourceKind) ||
                other.sourceKind == sourceKind) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, lessonId, resourceType,
      title, url, sourceKind, sortOrder);

  @override
  String toString() {
    return 'LessonResourceData(id: $id, lessonId: $lessonId, resourceType: $resourceType, title: $title, url: $url, sourceKind: $sourceKind, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $LessonResourceDataCopyWith<$Res> {
  factory $LessonResourceDataCopyWith(
          LessonResourceData value, $Res Function(LessonResourceData) _then) =
      _$LessonResourceDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'resource_type') String? resourceType,
      String? title,
      String? url,
      @JsonKey(name: 'source_kind') String? sourceKind,
      @JsonKey(name: 'sort_order') int? sortOrder});
}

/// @nodoc
class _$LessonResourceDataCopyWithImpl<$Res>
    implements $LessonResourceDataCopyWith<$Res> {
  _$LessonResourceDataCopyWithImpl(this._self, this._then);

  final LessonResourceData _self;
  final $Res Function(LessonResourceData) _then;

  /// Create a copy of LessonResourceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? lessonId = freezed,
    Object? resourceType = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? sourceKind = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonId: freezed == lessonId
          ? _self.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _self.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceKind: freezed == sourceKind
          ? _self.sourceKind
          : sourceKind // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LessonResourceData].
extension LessonResourceDataPatterns on LessonResourceData {
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
    TResult Function(_LessonResourceData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData() when $default != null:
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
    TResult Function(_LessonResourceData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData():
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
    TResult? Function(_LessonResourceData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData() when $default != null:
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
            @JsonKey(name: 'lesson_id') String? lessonId,
            @JsonKey(name: 'resource_type') String? resourceType,
            String? title,
            String? url,
            @JsonKey(name: 'source_kind') String? sourceKind,
            @JsonKey(name: 'sort_order') int? sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData() when $default != null:
        return $default(_that.id, _that.lessonId, _that.resourceType,
            _that.title, _that.url, _that.sourceKind, _that.sortOrder);
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
            @JsonKey(name: 'lesson_id') String? lessonId,
            @JsonKey(name: 'resource_type') String? resourceType,
            String? title,
            String? url,
            @JsonKey(name: 'source_kind') String? sourceKind,
            @JsonKey(name: 'sort_order') int? sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData():
        return $default(_that.id, _that.lessonId, _that.resourceType,
            _that.title, _that.url, _that.sourceKind, _that.sortOrder);
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
            @JsonKey(name: 'lesson_id') String? lessonId,
            @JsonKey(name: 'resource_type') String? resourceType,
            String? title,
            String? url,
            @JsonKey(name: 'source_kind') String? sourceKind,
            @JsonKey(name: 'sort_order') int? sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LessonResourceData() when $default != null:
        return $default(_that.id, _that.lessonId, _that.resourceType,
            _that.title, _that.url, _that.sourceKind, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LessonResourceData extends LessonResourceData {
  const _LessonResourceData(
      {this.id,
      @JsonKey(name: 'lesson_id') this.lessonId,
      @JsonKey(name: 'resource_type') this.resourceType,
      this.title,
      this.url,
      @JsonKey(name: 'source_kind') this.sourceKind,
      @JsonKey(name: 'sort_order') this.sortOrder})
      : super._();
  factory _LessonResourceData.fromJson(Map<String, dynamic> json) =>
      _$LessonResourceDataFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'lesson_id')
  final String? lessonId;
  @override
  @JsonKey(name: 'resource_type')
  final String? resourceType;
  @override
  final String? title;
  @override
  final String? url;
  @override
  @JsonKey(name: 'source_kind')
  final String? sourceKind;
  @override
  @JsonKey(name: 'sort_order')
  final int? sortOrder;

  /// Create a copy of LessonResourceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LessonResourceDataCopyWith<_LessonResourceData> get copyWith =>
      __$LessonResourceDataCopyWithImpl<_LessonResourceData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LessonResourceDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LessonResourceData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.sourceKind, sourceKind) ||
                other.sourceKind == sourceKind) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, lessonId, resourceType,
      title, url, sourceKind, sortOrder);

  @override
  String toString() {
    return 'LessonResourceData(id: $id, lessonId: $lessonId, resourceType: $resourceType, title: $title, url: $url, sourceKind: $sourceKind, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$LessonResourceDataCopyWith<$Res>
    implements $LessonResourceDataCopyWith<$Res> {
  factory _$LessonResourceDataCopyWith(
          _LessonResourceData value, $Res Function(_LessonResourceData) _then) =
      __$LessonResourceDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'resource_type') String? resourceType,
      String? title,
      String? url,
      @JsonKey(name: 'source_kind') String? sourceKind,
      @JsonKey(name: 'sort_order') int? sortOrder});
}

/// @nodoc
class __$LessonResourceDataCopyWithImpl<$Res>
    implements _$LessonResourceDataCopyWith<$Res> {
  __$LessonResourceDataCopyWithImpl(this._self, this._then);

  final _LessonResourceData _self;
  final $Res Function(_LessonResourceData) _then;

  /// Create a copy of LessonResourceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? lessonId = freezed,
    Object? resourceType = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? sourceKind = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_LessonResourceData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonId: freezed == lessonId
          ? _self.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _self.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceKind: freezed == sourceKind
          ? _self.sourceKind
          : sourceKind // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$CourseCommentData {
  String? get id;
  @JsonKey(name: 'course_id')
  String? get courseId;
  @JsonKey(name: 'user_id')
  String? get userId;
  String? get content;
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  String? get authorName;
  String? get authorRole;

  /// Create a copy of CourseCommentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseCommentDataCopyWith<CourseCommentData> get copyWith =>
      _$CourseCommentDataCopyWithImpl<CourseCommentData>(
          this as CourseCommentData, _$identity);

  /// Serializes this CourseCommentData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseCommentData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorRole, authorRole) ||
                other.authorRole == authorRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, courseId, userId, content,
      createdAt, updatedAt, authorName, authorRole);

  @override
  String toString() {
    return 'CourseCommentData(id: $id, courseId: $courseId, userId: $userId, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, authorName: $authorName, authorRole: $authorRole)';
  }
}

/// @nodoc
abstract mixin class $CourseCommentDataCopyWith<$Res> {
  factory $CourseCommentDataCopyWith(
          CourseCommentData value, $Res Function(CourseCommentData) _then) =
      _$CourseCommentDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'course_id') String? courseId,
      @JsonKey(name: 'user_id') String? userId,
      String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      String? authorName,
      String? authorRole});
}

/// @nodoc
class _$CourseCommentDataCopyWithImpl<$Res>
    implements $CourseCommentDataCopyWith<$Res> {
  _$CourseCommentDataCopyWithImpl(this._self, this._then);

  final CourseCommentData _self;
  final $Res Function(CourseCommentData) _then;

  /// Create a copy of CourseCommentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? courseId = freezed,
    Object? userId = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? authorName = freezed,
    Object? authorRole = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      courseId: freezed == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorRole: freezed == authorRole
          ? _self.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CourseCommentData].
extension CourseCommentDataPatterns on CourseCommentData {
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
    TResult Function(_CourseCommentData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData() when $default != null:
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
    TResult Function(_CourseCommentData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData():
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
    TResult? Function(_CourseCommentData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData() when $default != null:
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
            @JsonKey(name: 'course_id') String? courseId,
            @JsonKey(name: 'user_id') String? userId,
            String? content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? authorName,
            String? authorRole)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData() when $default != null:
        return $default(
            _that.id,
            _that.courseId,
            _that.userId,
            _that.content,
            _that.createdAt,
            _that.updatedAt,
            _that.authorName,
            _that.authorRole);
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
            @JsonKey(name: 'course_id') String? courseId,
            @JsonKey(name: 'user_id') String? userId,
            String? content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? authorName,
            String? authorRole)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData():
        return $default(
            _that.id,
            _that.courseId,
            _that.userId,
            _that.content,
            _that.createdAt,
            _that.updatedAt,
            _that.authorName,
            _that.authorRole);
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
            @JsonKey(name: 'course_id') String? courseId,
            @JsonKey(name: 'user_id') String? userId,
            String? content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? authorName,
            String? authorRole)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseCommentData() when $default != null:
        return $default(
            _that.id,
            _that.courseId,
            _that.userId,
            _that.content,
            _that.createdAt,
            _that.updatedAt,
            _that.authorName,
            _that.authorRole);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourseCommentData extends CourseCommentData {
  const _CourseCommentData(
      {this.id,
      @JsonKey(name: 'course_id') this.courseId,
      @JsonKey(name: 'user_id') this.userId,
      this.content,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.authorName,
      this.authorRole})
      : super._();
  factory _CourseCommentData.fromJson(Map<String, dynamic> json) =>
      _$CourseCommentDataFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'course_id')
  final String? courseId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String? content;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final String? authorName;
  @override
  final String? authorRole;

  /// Create a copy of CourseCommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseCommentDataCopyWith<_CourseCommentData> get copyWith =>
      __$CourseCommentDataCopyWithImpl<_CourseCommentData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseCommentDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseCommentData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorRole, authorRole) ||
                other.authorRole == authorRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, courseId, userId, content,
      createdAt, updatedAt, authorName, authorRole);

  @override
  String toString() {
    return 'CourseCommentData(id: $id, courseId: $courseId, userId: $userId, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, authorName: $authorName, authorRole: $authorRole)';
  }
}

/// @nodoc
abstract mixin class _$CourseCommentDataCopyWith<$Res>
    implements $CourseCommentDataCopyWith<$Res> {
  factory _$CourseCommentDataCopyWith(
          _CourseCommentData value, $Res Function(_CourseCommentData) _then) =
      __$CourseCommentDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'course_id') String? courseId,
      @JsonKey(name: 'user_id') String? userId,
      String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      String? authorName,
      String? authorRole});
}

/// @nodoc
class __$CourseCommentDataCopyWithImpl<$Res>
    implements _$CourseCommentDataCopyWith<$Res> {
  __$CourseCommentDataCopyWithImpl(this._self, this._then);

  final _CourseCommentData _self;
  final $Res Function(_CourseCommentData) _then;

  /// Create a copy of CourseCommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? courseId = freezed,
    Object? userId = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? authorName = freezed,
    Object? authorRole = freezed,
  }) {
    return _then(_CourseCommentData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      courseId: freezed == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      authorRole: freezed == authorRole
          ? _self.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
