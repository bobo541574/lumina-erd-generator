// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TableSchema _$TableSchemaFromJson(Map<String, dynamic> json) {
  return _TableSchema.fromJson(json);
}

/// @nodoc
mixin _$TableSchema {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<ColumnSchema> get columns => throw _privateConstructorUsedError;
  List<IndexSchema> get indexes => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  bool get isPivot => throw _privateConstructorUsedError;

  /// Serializes this TableSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableSchemaCopyWith<TableSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableSchemaCopyWith<$Res> {
  factory $TableSchemaCopyWith(
    TableSchema value,
    $Res Function(TableSchema) then,
  ) = _$TableSchemaCopyWithImpl<$Res, TableSchema>;
  @useResult
  $Res call({
    String id,
    String name,
    List<ColumnSchema> columns,
    List<IndexSchema> indexes,
    String? comment,
    bool isPivot,
  });
}

/// @nodoc
class _$TableSchemaCopyWithImpl<$Res, $Val extends TableSchema>
    implements $TableSchemaCopyWith<$Res> {
  _$TableSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? columns = null,
    Object? indexes = null,
    Object? comment = freezed,
    Object? isPivot = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            columns: null == columns
                ? _value.columns
                : columns // ignore: cast_nullable_to_non_nullable
                      as List<ColumnSchema>,
            indexes: null == indexes
                ? _value.indexes
                : indexes // ignore: cast_nullable_to_non_nullable
                      as List<IndexSchema>,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPivot: null == isPivot
                ? _value.isPivot
                : isPivot // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TableSchemaImplCopyWith<$Res>
    implements $TableSchemaCopyWith<$Res> {
  factory _$$TableSchemaImplCopyWith(
    _$TableSchemaImpl value,
    $Res Function(_$TableSchemaImpl) then,
  ) = __$$TableSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<ColumnSchema> columns,
    List<IndexSchema> indexes,
    String? comment,
    bool isPivot,
  });
}

/// @nodoc
class __$$TableSchemaImplCopyWithImpl<$Res>
    extends _$TableSchemaCopyWithImpl<$Res, _$TableSchemaImpl>
    implements _$$TableSchemaImplCopyWith<$Res> {
  __$$TableSchemaImplCopyWithImpl(
    _$TableSchemaImpl _value,
    $Res Function(_$TableSchemaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TableSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? columns = null,
    Object? indexes = null,
    Object? comment = freezed,
    Object? isPivot = null,
  }) {
    return _then(
      _$TableSchemaImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        columns: null == columns
            ? _value._columns
            : columns // ignore: cast_nullable_to_non_nullable
                  as List<ColumnSchema>,
        indexes: null == indexes
            ? _value._indexes
            : indexes // ignore: cast_nullable_to_non_nullable
                  as List<IndexSchema>,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPivot: null == isPivot
            ? _value.isPivot
            : isPivot // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TableSchemaImpl extends _TableSchema {
  const _$TableSchemaImpl({
    required this.id,
    required this.name,
    required final List<ColumnSchema> columns,
    final List<IndexSchema> indexes = const [],
    this.comment,
    this.isPivot = false,
  }) : _columns = columns,
       _indexes = indexes,
       super._();

  factory _$TableSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableSchemaImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<ColumnSchema> _columns;
  @override
  List<ColumnSchema> get columns {
    if (_columns is EqualUnmodifiableListView) return _columns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_columns);
  }

  final List<IndexSchema> _indexes;
  @override
  @JsonKey()
  List<IndexSchema> get indexes {
    if (_indexes is EqualUnmodifiableListView) return _indexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_indexes);
  }

  @override
  final String? comment;
  @override
  @JsonKey()
  final bool isPivot;

  @override
  String toString() {
    return 'TableSchema(id: $id, name: $name, columns: $columns, indexes: $indexes, comment: $comment, isPivot: $isPivot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableSchemaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._columns, _columns) &&
            const DeepCollectionEquality().equals(other._indexes, _indexes) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isPivot, isPivot) || other.isPivot == isPivot));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_columns),
    const DeepCollectionEquality().hash(_indexes),
    comment,
    isPivot,
  );

  /// Create a copy of TableSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableSchemaImplCopyWith<_$TableSchemaImpl> get copyWith =>
      __$$TableSchemaImplCopyWithImpl<_$TableSchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableSchemaImplToJson(this);
  }
}

abstract class _TableSchema extends TableSchema {
  const factory _TableSchema({
    required final String id,
    required final String name,
    required final List<ColumnSchema> columns,
    final List<IndexSchema> indexes,
    final String? comment,
    final bool isPivot,
  }) = _$TableSchemaImpl;
  const _TableSchema._() : super._();

