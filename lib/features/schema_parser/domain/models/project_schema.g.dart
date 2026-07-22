// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectSchemaImpl _$$ProjectSchemaImplFromJson(Map<String, dynamic> json) =>
    _$ProjectSchemaImpl(
      projectName: json['projectName'] as String,
      tables: (json['tables'] as List<dynamic>)
          .map((e) => TableSchema.fromJson(e as Map<String, dynamic>))
          .toList(),
      relationships:
          (json['relationships'] as List<dynamic>?)
              ?.map(
                (e) => RelationshipSchema.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProjectSchemaImplToJson(_$ProjectSchemaImpl instance) =>
    <String, dynamic>{
      'projectName': instance.projectName,
      'tables': instance.tables,
      'relationships': instance.relationships,
    };
