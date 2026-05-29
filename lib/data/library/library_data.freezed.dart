// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryData {
  String? get id;
  String? get title;
  String? get author;
  String? get book;
  BookType? get category;
  String? get bookCover;
  String? get description;
  String? get language;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryDataCopyWith<LibraryData> get copyWith =>
      _$LibraryDataCopyWithImpl<LibraryData>(this as LibraryData, _$identity);

  /// Serializes this LibraryData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.bookCover, bookCover) ||
                other.bookCover == bookCover) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, book,
      category, bookCover, description, language);

  @override
  String toString() {
    return 'LibraryData(id: $id, title: $title, author: $author, book: $book, category: $category, bookCover: $bookCover, description: $description, language: $language)';
  }
}

/// @nodoc
abstract mixin class $LibraryDataCopyWith<$Res> {
  factory $LibraryDataCopyWith(
          LibraryData value, $Res Function(LibraryData) _then) =
      _$LibraryDataCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? author,
      String? book,
      BookType? category,
      String? bookCover,
      String? description,
      String? language});
}

/// @nodoc
class _$LibraryDataCopyWithImpl<$Res> implements $LibraryDataCopyWith<$Res> {
  _$LibraryDataCopyWithImpl(this._self, this._then);

  final LibraryData _self;
  final $Res Function(LibraryData) _then;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? book = freezed,
    Object? category = freezed,
    Object? bookCover = freezed,
    Object? description = freezed,
    Object? language = freezed,
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
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      book: freezed == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as BookType?,
      bookCover: freezed == bookCover
          ? _self.bookCover
          : bookCover // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LibraryData].
extension LibraryDataPatterns on LibraryData {
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
    TResult Function(_LibraryData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryData() when $default != null:
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
    TResult Function(_LibraryData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryData():
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
    TResult? Function(_LibraryData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryData() when $default != null:
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
            String? author,
            String? book,
            BookType? category,
            String? bookCover,
            String? description,
            String? language)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryData() when $default != null:
        return $default(_that.id, _that.title, _that.author, _that.book,
            _that.category, _that.bookCover, _that.description, _that.language);
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
            String? author,
            String? book,
            BookType? category,
            String? bookCover,
            String? description,
            String? language)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryData():
        return $default(_that.id, _that.title, _that.author, _that.book,
            _that.category, _that.bookCover, _that.description, _that.language);
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
            String? author,
            String? book,
            BookType? category,
            String? bookCover,
            String? description,
            String? language)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryData() when $default != null:
        return $default(_that.id, _that.title, _that.author, _that.book,
            _that.category, _that.bookCover, _that.description, _that.language);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LibraryData extends LibraryData {
  const _LibraryData(
      {this.id,
      this.title,
      this.author,
      this.book,
      this.category,
      this.bookCover,
      this.description,
      this.language})
      : super._();
  factory _LibraryData.fromJson(Map<String, dynamic> json) =>
      _$LibraryDataFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final String? book;
  @override
  final BookType? category;
  @override
  final String? bookCover;
  @override
  final String? description;
  @override
  final String? language;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LibraryDataCopyWith<_LibraryData> get copyWith =>
      __$LibraryDataCopyWithImpl<_LibraryData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LibraryDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LibraryData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.bookCover, bookCover) ||
                other.bookCover == bookCover) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, book,
      category, bookCover, description, language);

  @override
  String toString() {
    return 'LibraryData(id: $id, title: $title, author: $author, book: $book, category: $category, bookCover: $bookCover, description: $description, language: $language)';
  }
}

/// @nodoc
abstract mixin class _$LibraryDataCopyWith<$Res>
    implements $LibraryDataCopyWith<$Res> {
  factory _$LibraryDataCopyWith(
          _LibraryData value, $Res Function(_LibraryData) _then) =
      __$LibraryDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? author,
      String? book,
      BookType? category,
      String? bookCover,
      String? description,
      String? language});
}

/// @nodoc
class __$LibraryDataCopyWithImpl<$Res> implements _$LibraryDataCopyWith<$Res> {
  __$LibraryDataCopyWithImpl(this._self, this._then);

  final _LibraryData _self;
  final $Res Function(_LibraryData) _then;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? book = freezed,
    Object? category = freezed,
    Object? bookCover = freezed,
    Object? description = freezed,
    Object? language = freezed,
  }) {
    return _then(_LibraryData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      book: freezed == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as BookType?,
      bookCover: freezed == bookCover
          ? _self.bookCover
          : bookCover // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
