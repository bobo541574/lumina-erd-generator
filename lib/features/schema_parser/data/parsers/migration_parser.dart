import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../domain/models/column_schema.dart';
import '../../domain/models/table_schema.dart';
import '../../domain/models/relationship_schema.dart';
import '../../domain/models/project_schema.dart';

class MigrationParser {
  static const _uuid = Uuid();

  static String _q(String inner) => "['\"]$inner['\"]";
  static String _optQ(String inner) => "['\"]?$inner['\"]?";

  static RegExp _re(String pattern) => RegExp(pattern, multiLine: true);

  static final _schemaCreateRegex = _re(
    "Schema::create\\(\\s*" + _q("(\\w+)"),
  );

  static final _schemaTableRegex = _re(
    "Schema::table\\(\\s*" + _q("(\\w+)"),
  );

  static final _idColumnRegex = _re(r'\$table->id\(\)');

  static final _bigIncrementsRegex = _re(
    r'\$table->bigIncrements\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _incrementsRegex = _re(
    r'\$table->increments\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _uuidColumnRegex = _re(
    r'\$table->uuid\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _columnRegex = _re(
    r'\$table->(\w+)\(\s*' + _q(r'(\w+)') + r'\s*(?:,\s*(\d+))?\s*\)',
  );

  static final _nullableRegex = RegExp(r'->nullable\(');
  static final _uniqueRegex = RegExp(r'->unique\(');
  static final _primaryRegex = RegExp(r'->primary\(');
  static final _unsignedRegex = RegExp(r'->unsigned\(');

  static final _defaultRegex = _re(
    r"->default\(\s*" + _q('?(.+?)') + r'?\s*\)',
  );

  static final _commentRegex = _re(
    r"->comment\(\s*" + _q('(.+?)') + r'\s*\)',
  );

  static final _foreignIdConstrainedRegex = _re(
    r'\$table->foreignId\(\s*' + _q(r'(\w+)') + r"""\s*\)->constrained\(""" + _optQ(r'(\w*)') + r"""\s*\)""",
  );

