import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_schema.freezed.dart';
part 'relationship_schema.g.dart';

enum RelationshipType {
  belongsTo,
  hasMany,
  hasOne,
  belongsToMany;

  String get displayName {
    switch (this) {
      case RelationshipType.belongsTo:
        return 'Belongs To';
      case RelationshipType.hasMany:
        return 'Has Many';
      case RelationshipType.hasOne:
        return 'Has One';
      case RelationshipType.belongsToMany:
        return 'Belongs To Many';
    }
  }

  String get notation {
    switch (this) {
      case RelationshipType.belongsTo:
        return '<|--';
      case RelationshipType.hasMany:
        return '||--o{';
      case RelationshipType.hasOne:
        return '||--||';
      case RelationshipType.belongsToMany:
        return '}o--o{';
    }
  }
}

@freezed
class RelationshipSchema with _$RelationshipSchema {
  const RelationshipSchema._();

  const factory RelationshipSchema({
    required RelationshipType type,
    required String sourceTable,
    required String targetTable,
    String? foreignKey,
    String? localKey,
    String? pivotTable,
    @Default(false) bool isInferred,
    String? methodName,
  }) = _RelationshipSchema;

  factory RelationshipSchema.fromJson(Map<String, dynamic> json) =>
      _$RelationshipSchemaFromJson(json);

  bool get isFromMigration => !isInferred;

  bool get hasPivot => pivotTable != null;

  String get sourceForeignKey =>
      foreignKey ?? '${sourceTable.replaceAll(RegExp(r's$'), '')}_id';

  String get targetLocalKey => localKey ?? 'id';

  String get description {
    switch (type) {
      case RelationshipType.belongsTo:
        return '$sourceTable belongs to $targetTable';
      case RelationshipType.hasMany:
        return '$sourceTable has many $targetTable';
      case RelationshipType.hasOne:
        return '$sourceTable has one $targetTable';
      case RelationshipType.belongsToMany:
        return '$sourceTable belongs to many $targetTable (pivot: $pivotTable)';
    }
  }
}
