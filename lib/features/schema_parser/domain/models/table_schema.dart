import 'package:freezed_annotation/freezed_annotation.dart';
import 'column_schema.dart';

part 'table_schema.freezed.dart';
part 'table_schema.g.dart';

@freezed
class TableSchema with _$TableSchema {
  const TableSchema._();

  const factory TableSchema({
    required String id,
    required String name,
    required List<ColumnSchema> columns,
    @Default([]) List<IndexSchema> indexes,
    String? comment,
    @Default(false) bool isPivot,
  }) = _TableSchema;

  factory TableSchema.fromJson(Map<String, dynamic> json) =>
      _$TableSchemaFromJson(json);

  List<ColumnSchema> get primaryKeys =>
      columns.where((c) => c.isPrimaryKey).toList();

  List<ColumnSchema> get foreignKeys =>
      columns.where((c) => c.isForeignKey).toList();

  List<ColumnSchema> get requiredColumns =>
      columns.where((c) => !c.nullable && !c.isPrimaryKey).toList();

  bool get hasTimestamps =>
      columns.any((c) => c.name == 'created_at') ||
      columns.any((c) => c.name == 'updated_at');

  bool get hasSoftDeletes =>
      columns.any((c) => c.name == 'deleted_at');

  ColumnSchema? get columnByName {
    // This getter is not functional - use getColumnByName method instead
    return null;
  }

  ColumnSchema? getColumnByName(String name) {
    for (final col in columns) {
      if (col.name == name) return col;
    }
    return null;
  }

  bool hasColumn(String name) => getColumnByName(name) != null;

  bool hasIndex(String indexName) =>
      indexes.any((i) => i.name == indexName);

  List<String> get tableConstraints {
    final c = <String>[];
    if (primaryKeys.isNotEmpty) c.add('PK');
    if (foreignKeys.isNotEmpty) c.add('FK(${foreignKeys.length})');
    if (isPivot) c.add('PIVOT');
    return c;
  }
}

@freezed
class IndexSchema with _$IndexSchema {
  const factory IndexSchema({
    required String name,
    required List<String> columns,
    @Default(false) bool unique,
    @Default(false) bool primary,
    String? type,
  }) = _IndexSchema;

  factory IndexSchema.fromJson(Map<String, dynamic> json) =>
      _$IndexSchemaFromJson(json);
}
