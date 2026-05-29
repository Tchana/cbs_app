// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherData {
  String? get id;
  String? get name;
  String? get phoneNumber;
  ProfileImage? get profileImage;
  List<CourseData>? get courses;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeacherDataCopyWith<TeacherData> get copyWith =>
      _$TeacherDataCopyWithImpl<TeacherData>(this as TeacherData, _$identity);

  /// Serializes this TeacherData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeacherData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality().equals(other.courses, courses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phoneNumber,
      profileImage, const DeepCollectionEquality().hash(courses));

  @override
  String toString() {
    return 'TeacherData(id: $id, name: $name, phoneNumber: $phoneNumber, profileImage: $profileImage, courses: $courses)';
  }
}

/// @nodoc
abstract mixin class $TeacherDataCopyWith<$Res> {
  factory $TeacherDataCopyWith(
          TeacherData value, $Res Function(TeacherData) _then) =
      _$TeacherDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? phoneNumber,
      ProfileImage? profileImage,
      List<CourseData>? courses});

  $ProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class _$TeacherDataCopyWithImpl<$Res> implements $TeacherDataCopyWith<$Res> {
  _$TeacherDataCopyWithImpl(this._self, this._then);

  final TeacherData _self;
  final $Res Function(TeacherData) _then;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? profileImage = freezed,
    Object? courses = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as ProfileImage?,
      courses: freezed == courses
          ? _self.courses
          : courses // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ));
  }

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileImageCopyWith<$Res>? get profileImage {
    if (_self.profileImage == null) {
      return null;
    }

    return $ProfileImageCopyWith<$Res>(_self.profileImage!, (value) {
      return _then(_self.copyWith(profileImage: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TeacherData].
extension TeacherDataPatterns on TeacherData {
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
    TResult Function(_TeacherData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeacherData() when $default != null:
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
    TResult Function(_TeacherData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeacherData():
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
    TResult? Function(_TeacherData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeacherData() when $default != null:
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
    TResult Function(String? id, String? name, String? phoneNumber,
            ProfileImage? profileImage, List<CourseData>? courses)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeacherData() when $default != null:
        return $default(_that.id, _that.name, _that.phoneNumber,
            _that.profileImage, _that.courses);
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
    TResult Function(String? id, String? name, String? phoneNumber,
            ProfileImage? profileImage, List<CourseData>? courses)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeacherData():
        return $default(_that.id, _that.name, _that.phoneNumber,
            _that.profileImage, _that.courses);
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
    TResult? Function(String? id, String? name, String? phoneNumber,
            ProfileImage? profileImage, List<CourseData>? courses)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeacherData() when $default != null:
        return $default(_that.id, _that.name, _that.phoneNumber,
            _that.profileImage, _that.courses);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TeacherData extends TeacherData {
  const _TeacherData(
      {this.id,
      this.name,
      this.phoneNumber,
      this.profileImage,
      final List<CourseData>? courses})
      : _courses = courses,
        super._();
  factory _TeacherData.fromJson(Map<String, dynamic> json) =>
      _$TeacherDataFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? phoneNumber;
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

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeacherDataCopyWith<_TeacherData> get copyWith =>
      __$TeacherDataCopyWithImpl<_TeacherData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeacherDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeacherData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality().equals(other._courses, _courses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phoneNumber,
      profileImage, const DeepCollectionEquality().hash(_courses));

  @override
  String toString() {
    return 'TeacherData(id: $id, name: $name, phoneNumber: $phoneNumber, profileImage: $profileImage, courses: $courses)';
  }
}

/// @nodoc
abstract mixin class _$TeacherDataCopyWith<$Res>
    implements $TeacherDataCopyWith<$Res> {
  factory _$TeacherDataCopyWith(
          _TeacherData value, $Res Function(_TeacherData) _then) =
      __$TeacherDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? phoneNumber,
      ProfileImage? profileImage,
      List<CourseData>? courses});

  @override
  $ProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class __$TeacherDataCopyWithImpl<$Res> implements _$TeacherDataCopyWith<$Res> {
  __$TeacherDataCopyWithImpl(this._self, this._then);

  final _TeacherData _self;
  final $Res Function(_TeacherData) _then;

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? phoneNumber = freezed,
    Object? profileImage = freezed,
    Object? courses = freezed,
  }) {
    return _then(_TeacherData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as ProfileImage?,
      courses: freezed == courses
          ? _self._courses
          : courses // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ));
  }

  /// Create a copy of TeacherData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileImageCopyWith<$Res>? get profileImage {
    if (_self.profileImage == null) {
      return null;
    }

    return $ProfileImageCopyWith<$Res>(_self.profileImage!, (value) {
      return _then(_self.copyWith(profileImage: value));
    });
  }
}

/// @nodoc
mixin _$ProfileImage {
  String? get id;
  String? get url;
  String? get text;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileImageCopyWith<ProfileImage> get copyWith =>
      _$ProfileImageCopyWithImpl<ProfileImage>(
          this as ProfileImage, _$identity);

  /// Serializes this ProfileImage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileImage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, text);

  @override
  String toString() {
    return 'ProfileImage(id: $id, url: $url, text: $text)';
  }
}

/// @nodoc
abstract mixin class $ProfileImageCopyWith<$Res> {
  factory $ProfileImageCopyWith(
          ProfileImage value, $Res Function(ProfileImage) _then) =
      _$ProfileImageCopyWithImpl;
  @useResult
  $Res call({String? id, String? url, String? text});
}

/// @nodoc
class _$ProfileImageCopyWithImpl<$Res> implements $ProfileImageCopyWith<$Res> {
  _$ProfileImageCopyWithImpl(this._self, this._then);

  final ProfileImage _self;
  final $Res Function(ProfileImage) _then;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? text = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileImage].
extension ProfileImagePatterns on ProfileImage {
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
    TResult Function(_ProfileImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileImage() when $default != null:
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
    TResult Function(_ProfileImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileImage():
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
    TResult? Function(_ProfileImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileImage() when $default != null:
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
    TResult Function(String? id, String? url, String? text)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileImage() when $default != null:
        return $default(_that.id, _that.url, _that.text);
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
    TResult Function(String? id, String? url, String? text) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileImage():
        return $default(_that.id, _that.url, _that.text);
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
    TResult? Function(String? id, String? url, String? text)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileImage() when $default != null:
        return $default(_that.id, _that.url, _that.text);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfileImage extends ProfileImage {
  const _ProfileImage({this.id, this.url, this.text}) : super._();
  factory _ProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageFromJson(json);

  @override
  final String? id;
  @override
  final String? url;
  @override
  final String? text;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileImageCopyWith<_ProfileImage> get copyWith =>
      __$ProfileImageCopyWithImpl<_ProfileImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileImageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileImage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, text);

  @override
  String toString() {
    return 'ProfileImage(id: $id, url: $url, text: $text)';
  }
}

/// @nodoc
abstract mixin class _$ProfileImageCopyWith<$Res>
    implements $ProfileImageCopyWith<$Res> {
  factory _$ProfileImageCopyWith(
          _ProfileImage value, $Res Function(_ProfileImage) _then) =
      __$ProfileImageCopyWithImpl;
  @override
  @useResult
  $Res call({String? id, String? url, String? text});
}

/// @nodoc
class __$ProfileImageCopyWithImpl<$Res>
    implements _$ProfileImageCopyWith<$Res> {
  __$ProfileImageCopyWithImpl(this._self, this._then);

  final _ProfileImage _self;
  final $Res Function(_ProfileImage) _then;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? text = freezed,
  }) {
    return _then(_ProfileImage(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
