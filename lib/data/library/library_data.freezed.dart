// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LibraryData _$LibraryDataFromJson(Map<String, dynamic> json) {
  return _LibraryData.fromJson(json);
}

/// @nodoc
mixin _$LibraryData {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  BookType? get type => throw _privateConstructorUsedError;

  /// Serializes this LibraryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LibraryDataCopyWith<LibraryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryDataCopyWith<$Res> {
  factory $LibraryDataCopyWith(
          LibraryData value, $Res Function(LibraryData) then) =
      _$LibraryDataCopyWithImpl<$Res, LibraryData>;
  @useResult
  $Res call({String? id, String? title, String? author, BookType? type});
}

/// @nodoc
class _$LibraryDataCopyWithImpl<$Res, $Val extends LibraryData>
    implements $LibraryDataCopyWith<$Res> {
  _$LibraryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? type = freezed,
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
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BookType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LibraryDataImplCopyWith<$Res>
    implements $LibraryDataCopyWith<$Res> {
  factory _$$LibraryDataImplCopyWith(
          _$LibraryDataImpl value, $Res Function(_$LibraryDataImpl) then) =
      __$$LibraryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? title, String? author, BookType? type});
}

/// @nodoc
class __$$LibraryDataImplCopyWithImpl<$Res>
    extends _$LibraryDataCopyWithImpl<$Res, _$LibraryDataImpl>
    implements _$$LibraryDataImplCopyWith<$Res> {
  __$$LibraryDataImplCopyWithImpl(
      _$LibraryDataImpl _value, $Res Function(_$LibraryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? type = freezed,
  }) {
    return _then(_$LibraryDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BookType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LibraryDataImpl extends _LibraryData {
  const _$LibraryDataImpl({this.id, this.title, this.author, this.type})
      : super._();

  factory _$LibraryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LibraryDataImplFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final BookType? type;

  @override
  String toString() {
    return 'LibraryData(id: $id, title: $title, author: $author, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, type);

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryDataImplCopyWith<_$LibraryDataImpl> get copyWith =>
      __$$LibraryDataImplCopyWithImpl<_$LibraryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LibraryDataImplToJson(
      this,
    );
  }
}

abstract class _LibraryData extends LibraryData {
  const factory _LibraryData(
      {final String? id,
      final String? title,
      final String? author,
      final BookType? type}) = _$LibraryDataImpl;
  const _LibraryData._() : super._();

  factory _LibraryData.fromJson(Map<String, dynamic> json) =
      _$LibraryDataImpl.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get author;
  @override
  BookType? get type;

  /// Create a copy of LibraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryDataImplCopyWith<_$LibraryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
