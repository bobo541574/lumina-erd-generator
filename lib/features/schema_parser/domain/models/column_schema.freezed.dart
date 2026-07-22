// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'column_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ColumnSchema _$ColumnSchemaFromJson(Map<String, dynamic> json) {
  return _ColumnSchema.fromJson(json);
}

/// @nodoc
mixin _$ColumnSchema {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;
  bool get unique => throw _privateConstructorUsedError;
  bool get primary => throw _privateConstructorUsedError;
  String? get defaultValue => throw _privateConstructorUsedError;
  int? get length => throw _privateConstructorUsedError;
  bool get unsigned => throw _privateConstructorUsedError;
  bool get autoIncrement => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get foreignTable => throw _privateConstructorUsedError;
  String? get foreignColumn => throw _privateConstructorUsedError;

  /// Serializes this ColumnSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ColumnSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColumnSchemaCopyWith<ColumnSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColumnSchemaCopyWith<$Res> {
  factory $ColumnSchemaCopyWith(
    ColumnSchema value,
    $Res Function(ColumnSchema) then,
  ) = _$ColumnSchemaCopyWithImpl<$Res, ColumnSchema>;
  @useResult
  $Res call({
    String name,
    String type,
    bool nullable,
    bool unique,
    bool primary,
    String? defaultValue,
    int? length,
    bool unsigned,
    bool autoIncrement,
    String? comment,
    String? foreignTable,
    String? foreignColumn,
  });
}

/// @nodoc
class _$ColumnSchemaCopyWithImpl<$Res, $Val extends ColumnSchema>
    implements $ColumnSchemaCopyWith<$Res> {
  _$ColumnSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColumnSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? nullable = null,
    Object? unique = null,
    Object? primary = null,
    Object? defaultValue = freezed,
    Object? length = freezed,
    Object? unsigned = null,
    Object? autoIncrement = null,
    Object? comment = freezed,
    Object? foreignTable = freezed,
    Object? foreignColumn = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            nullable: null == nullable
                ? _value.nullable
                : nullable // ignore: cast_nullable_to_non_nullable
                      as bool,
            unique: null == unique
                ? _value.unique
                : unique // ignore: cast_nullable_to_non_nullable
                      as bool,
            primary: null == primary
                ? _value.primary
                : primary // ignore: cast_nullable_to_non_nullable
                      as bool,
            defaultValue: freezed == defaultValue
                ? _value.defaultValue
                : defaultValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            length: freezed == length
                ? _value.length
                : length // ignore: cast_nullable_to_non_nullable
                      as int?,
            unsigned: null == unsigned
                ? _value.unsigned
                : unsigned // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoIncrement: null == autoIncrement
                ? _value.autoIncrement
                : autoIncrement // ignore: cast_nullable_to_non_nullable
                      as bool,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            foreignTable: freezed == foreignTable
                ? _value.foreignTable
                : foreignTable // ignore: cast_nullable_to_non_nullable
                      as String?,
            foreignColumn: freezed == foreignColumn
                ? _value.foreignColumn
                : foreignColumn // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ColumnSchemaImplCopyWith<$Res>
    implements $ColumnSchemaCopyWith<$Res> {
  factory _$$ColumnSchemaImplCopyWith(
    _$ColumnSchemaImpl value,
    $Res Function(_$ColumnSchemaImpl) then,
  ) = __$$ColumnSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String type,
    bool nullable,
    bool unique,
    bool primary,
    String? defaultValue,
    int? length,
    bool unsigned,
    bool autoIncrement,
    String? comment,
    String? foreignTable,
    String? foreignColumn,
  });
}