  factory _TableSchema.fromJson(Map<String, dynamic> json) =
      _$TableSchemaImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<ColumnSchema> get columns;
  @override
  List<IndexSchema> get indexes;
  @override
  String? get comment;
  @override
  bool get isPivot;

  /// Create a copy of TableSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableSchemaImplCopyWith<_$TableSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndexSchema _$IndexSchemaFromJson(Map<String, dynamic> json) {
  return _IndexSchema.fromJson(json);
}

/// @nodoc
mixin _$IndexSchema {
  String get name => throw _privateConstructorUsedError;
  List<String> get columns => throw _privateConstructorUsedError;
  bool get unique => throw _privateConstructorUsedError;
  bool get primary => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this IndexSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndexSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndexSchemaCopyWith<IndexSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndexSchemaCopyWith<$Res> {
  factory $IndexSchemaCopyWith(
    IndexSchema value,
    $Res Function(IndexSchema) then,
  ) = _$IndexSchemaCopyWithImpl<$Res, IndexSchema>;
  @useResult
  $Res call({
    String name,
    List<String> columns,
    bool unique,
    bool primary,
    String? type,
  });
}

/// @nodoc
class _$IndexSchemaCopyWithImpl<$Res, $Val extends IndexSchema>
    implements $IndexSchemaCopyWith<$Res> {
  _$IndexSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndexSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? columns = null,
    Object? unique = null,
    Object? primary = null,
    Object? type = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            columns: null == columns
                ? _value.columns
                : columns // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            unique: null == unique
                ? _value.unique
                : unique // ignore: cast_nullable_to_non_nullable
                      as bool,
            primary: null == primary
                ? _value.primary
                : primary // ignore: cast_nullable_to_non_nullable
                      as bool,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IndexSchemaImplCopyWith<$Res>
    implements $IndexSchemaCopyWith<$Res> {
  factory _$$IndexSchemaImplCopyWith(
    _$IndexSchemaImpl value,
    $Res Function(_$IndexSchemaImpl) then,
  ) = __$$IndexSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    List<String> columns,
    bool unique,
    bool primary,
    String? type,
  });
}

/// @nodoc
class __$$IndexSchemaImplCopyWithImpl<$Res>
    extends _$IndexSchemaCopyWithImpl<$Res, _$IndexSchemaImpl>
    implements _$$IndexSchemaImplCopyWith<$Res> {
  __$$IndexSchemaImplCopyWithImpl(
    _$IndexSchemaImpl _value,
    $Res Function(_$IndexSchemaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IndexSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? columns = null,
    Object? unique = null,
    Object? primary = null,
    Object? type = freezed,
  }) {
    return _then(
      _$IndexSchemaImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        columns: null == columns
            ? _value._columns
            : columns // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        unique: null == unique
            ? _value.unique
            : unique // ignore: cast_nullable_to_non_nullable
                  as bool,
        primary: null == primary
            ? _value.primary
            : primary // ignore: cast_nullable_to_non_nullable
                  as bool,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IndexSchemaImpl implements _IndexSchema {
  const _$IndexSchemaImpl({
    required this.name,
    required final List<String> columns,
    this.unique = false,
    this.primary = false,
    this.type,
  }) : _columns = columns;

  factory _$IndexSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndexSchemaImplFromJson(json);

  @override
  final String name;
  final List<String> _columns;
  @override
  List<String> get columns {
    if (_columns is EqualUnmodifiableListView) return _columns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_columns);
  }

  @override
  @JsonKey()
  final bool unique;
  @override
  @JsonKey()
  final bool primary;
  @override
  final String? type;

  @override
  String toString() {
    return 'IndexSchema(name: $name, columns: $columns, unique: $unique, primary: $primary, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexSchemaImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._columns, _columns) &&
            (identical(other.unique, unique) || other.unique == unique) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_columns),
    unique,
    primary,
    type,
  );

  /// Create a copy of IndexSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexSchemaImplCopyWith<_$IndexSchemaImpl> get copyWith =>
      __$$IndexSchemaImplCopyWithImpl<_$IndexSchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndexSchemaImplToJson(this);
  }
}

abstract class _IndexSchema implements IndexSchema {
  const factory _IndexSchema({
    required final String name,
    required final List<String> columns,
    final bool unique,
    final bool primary,
    final String? type,
  }) = _$IndexSchemaImpl;

  factory _IndexSchema.fromJson(Map<String, dynamic> json) =
      _$IndexSchemaImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get columns;
  @override
  bool get unique;
  @override
  bool get primary;
  @override
  String? get type;

  /// Create a copy of IndexSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexSchemaImplCopyWith<_$IndexSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
