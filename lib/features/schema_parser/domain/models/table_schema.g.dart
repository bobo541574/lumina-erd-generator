// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableSchemaImpl _$$TableSchemaImplFromJson(Map<String, dynamic> json) =>
    _$TableSchemaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      columns: (json['columns'] as List<dynamic>)
          .map((e) => ColumnSchema.fromJson(e as Map<String, dynamic>))
          .toList(),
      indexes:
          (json['indexes'] as List<dynamic>?)
              ?.map((e) => IndexSchema.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comment: json['comment'] as String?,
      isPivot: json['isPivot'] as bool? ?? false,
    );

Map<String, dynamic> _$$TableSchemaImplToJson(_$TableSchemaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'columns': instance.columns,
      'indexes': instance.indexes,
      'comment': instance.comment,
      'isPivot': instance.isPivot,
    };

_$IndexSchemaImpl _$$IndexSchemaImplFromJson(Map<String, dynamic> json) =>
    _$IndexSchemaImpl(
      name: json['name'] as String,
      columns: (json['columns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unique: json['unique'] as bool? ?? false,
      primary: json['primary'] as bool? ?? false,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$IndexSchemaImplToJson(_$IndexSchemaImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'columns': instance.columns,
      'unique': instance.unique,
      'primary': instance.primary,
      'type': instance.type,
    };
