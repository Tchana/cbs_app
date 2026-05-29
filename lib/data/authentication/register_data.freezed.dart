// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterData {
  String? get id;
  String? get email;
  String? get password;
  String? get firstName;
  String? get lastName;
  String? get phone;
  String? get vocation;
  String? get testimony;
  String? get journey;
  String? get pImage;
  String? get role;
  List<CourseData>? get course;

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterDataCopyWith<RegisterData> get copyWith =>
      _$RegisterDataCopyWithImpl<RegisterData>(
          this as RegisterData, _$identity);

  /// Serializes this RegisterData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.vocation, vocation) ||
                other.vocation == vocation) &&
            (identical(other.testimony, testimony) ||
                other.testimony == testimony) &&
            (identical(other.journey, journey) || other.journey == journey) &&
            (identical(other.pImage, pImage) || other.pImage == pImage) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(other.course, course));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      password,
      firstName,
      lastName,
      phone,
      vocation,
      testimony,
      journey,
      pImage,
      role,
      const DeepCollectionEquality().hash(course));

  @override
  String toString() {
    return 'RegisterData(id: $id, email: $email, password: $password, firstName: $firstName, lastName: $lastName, phone: $phone, vocation: $vocation, testimony: $testimony, journey: $journey, pImage: $pImage, role: $role, course: $course)';
  }
}

/// @nodoc
abstract mixin class $RegisterDataCopyWith<$Res> {
  factory $RegisterDataCopyWith(
          RegisterData value, $Res Function(RegisterData) _then) =
      _$RegisterDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? phone,
      String? vocation,
      String? testimony,
      String? journey,
      String? pImage,
      String? role,
      List<CourseData>? course});
}

/// @nodoc
class _$RegisterDataCopyWithImpl<$Res> implements $RegisterDataCopyWith<$Res> {
  _$RegisterDataCopyWithImpl(this._self, this._then);

  final RegisterData _self;
  final $Res Function(RegisterData) _then;

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
    Object? phone = freezed,
    Object? vocation = freezed,
    Object? testimony = freezed,
    Object? journey = freezed,
    Object? pImage = freezed,
    Object? role = freezed,
    Object? course = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      vocation: freezed == vocation
          ? _self.vocation
          : vocation // ignore: cast_nullable_to_non_nullable
              as String?,
      testimony: freezed == testimony
          ? _self.testimony
          : testimony // ignore: cast_nullable_to_non_nullable
              as String?,
      journey: freezed == journey
          ? _self.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as String?,
      pImage: freezed == pImage
          ? _self.pImage
          : pImage // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RegisterData].
extension RegisterDataPatterns on RegisterData {
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
    TResult Function(_RegisterData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RegisterData() when $default != null:
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
    TResult Function(_RegisterData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterData():
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
    TResult? Function(_RegisterData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterData() when $default != null:
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
            String? email,
            String? password,
            String? firstName,
            String? lastName,
            String? phone,
            String? vocation,
            String? testimony,
            String? journey,
            String? pImage,
            String? role,
            List<CourseData>? course)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RegisterData() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.firstName,
            _that.lastName,
            _that.phone,
            _that.vocation,
            _that.testimony,
            _that.journey,
            _that.pImage,
            _that.role,
            _that.course);
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
            String? email,
            String? password,
            String? firstName,
            String? lastName,
            String? phone,
            String? vocation,
            String? testimony,
            String? journey,
            String? pImage,
            String? role,
            List<CourseData>? course)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterData():
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.firstName,
            _that.lastName,
            _that.phone,
            _that.vocation,
            _that.testimony,
            _that.journey,
            _that.pImage,
            _that.role,
            _that.course);
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
            String? email,
            String? password,
            String? firstName,
            String? lastName,
            String? phone,
            String? vocation,
            String? testimony,
            String? journey,
            String? pImage,
            String? role,
            List<CourseData>? course)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RegisterData() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.firstName,
            _that.lastName,
            _that.phone,
            _that.vocation,
            _that.testimony,
            _that.journey,
            _that.pImage,
            _that.role,
            _that.course);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RegisterData extends RegisterData {
  const _RegisterData(
      {this.id,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.phone,
      this.vocation,
      this.testimony,
      this.journey,
      this.pImage,
      this.role,
      final List<CourseData>? course})
      : _course = course,
        super._();
  factory _RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

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
  final String? phone;
  @override
  final String? vocation;
  @override
  final String? testimony;
  @override
  final String? journey;
  @override
  final String? pImage;
  @override
  final String? role;
  final List<CourseData>? _course;
  @override
  List<CourseData>? get course {
    final value = _course;
    if (value == null) return null;
    if (_course is EqualUnmodifiableListView) return _course;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RegisterDataCopyWith<_RegisterData> get copyWith =>
      __$RegisterDataCopyWithImpl<_RegisterData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RegisterDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RegisterData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.vocation, vocation) ||
                other.vocation == vocation) &&
            (identical(other.testimony, testimony) ||
                other.testimony == testimony) &&
            (identical(other.journey, journey) || other.journey == journey) &&
            (identical(other.pImage, pImage) || other.pImage == pImage) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(other._course, _course));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      password,
      firstName,
      lastName,
      phone,
      vocation,
      testimony,
      journey,
      pImage,
      role,
      const DeepCollectionEquality().hash(_course));

  @override
  String toString() {
    return 'RegisterData(id: $id, email: $email, password: $password, firstName: $firstName, lastName: $lastName, phone: $phone, vocation: $vocation, testimony: $testimony, journey: $journey, pImage: $pImage, role: $role, course: $course)';
  }
}

/// @nodoc
abstract mixin class _$RegisterDataCopyWith<$Res>
    implements $RegisterDataCopyWith<$Res> {
  factory _$RegisterDataCopyWith(
          _RegisterData value, $Res Function(_RegisterData) _then) =
      __$RegisterDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? phone,
      String? vocation,
      String? testimony,
      String? journey,
      String? pImage,
      String? role,
      List<CourseData>? course});
}

/// @nodoc
class __$RegisterDataCopyWithImpl<$Res>
    implements _$RegisterDataCopyWith<$Res> {
  __$RegisterDataCopyWithImpl(this._self, this._then);

  final _RegisterData _self;
  final $Res Function(_RegisterData) _then;

  /// Create a copy of RegisterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phone = freezed,
    Object? vocation = freezed,
    Object? testimony = freezed,
    Object? journey = freezed,
    Object? pImage = freezed,
    Object? role = freezed,
    Object? course = freezed,
  }) {
    return _then(_RegisterData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      vocation: freezed == vocation
          ? _self.vocation
          : vocation // ignore: cast_nullable_to_non_nullable
              as String?,
      testimony: freezed == testimony
          ? _self.testimony
          : testimony // ignore: cast_nullable_to_non_nullable
              as String?,
      journey: freezed == journey
          ? _self.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as String?,
      pImage: freezed == pImage
          ? _self.pImage
          : pImage // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _self._course
          : course // ignore: cast_nullable_to_non_nullable
              as List<CourseData>?,
    ));
  }
}

// dart format on
