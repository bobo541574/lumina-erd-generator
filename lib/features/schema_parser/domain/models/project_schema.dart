import 'package:freezed_annotation/freezed_annotation.dart';
import 'table_schema.dart';
import 'relationship_schema.dart';

part 'project_schema.freezed.dart';
part 'project_schema.g.dart';

@freezed
class ProjectSchema with _$ProjectSchema {
  const ProjectSchema._();

  const factory ProjectSchema({
    required String projectName,
    required List<TableSchema> tables,
    @Default([]) List<RelationshipSchema> relationships,
  }) = _ProjectSchema;

  factory ProjectSchema.fromJson(Map<String, dynamic> json) =>
      _$ProjectSchemaFromJson(json);

  TableSchema? getTableByName(String name) {
    for (final table in tables) {
      if (table.name == name) return table;
    }
    return null;
  }

  List<RelationshipSchema> getRelationshipsForTable(String tableName) {
    return relationships
        .where((r) => r.sourceTable == tableName || r.targetTable == tableName)
        .toList();
  }

  List<RelationshipSchema> get relationshipsFromMigrations =>
      relationships.where((r) => r.isFromMigration).toList();

  List<RelationshipSchema> get relationshipsFromModels =>
      relationships.where((r) => r.isInferred).toList();

  bool get hasExplicitForeignKeys => relationshipsFromMigrations.isNotEmpty;

  bool get needsModelParsing => !hasExplicitForeignKeys;

  int get totalColumns => tables.fold(0, (sum, t) => sum + t.columns.length);

  String get summary => '${tables.length} tables, '
      '$totalColumns columns, '
      '${relationships.length} relationships';

  bool get hasPivotTables => tables.any((t) => t.isPivot);
}
