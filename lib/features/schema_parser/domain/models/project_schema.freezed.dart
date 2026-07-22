// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectSchema _$ProjectSchemaFromJson(Map<String, dynamic> json) {
  return _ProjectSchema.fromJson(json);
}

/// @nodoc
mixin _$ProjectSchema {
  String get projectName => throw _privateConstructorUsedError;
  List<TableSchema> get tables => throw _privateConstructorUsedError;
  List<RelationshipSchema> get relationships =>
      throw _privateConstructorUsedError;

  /// Serializes this ProjectSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectSchemaCopyWith<ProjectSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectSchemaCopyWith<$Res> {
  factory $ProjectSchemaCopyWith(
    ProjectSchema value,
    $Res Function(ProjectSchema) then,
  ) = _$ProjectSchemaCopyWithImpl<$Res, ProjectSchema>;
  @useResult
  $Res call({
    String projectName,
    List<TableSchema> tables,
    List<RelationshipSchema> relationships,
  });
}

/// @nodoc
class _$ProjectSchemaCopyWithImpl<$Res, $Val extends ProjectSchema>
    implements $ProjectSchemaCopyWith<$Res> {
  _$ProjectSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectName = null,
    Object? tables = null,
    Object? relationships = null,
  }) {
    return _then(
      _value.copyWith(
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
            tables: null == tables
                ? _value.tables
                : tables // ignore: cast_nullable_to_non_nullable
                      as List<TableSchema>,
            relationships: null == relationships
                ? _value.relationships
                : relationships // ignore: cast_nullable_to_non_nullable
                      as List<RelationshipSchema>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectSchemaImplCopyWith<$Res>
    implements $ProjectSchemaCopyWith<$Res> {
  factory _$$ProjectSchemaImplCopyWith(
    _$ProjectSchemaImpl value,
    $Res Function(_$ProjectSchemaImpl) then,
  ) = __$$ProjectSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectName,
    List<TableSchema> tables,
    List<RelationshipSchema> relationships,
  });
}

/// @nodoc
class __$$ProjectSchemaImplCopyWithImpl<$Res>
    extends _$ProjectSchemaCopyWithImpl<$Res, _$ProjectSchemaImpl>
    implements _$$ProjectSchemaImplCopyWith<$Res> {
  __$$ProjectSchemaImplCopyWithImpl(
    _$ProjectSchemaImpl _value,
    $Res Function(_$ProjectSchemaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectName = null,
    Object? tables = null,
    Object? relationships = null,
  }) {
    return _then(
      _$ProjectSchemaImpl(
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
        tables: null == tables
            ? _value._tables
            : tables // ignore: cast_nullable_to_non_nullable
                  as List<TableSchema>,
        relationships: null == relationships
            ? _value._relationships
            : relationships // ignore: cast_nullable_to_non_nullable
                  as List<RelationshipSchema>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectSchemaImpl extends _ProjectSchema {
  const _$ProjectSchemaImpl({
    required this.projectName,
    required final List<TableSchema> tables,
    final List<RelationshipSchema> relationships = const [],
  }) : _tables = tables,
       _relationships = relationships,
       super._();

  factory _$ProjectSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectSchemaImplFromJson(json);

  @override
  final String projectName;
  final List<TableSchema> _tables;
  @override
  List<TableSchema> get tables {
    if (_tables is EqualUnmodifiableListView) return _tables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tables);
  }

  final List<RelationshipSchema> _relationships;
  @override
  @JsonKey()
  List<RelationshipSchema> get relationships {
    if (_relationships is EqualUnmodifiableListView) return _relationships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relationships);
  }

  @override
  String toString() {
    return 'ProjectSchema(projectName: $projectName, tables: $tables, relationships: $relationships)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectSchemaImpl &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality().equals(other._tables, _tables) &&
            const DeepCollectionEquality().equals(
              other._relationships,
              _relationships,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectName,
    const DeepCollectionEquality().hash(_tables),
    const DeepCollectionEquality().hash(_relationships),
  );

  /// Create a copy of ProjectSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectSchemaImplCopyWith<_$ProjectSchemaImpl> get copyWith =>
      __$$ProjectSchemaImplCopyWithImpl<_$ProjectSchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectSchemaImplToJson(this);
  }
}

abstract class _ProjectSchema extends ProjectSchema {
  const factory _ProjectSchema({
    required final String projectName,
    required final List<TableSchema> tables,
    final List<RelationshipSchema> relationships,
  }) = _$ProjectSchemaImpl;
  const _ProjectSchema._() : super._();

  factory _ProjectSchema.fromJson(Map<String, dynamic> json) =
      _$ProjectSchemaImpl.fromJson;

  @override
  String get projectName;
  @override
  List<TableSchema> get tables;
  @override
  List<RelationshipSchema> get relationships;

  /// Create a copy of ProjectSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectSchemaImplCopyWith<_$ProjectSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