/// @nodoc
class __$$ColumnSchemaImplCopyWithImpl<$Res>
    extends _$ColumnSchemaCopyWithImpl<$Res, _$ColumnSchemaImpl>
    implements _$$ColumnSchemaImplCopyWith<$Res> {
  __$$ColumnSchemaImplCopyWithImpl(
    _$ColumnSchemaImpl _value,
    $Res Function(_$ColumnSchemaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ColumnSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? nullable = null,
    Object? unique = null,
    Object? primary = null,
    Object? defaultValue = freezed,
    Object? length = freezed,
    Object? unsigned = null,
    Object? autoIncrement = null,
    Object? comment = freezed,
    Object? foreignTable = freezed,
    Object? foreignColumn = freezed,
  }) {
    return _then(
      _$ColumnSchemaImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        nullable: null == nullable
            ? _value.nullable
            : nullable // ignore: cast_nullable_to_non_nullable
                  as bool,
        unique: null == unique
            ? _value.unique
            : unique // ignore: cast_nullable_to_non_nullable
                  as bool,
        primary: null == primary
            ? _value.primary
            : primary // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultValue: freezed == defaultValue
            ? _value.defaultValue
            : defaultValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        length: freezed == length
            ? _value.length
            : length // ignore: cast_nullable_to_non_nullable
                  as int?,
        unsigned: null == unsigned
            ? _value.unsigned
            : unsigned // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoIncrement: null == autoIncrement
            ? _value.autoIncrement
            : autoIncrement // ignore: cast_nullable_to_non_nullable
                  as bool,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        foreignTable: freezed == foreignTable
            ? _value.foreignTable
            : foreignTable // ignore: cast_nullable_to_non_nullable
                  as String?,
        foreignColumn: freezed == foreignColumn
            ? _value.foreignColumn
            : foreignColumn // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ColumnSchemaImpl extends _ColumnSchema {
  const _$ColumnSchemaImpl({
    required this.name,
    required this.type,
    this.nullable = false,
    this.unique = false,
    this.primary = false,
    this.defaultValue,
    this.length,
    this.unsigned = false,
    this.autoIncrement = false,
    this.comment,
    this.foreignTable,
    this.foreignColumn,
  }) : super._();

  factory _$ColumnSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColumnSchemaImplFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey()
  final bool nullable;
  @override
  @JsonKey()
  final bool unique;
  @override
  @JsonKey()
  final bool primary;
  @override
  final String? defaultValue;
  @override
  final int? length;
  @override
  @JsonKey()
  final bool unsigned;
  @override
  @JsonKey()
  final bool autoIncrement;
  @override
  final String? comment;
  @override
  final String? foreignTable;
  @override
  final String? foreignColumn;

  @override
  String toString() {
    return 'ColumnSchema(name: $name, type: $type, nullable: $nullable, unique: $unique, primary: $primary, defaultValue: $defaultValue, length: $length, unsigned: $unsigned, autoIncrement: $autoIncrement, comment: $comment, foreignTable: $foreignTable, foreignColumn: $foreignColumn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColumnSchemaImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nullable, nullable) ||
                other.nullable == nullable) &&
            (identical(other.unique, unique) || other.unique == unique) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.unsigned, unsigned) ||
                other.unsigned == unsigned) &&
            (identical(other.autoIncrement, autoIncrement) ||
                other.autoIncrement == autoIncrement) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.foreignTable, foreignTable) ||
                other.foreignTable == foreignTable) &&
            (identical(other.foreignColumn, foreignColumn) ||
                other.foreignColumn == foreignColumn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    type,
    nullable,
    unique,
    primary,
    defaultValue,
    length,
    unsigned,
    autoIncrement,
    comment,
    foreignTable,
    foreignColumn,
  );

  /// Create a copy of ColumnSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColumnSchemaImplCopyWith<_$ColumnSchemaImpl> get copyWith =>
      __$$ColumnSchemaImplCopyWithImpl<_$ColumnSchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColumnSchemaImplToJson(this);
  }
}

abstract class _ColumnSchema extends ColumnSchema {
  const factory _ColumnSchema({
    required final String name,
    required final String type,
    final bool nullable,
    final bool unique,
    final bool primary,
    final String? defaultValue,
    final int? length,
    final bool unsigned,
    final bool autoIncrement,
    final String? comment,
    final String? foreignTable,
    final String? foreignColumn,
  }) = _$ColumnSchemaImpl;
  const _ColumnSchema._() : super._();

  factory _ColumnSchema.fromJson(Map<String, dynamic> json) =
      _$ColumnSchemaImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  bool get nullable;
  @override
  bool get unique;
  @override
  bool get primary;
  @override
  String? get defaultValue;
  @override
  int? get length;
  @override
  bool get unsigned;
  @override
  bool get autoIncrement;
  @override
  String? get comment;
  @override
  String? get foreignTable;
  @override
  String? get foreignColumn;

  /// Create a copy of ColumnSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColumnSchemaImplCopyWith<_$ColumnSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