  static final _foreignIdRegex = _re(
    r'\$table->foreignId\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _foreignRegex = _re(
    r'\$table->foreign\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _referencesRegex = _re(
    r'->references\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _onRegex = _re(
    r'->on\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _timestampsRegex = _re(r'\$table->timestamps\(\)');
  static final _softDeletesRegex = _re(r'\$table->softDeletes\(');

  static final _morphsRegex = _re(
    r'\$table->morphs\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _booleanRegex = _re(
    r'\$table->boolean\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _unsignedBigIntegerRegex = _re(
    r'\$table->unsignedBigInteger\(\s*' + _q(r'(\w+)') + r'\s*\)',
  );

  static final _indexRegex = _re(
    r'\$table->index\(\s*\[(.+?)\]\s*(?:,\s*' + _q(r'(\w+)') + r'\s*)?\)',
  );

  static final _uniqueIndexRegex = _re(
    r'\$table->unique\(\s*\[(.+?)\]\s*(?:,\s*' + _q(r'(\w+)') + r'\s*)?\)',
  );

  static ProjectSchema parse(String projectPath, {String? projectName}) {
    final migrationsDir = Directory('$projectPath/database/migrations');
    if (!migrationsDir.existsSync()) {
      return ProjectSchema(
        projectName: projectName ?? _extractProjectName(projectPath),
        tables: [],
      );
    }

    final phpFiles = migrationsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.php'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    final tableColumns = <String, List<ColumnSchema>>{};
    final tableIndexes = <String, List<IndexSchema>>{};
    final relationships = <RelationshipSchema>[];
    final alterStatements = <String, List<String>>{};

    for (final file in phpFiles) {
      try {
        final content = file.readAsStringSync();
        _parseMigrationFile(
          content, tableColumns, tableIndexes, relationships, alterStatements,
        );
      } catch (e) {
        // Skip malformed files silently
      }
    }

    _processAlterStatements(alterStatements, tableColumns, relationships);

    final tables = <TableSchema>[];
    for (final entry in tableColumns.entries) {
      final cols = entry.value;
      final idxs = tableIndexes[entry.key] ?? [];
      if (cols.isEmpty) continue;

      final hasId = cols.any((c) => c.name == 'id');
      if (!hasId && !cols.any((c) => c.primary) && !entry.key.contains('pivot')) {
        cols.insert(0, const ColumnSchema(
          name: 'id', type: 'bigIncrements', primary: true, autoIncrement: true,
        ));
      }

      tables.add(TableSchema(
        id: _uuid.v4(), name: entry.key, columns: cols, indexes: idxs,
        isPivot: _isPivotTable(entry.key, cols),
      ));
    }

    return ProjectSchema(
      projectName: projectName ?? _extractProjectName(projectPath),
      tables: tables,
      relationships: _resolveRelationships(relationships, tables, tableColumns),
    );
  }

  static void _parseMigrationFile(
    String content,
    Map<String, List<ColumnSchema>> tableColumns,
    Map<String, List<IndexSchema>> tableIndexes,
    List<RelationshipSchema> relationships,
    Map<String, List<String>> alterStatements,
  ) {
    final createMatch = _schemaCreateRegex.firstMatch(content);
    final tableMatch = _schemaTableRegex.firstMatch(content);

    if (createMatch != null) {
      final tableName = createMatch.group(1)!;
      final columns = _parseColumnDefinitions(content, relationships);
      tableColumns.putIfAbsent(tableName, () => []).addAll(columns);
      final indexes = _parseIndexes(content);
      if (indexes.isNotEmpty) tableIndexes[tableName] = indexes;
    } else if (tableMatch != null) {
      alterStatements.putIfAbsent(tableMatch.group(1)!, () => []).add(content);
    }
  }

  static List<ColumnSchema> _parseColumnDefinitions(
    String content, List<RelationshipSchema> relationships,
  ) {
    final columns = <ColumnSchema>[];

    if (_idColumnRegex.hasMatch(content)) {
      columns.add(const ColumnSchema(
        name: 'id', type: 'bigIncrements', primary: true, autoIncrement: true,
      ));
    }

    for (final m in _bigIncrementsRegex.allMatches(content)) {
      columns.add(ColumnSchema(
        name: m.group(1)!, type: 'bigIncrements', primary: true, autoIncrement: true,
      ));
    }

    for (final m in _incrementsRegex.allMatches(content)) {
      columns.add(ColumnSchema(
        name: m.group(1)!, type: 'increments', primary: true, autoIncrement: true,
      ));
    }

    for (final m in _uuidColumnRegex.allMatches(content)) {
      columns.add(ColumnSchema(name: m.group(1)!, type: 'uuid', primary: m.group(1) == 'id'));
    }

    for (final m in _columnRegex.allMatches(content)) {
      final type = m.group(1)!;
      final name = m.group(2)!;
      if (columns.any((c) => c.name == name)) continue;
      final lengthStr = m.group(3);
      final line = content.substring(m.start, _findLineEnd(content, m.end));

      columns.add(ColumnSchema(
        name: name,
        type: _mapColumnType(type),
        nullable: _nullableRegex.hasMatch(line),
        unique: _uniqueRegex.hasMatch(line),
        primary: _primaryRegex.hasMatch(line),
        defaultValue: _defaultRegex.firstMatch(line)?.group(1),
        length: lengthStr != null ? int.tryParse(lengthStr) : null,
        unsigned: _unsignedRegex.hasMatch(line),
        autoIncrement: line.contains('autoIncrement()'),
        comment: _commentRegex.firstMatch(line)?.group(1),
      ));
    }

    for (final m in _booleanRegex.allMatches(content)) {
      final name = m.group(1)!;
      if (!columns.any((c) => c.name == name)) {
        columns.add(ColumnSchema(name: name, type: 'boolean'));
      }
    }

    for (final m in _unsignedBigIntegerRegex.allMatches(content)) {
      final name = m.group(1)!;
      if (!columns.any((c) => c.name == name)) {
        columns.add(ColumnSchema(name: name, type: 'bigInteger', unsigned: true));
      }
    }

    if (_timestampsRegex.hasMatch(content)) {
      columns.add(const ColumnSchema(name: 'created_at', type: 'timestamp', nullable: true));
      columns.add(const ColumnSchema(name: 'updated_at', type: 'timestamp', nullable: true));
    }

    if (_softDeletesRegex.hasMatch(content)) {
      columns.add(const ColumnSchema(name: 'deleted_at', type: 'timestamp', nullable: true));
    }

    for (final m in _morphsRegex.allMatches(content)) {
      final name = m.group(1)!;
      final typeCol = '${name}_type';
      final idCol = '${name}_id';
      if (!columns.any((c) => c.name == typeCol)) {
        columns.add(ColumnSchema(name: typeCol, type: 'string'));
      }
      if (!columns.any((c) => c.name == idCol)) {
        columns.add(ColumnSchema(name: idCol, type: 'bigInteger', unsigned: true));
      }
    }

    for (final m in _foreignIdConstrainedRegex.allMatches(content)) {
      final colName = m.group(1)!;
      final targetTable = m.group(2)!.isNotEmpty ? m.group(2)! : colName.replaceAll('_id', '');
      if (!columns.any((c) => c.name == colName)) {
        columns.add(ColumnSchema(name: colName, type: 'bigInteger', unsigned: true));
      }
      relationships.add(RelationshipSchema(
        type: RelationshipType.belongsTo, sourceTable: '', targetTable: targetTable,
        foreignKey: colName, localKey: 'id',
      ));
    }

    for (final m in _foreignIdRegex.allMatches(content)) {
      final colName = m.group(1)!;
      final line = content.substring(m.start, _findLineEnd(content, m.end));
      if (line.contains('->constrained()') || line.contains('->constrained(')) continue;
      if (!columns.any((c) => c.name == colName)) {
        columns.add(ColumnSchema(name: colName, type: 'bigInteger', unsigned: true));
      }
    }

    for (final m in _foreignRegex.allMatches(content)) {
      final fkCol = m.group(1)!;
      final line = content.substring(m.start, _findLineEnd(content, m.end));
      final refMatch = _referencesRegex.firstMatch(line);
      final onMatch = _onRegex.firstMatch(line);
      if (refMatch != null && onMatch != null) {
        relationships.add(RelationshipSchema(
          type: RelationshipType.belongsTo, sourceTable: '',
          targetTable: onMatch.group(1)!, foreignKey: fkCol, localKey: refMatch.group(1)!,
        ));
      }
    }

    return columns;
  }

  static int _findLineEnd(String content, int start) {
    var end = start;
    while (end < content.length && content[end] != ';' && content[end] != '\n') end++;
    return end;
  }

  static String _mapColumnType(String type) {
    const map = {
      'id': 'bigIncrements', 'bigincrements': 'bigIncrements', 'increments': 'increments',
      'string': 'string', 'varchar': 'string', 'text': 'text', 'longtext': 'longText',
      'mediumtext': 'mediumText', 'integer': 'integer', 'int': 'integer',
      'biginteger': 'bigInteger', 'bigint': 'bigInteger', 'smallinteger': 'smallInteger',
      'smallint': 'smallInteger', 'tinyinteger': 'tinyInteger', 'tinyint': 'tinyInteger',
      'boolean': 'boolean', 'date': 'date', 'datetime': 'datetime', 'timestamp': 'timestamp',
      'json': 'json', 'enum': 'enum', 'float': 'float', 'double': 'double',
      'decimal': 'decimal', 'binary': 'binary', 'uuid': 'uuid', 'char': 'char',
    };
    return map[type.toLowerCase()] ?? type;
  }

  static List<IndexSchema> _parseIndexes(String content) {
    final indexes = <IndexSchema>[];
    for (final m in _indexRegex.allMatches(content)) {
      final cols = m.group(1)!.replaceAll("'", '').replaceAll('"', '')
          .split(',').map((s) => s.trim()).toList();
      indexes.add(IndexSchema(name: m.group(2) ?? 'idx_${cols.join("_")}', columns: cols));
    }
    for (final m in _uniqueIndexRegex.allMatches(content)) {
      final cols = m.group(1)!.replaceAll("'", '').replaceAll('"', '')
          .split(',').map((s) => s.trim()).toList();
      indexes.add(IndexSchema(name: m.group(2) ?? 'uniq_${cols.join("_")}', columns: cols, unique: true));
    }
    return indexes;
  }

  static void _processAlterStatements(
    Map<String, List<String>> alterStatements,
    Map<String, List<ColumnSchema>> tableColumns,
    List<RelationshipSchema> relationships,
  ) {
    for (final entry in alterStatements.entries) {
      final tableName = entry.key;
      for (final content in entry.value) {
        for (final m in _foreignRegex.allMatches(content)) {
          final fkCol = m.group(1)!;
          final line = content.substring(m.start, _findLineEnd(content, m.end));
          final refMatch = _referencesRegex.firstMatch(line);
          final onMatch = _onRegex.firstMatch(line);
          if (refMatch != null && onMatch != null) {
            relationships.add(RelationshipSchema(
              type: RelationshipType.belongsTo, sourceTable: tableName,
              targetTable: onMatch.group(1)!, foreignKey: fkCol, localKey: refMatch.group(1)!,
            ));
          }
        }
        for (final m in _foreignIdConstrainedRegex.allMatches(content)) {
          final colName = m.group(1)!;
          final targetTable = m.group(2)!.isNotEmpty ? m.group(2)! : colName.replaceAll('_id', '');
          final existing = tableColumns[tableName];
          if (existing != null && !existing.any((c) => c.name == colName)) {
            existing.add(ColumnSchema(name: colName, type: 'bigInteger', unsigned: true));
          }
          relationships.add(RelationshipSchema(
            type: RelationshipType.belongsTo, sourceTable: tableName,
            targetTable: targetTable, foreignKey: colName, localKey: 'id',
          ));
        }
      }
    }
  }

  static bool _isPivotTable(String tableName, List<ColumnSchema> columns) {
    final looksLikePivot = tableName.contains('_') &&
        tableName.split('_').length == 2 &&
        columns.length <= 5 &&
        columns.any((c) => c.name.endsWith('_id'));
    final hasOnlyFksAndTimestamps = columns.every(
      (c) => c.name.endsWith('_id') || c.name == 'created_at' || c.name == 'updated_at' || c.name == 'id',
    );
    return looksLikePivot || hasOnlyFksAndTimestamps;
  }

  static List<RelationshipSchema> _resolveRelationships(
    List<RelationshipSchema> rawRelationships,
    List<TableSchema> tables,
    Map<String, List<ColumnSchema>> tableColumns,
  ) {
    final resolved = <RelationshipSchema>[];
    final tableNames = tables.map((t) => t.name).toSet();

    for (final rel in rawRelationships) {
      final source = rel.sourceTable.isNotEmpty
          ? rel.sourceTable
          : _inferSourceTable(rel, tableColumns, tableNames);
      if (source == null || !tableNames.contains(source)) continue;
      if (!tableNames.contains(rel.targetTable)) continue;
      resolved.add(rel.copyWith(sourceTable: source));
    }

    for (final table in tables) {
      final cols = tableColumns[table.name] ?? [];
      for (final col in cols) {
        if (col.name.endsWith('_id') && !col.isForeignKey) {
          final targetName = col.name.replaceAll('_id', '');
          final targetTable = _findMatchingTable(targetName, tableNames);
          if (targetTable != null && targetTable != table.name) {
            final alreadyHas = resolved.any((r) =>
                r.sourceTable == table.name && r.targetTable == targetTable && r.foreignKey == col.name);
            if (!alreadyHas) {
              resolved.add(RelationshipSchema(
                type: RelationshipType.belongsTo, sourceTable: table.name,
                targetTable: targetTable, foreignKey: col.name, localKey: 'id', isInferred: true,
              ));
            }
          }
        }
      }
    }

    final pivotTables = tables.where((t) => t.isPivot).toList();
    for (final pivot in pivotTables) {
      final fkCols = pivot.columns.where((c) => c.name.endsWith('_id')).toList();
      if (fkCols.length >= 2) {
        for (var i = 0; i < fkCols.length; i++) {
          for (var j = i + 1; j < fkCols.length; j++) {
            final t1 = _findMatchingTable(fkCols[i].name.replaceAll('_id', ''), tableNames);
            final t2 = _findMatchingTable(fkCols[j].name.replaceAll('_id', ''), tableNames);
            if (t1 != null && t2 != null) {
              final exists = resolved.any((r) =>
                  r.type == RelationshipType.belongsToMany &&
                  ((r.sourceTable == t1 && r.targetTable == t2) || (r.sourceTable == t2 && r.targetTable == t1)));
              if (!exists) {
                resolved.add(RelationshipSchema(
                  type: RelationshipType.belongsToMany, sourceTable: t1, targetTable: t2,
                  pivotTable: pivot.name, foreignKey: fkCols[0].name, localKey: 'id',
                ));
              }
            }
          }
        }
      }
    }

    return resolved;
  }

  static String? _inferSourceTable(
    RelationshipSchema rel, Map<String, List<ColumnSchema>> tableColumns, Set<String> tableNames,
  ) {
    for (final entry in tableColumns.entries) {
      if (entry.value.any((c) => c.name == rel.foreignKey)) return entry.key;
    }
    if (rel.foreignKey != null) {
      final prefix = rel.foreignKey!.replaceAll('_id', '');
      final tableName = _findMatchingTable(prefix, tableNames);
      if (tableName != null) return tableName;
    }
    return null;
  }

  static String? _findMatchingTable(String name, Set<String> tableNames) {
    if (tableNames.contains(name)) return name;
    if (tableNames.contains('${name}s')) return '${name}s';
    if (tableNames.contains('${name}es')) return '${name}es';
    final ies = '${name.substring(0, name.length - 1)}ies';
    if (tableNames.contains(ies)) return ies;
    for (final t in tableNames) {
      if (t.startsWith(name) || name.startsWith(t)) return t;
    }
    return null;
  }

  static String _extractProjectName(String path) {
    final segments = path.split(Platform.pathSeparator);
    return segments.isNotEmpty ? segments.last : 'Unknown Project';
  }
}
