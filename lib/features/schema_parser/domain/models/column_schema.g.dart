// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ColumnSchemaImpl _$$ColumnSchemaImplFromJson(Map<String, dynamic> json) =>
    _$ColumnSchemaImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      nullable: json['nullable'] as bool? ?? false,
      unique: json['unique'] as bool? ?? false,
      primary: json['primary'] as bool? ?? false,
      defaultValue: json['defaultValue'] as String?,
      length: (json['length'] as num?)?.toInt(),
      unsigned: json['unsigned'] as bool? ?? false,
      autoIncrement: json['autoIncrement'] as bool? ?? false,
      comment: json['comment'] as String?,
      foreignTable: json['foreignTable'] as String?,
      foreignColumn: json['foreignColumn'] as String?,
    );

Map<String, dynamic> _$$ColumnSchemaImplToJson(_$ColumnSchemaImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'nullable': instance.nullable,
      'unique': instance.unique,
      'primary': instance.primary,
      'defaultValue': instance.defaultValue,
      'length': instance.length,
      'unsigned': instance.unsigned,
      'autoIncrement': instance.autoIncrement,
      'comment': instance.comment,
      'foreignTable': instance.foreignTable,
      'foreignColumn': instance.foreignColumn,
    };
