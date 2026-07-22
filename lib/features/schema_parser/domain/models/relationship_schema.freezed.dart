// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RelationshipSchema _$RelationshipSchemaFromJson(Map<String, dynamic> json) {
  return _RelationshipSchema.fromJson(json);
}

/// @nodoc
mixin _$RelationshipSchema {
  RelationshipType get type => throw _privateConstructorUsedError;
  String get sourceTable => throw _privateConstructorUsedError;
  String get targetTable => throw _privateConstructorUsedError;
  String? get foreignKey => throw _privateConstructorUsedError;
  String? get localKey => throw _privateConstructorUsedError;
  String? get pivotTable => throw _privateConstructorUsedError;
  bool get isInferred => throw _privateConstructorUsedError;
  String? get methodName => throw _privateConstructorUsedError;

  /// Serializes this RelationshipSchema to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RelationshipSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RelationshipSchemaCopyWith<RelationshipSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipSchemaCopyWith<$Res> {
  factory $RelationshipSchemaCopyWith(
    RelationshipSchema value,
    $Res Function(RelationshipSchema) then,
  ) = _$RelationshipSchemaCopyWithImpl<$Res, RelationshipSchema>;
  @useResult
  $Res call({
    RelationshipType type,
    String sourceTable,
    String targetTable,
    String? foreignKey,
    String? localKey,
    String? pivotTable,
    bool isInferred,
    String? methodName,
  });
}

/// @nodoc
class _$RelationshipSchemaCopyWithImpl<$Res, $Val extends RelationshipSchema>
    implements $RelationshipSchemaCopyWith<$Res> {
  _$RelationshipSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RelationshipSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? sourceTable = null,
    Object? targetTable = null,
    Object? foreignKey = freezed,
    Object? localKey = freezed,
    Object? pivotTable = freezed,
    Object? isInferred = null,
    Object? methodName = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RelationshipType,
            sourceTable: null == sourceTable
                ? _value.sourceTable
                : sourceTable // ignore: cast_nullable_to_non_nullable
                      as String,
            targetTable: null == targetTable
                ? _value.targetTable
                : targetTable // ignore: cast_nullable_to_non_nullable
                      as String,
            foreignKey: freezed == foreignKey
                ? _value.foreignKey
                : foreignKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            localKey: freezed == localKey
                ? _value.localKey
                : localKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            pivotTable: freezed == pivotTable
                ? _value.pivotTable
                : pivotTable // ignore: cast_nullable_to_non_nullable
                      as String?,
            isInferred: null == isInferred
                ? _value.isInferred
                : isInferred // ignore: cast_nullable_to_non_nullable
                      as bool,
            methodName: freezed == methodName
                ? _value.methodName
                : methodName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RelationshipSchemaImplCopyWith<$Res>
    implements $RelationshipSchemaCopyWith<$Res> {
  factory _$$RelationshipSchemaImplCopyWith(
    _$RelationshipSchemaImpl value,
    $Res Function(_$RelationshipSchemaImpl) then,
  ) = __$$RelationshipSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RelationshipType type,
    String sourceTable,
    String targetTable,
    String? foreignKey,
    String? localKey,
    String? pivotTable,
    bool isInferred,
    String? methodName,
  });
}

/// @nodoc
class __$$RelationshipSchemaImplCopyWithImpl<$Res>
    extends _$RelationshipSchemaCopyWithImpl<$Res, _$RelationshipSchemaImpl>
    implements _$$RelationshipSchemaImplCopyWith<$Res> {
  __$$RelationshipSchemaImplCopyWithImpl(
    _$RelationshipSchemaImpl _value,
    $Res Function(_$RelationshipSchemaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RelationshipSchema
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? sourceTable = null,
    Object? targetTable = null,
    Object? foreignKey = freezed,
    Object? localKey = freezed,
    Object? pivotTable = freezed,
    Object? isInferred = null,
    Object? methodName = freezed,
  }) {
    return _then(
      _$RelationshipSchemaImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RelationshipType,
        sourceTable: null == sourceTable
            ? _value.sourceTable
            : sourceTable // ignore: cast_nullable_to_non_nullable
                  as String,
        targetTable: null == targetTable
            ? _value.targetTable
            : targetTable // ignore: cast_nullable_to_non_nullable
                  as String,
        foreignKey: freezed == foreignKey
            ? _value.foreignKey
            : foreignKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        localKey: freezed == localKey
            ? _value.localKey
            : localKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        pivotTable: freezed == pivotTable
            ? _value.pivotTable
            : pivotTable // ignore: cast_nullable_to_non_nullable
                  as String?,
        isInferred: null == isInferred
            ? _value.isInferred
            : isInferred // ignore: cast_nullable_to_non_nullable
                  as bool,
        methodName: freezed == methodName
            ? _value.methodName
            : methodName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipSchemaImpl extends _RelationshipSchema {
  const _$RelationshipSchemaImpl({
    required this.type,
    required this.sourceTable,
    required this.targetTable,
    this.foreignKey,
    this.localKey,
    this.pivotTable,
    this.isInferred = false,
    this.methodName,
  }) : super._();

  factory _$RelationshipSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipSchemaImplFromJson(json);

  @override
  final RelationshipType type;
  @override
  final String sourceTable;
  @override
  final String targetTable;
  @override
  final String? foreignKey;
  @override
  final String? localKey;
  @override
  final String? pivotTable;
  @override
  @JsonKey()
  final bool isInferred;
  @override
  final String? methodName;

  @override
  String toString() {
    return 'RelationshipSchema(type: $type, sourceTable: $sourceTable, targetTable: $targetTable, foreignKey: $foreignKey, localKey: $localKey, pivotTable: $pivotTable, isInferred: $isInferred, methodName: $methodName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipSchemaImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.sourceTable, sourceTable) ||
                other.sourceTable == sourceTable) &&
            (identical(other.targetTable, targetTable) ||
                other.targetTable == targetTable) &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey) &&
            (identical(other.localKey, localKey) ||
                other.localKey == localKey) &&
            (identical(other.pivotTable, pivotTable) ||
                other.pivotTable == pivotTable) &&
            (identical(other.isInferred, isInferred) ||
                other.isInferred == isInferred) &&
            (identical(other.methodName, methodName) ||
                other.methodName == methodName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    sourceTable,
    targetTable,
    foreignKey,
    localKey,
    pivotTable,
    isInferred,
    methodName,
  );

  /// Create a copy of RelationshipSchema
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipSchemaImplCopyWith<_$RelationshipSchemaImpl> get copyWith =>
      __$$RelationshipSchemaImplCopyWithImpl<_$RelationshipSchemaImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipSchemaImplToJson(this);
  }
}

abstract class _RelationshipSchema extends RelationshipSchema {
  const factory _RelationshipSchema({
    required final RelationshipType type,
    required final String sourceTable,
    required final String targetTable,
    final String? foreignKey,
    final String? localKey,
    final String? pivotTable,
    final bool isInferred,
    final String? methodName,
  }) = _$RelationshipSchemaImpl;
  const _RelationshipSchema._() : super._();

  factory _RelationshipSchema.fromJson(Map<String, dynamic> json) =
      _$RelationshipSchemaImpl.fromJson;

  @override
  RelationshipType get type;
  @override
  String get sourceTable;
  @override
  String get targetTable;
  @override
  String? get foreignKey;
  @override
  String? get localKey;
  @override
  String? get pivotTable;
  @override
  bool get isInferred;
  @override
  String? get methodName;

  /// Create a copy of RelationshipSchema
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RelationshipSchemaImplCopyWith<_$RelationshipSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
