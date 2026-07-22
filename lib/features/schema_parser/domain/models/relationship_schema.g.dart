// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipSchemaImpl _$$RelationshipSchemaImplFromJson(
  Map<String, dynamic> json,
) => _$RelationshipSchemaImpl(
  type: $enumDecode(_$RelationshipTypeEnumMap, json['type']),
  sourceTable: json['sourceTable'] as String,
  targetTable: json['targetTable'] as String,
  foreignKey: json['foreignKey'] as String?,
  localKey: json['localKey'] as String?,
  pivotTable: json['pivotTable'] as String?,
  isInferred: json['isInferred'] as bool? ?? false,
  methodName: json['methodName'] as String?,
);

Map<String, dynamic> _$$RelationshipSchemaImplToJson(
  _$RelationshipSchemaImpl instance,
) => <String, dynamic>{
  'type': _$RelationshipTypeEnumMap[instance.type]!,
  'sourceTable': instance.sourceTable,
  'targetTable': instance.targetTable,
  'foreignKey': instance.foreignKey,
  'localKey': instance.localKey,
  'pivotTable': instance.pivotTable,
  'isInferred': instance.isInferred,
  'methodName': instance.methodName,
};

const _$RelationshipTypeEnumMap = {
  RelationshipType.belongsTo: 'belongsTo',
  RelationshipType.hasMany: 'hasMany',
  RelationshipType.hasOne: 'hasOne',
  RelationshipType.belongsToMany: 'belongsToMany',
};
