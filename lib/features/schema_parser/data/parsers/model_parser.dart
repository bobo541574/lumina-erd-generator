import 'dart:io';
import '../../domain/models/relationship_schema.dart';
import '../../domain/models/table_schema.dart';

class ModelParser {
  static String _q(String inner) => "['\"]$inner['\"]";

  static RegExp _re(String pattern) => RegExp(pattern, multiLine: true);

  static final _classRegex = _re(r'class\s+(\w+)\s+extends\s+Model');

  static final _tablePropertyRegex = _re(
    r'protected\s+\??string\s+\$table\s*=\s*' + _q(r'(\w+)'),
  );

  static final _belongsToWithParamsRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->belongsTo\(\s*(\w+)::class\s*,\s*' +
        _q(r'(\w+)') +
        r'(?:\s*,\s*' +
        _q(r'(\w+)') +
        r')?\s*\)',
  );

  static final _belongsToRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->belongsTo\(\s*(\w+)::class',
  );

  static final _hasManyWithParamsRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->hasMany\(\s*(\w+)::class\s*,\s*' +
        _q(r'(\w+)') +
        r'(?:\s*,\s*' +
        _q(r'(\w+)') +
        r')?\s*\)',
  );

  static final _hasManyRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->hasMany\(\s*(\w+)::class',
  );

  static final _hasOneWithParamsRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->hasOne\(\s*(\w+)::class\s*,\s*' +
        _q(r'(\w+)') +
        r'(?:\s*,\s*' +
        _q(r'(\w+)') +
        r')?\s*\)',
  );

  static final _hasOneRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->hasOne\(\s*(\w+)::class',
  );

  static final _belongsToManyWithParamsRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->belongsToMany\(\s*(\w+)::class\s*(?:,\s*' +
        _q(r'(\w+)') +
        r'(?:\s*,\s*' +
        _q(r'(\w+)') +
        r'(?:\s*,\s*' +
        _q(r'(\w+)') +
        r')?)?)?\s*\)',
  );

  static final _belongsToManyRegex = _re(
    r'public\s+function\s+(\w+)\s*\(\s*\)\s*\{[^}]*?return\s+\$this->belongsToMany\(\s*(\w+)::class',
  );

  static List<RelationshipSchema> parse(
    String projectPath, {
    required List<TableSchema> tables,
    Map<String, String>? modelToTableMap,
  }) {
    final modelsDir = Directory('$projectPath/app/Models');
    if (!modelsDir.existsSync()) return [];

    final phpFiles = modelsDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.php'))
        .toList();

    final relationships = <RelationshipSchema>[];
    final tableNames = tables.map((t) => t.name).toSet();
    final tableMap = <String, String>{};

    for (final table in tables) {
      tableMap[table.name] = table.name;
    }

    if (modelToTableMap != null) {
      for (final entry in modelToTableMap.entries) {
        tableMap[entry.key] = entry.value;
      }
    }

    for (final file in phpFiles) {
      try {
        final content = file.readAsStringSync();
        relationships.addAll(_parseModelFile(content, tableNames, tableMap));
      } catch (e) {
        // Skip malformed files
      }
    }

    return relationships;
  }

  static List<RelationshipSchema> _parseModelFile(
    String content,
    Set<String> tableNames,
    Map<String, String> modelToTableMap,
  ) {
    final relationships = <RelationshipSchema>[];

    final classMatch = _classRegex.firstMatch(content);
    if (classMatch == null) return [];
    final modelName = classMatch.group(1)!;

    String? customTable;
    final tableMatch = _tablePropertyRegex.firstMatch(content);
    if (tableMatch != null) customTable = tableMatch.group(1);

    final sourceTable =
        customTable ??
        modelToTableMap[modelName] ??
        _modelToTableName(modelName);

    _parseBelongsTo(
      content,
      sourceTable,
      modelName,
      tableNames,
      modelToTableMap,
      relationships,
    );
    _parseHasMany(
      content,
      sourceTable,
      modelName,
      tableNames,
      modelToTableMap,
      relationships,
    );
    _parseHasOne(
      content,
      sourceTable,
      modelName,
      tableNames,
      modelToTableMap,
      relationships,
    );
    _parseBelongsToMany(
      content,
      sourceTable,
      modelName,
      tableNames,
      modelToTableMap,
      relationships,
    );

    return relationships;
  }

  static void _parseBelongsTo(
    String content,
    String sourceTable,
    String modelName,
    Set<String> tableNames,
    Map<String, String> modelToTableMap,
    List<RelationshipSchema> relationships,
  ) {
    final withParams = <String>{};
    for (final m in _belongsToWithParamsRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      final relatedModel = m.group(2)!;
      final foreignKey = m.group(3);
      final localKey = m.group(4);
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      withParams.add(methodName);
      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.belongsTo,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: foreignKey ?? '${methodName}_id',
            localKey: localKey ?? 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }

    for (final m in _belongsToRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      if (withParams.contains(methodName)) continue;
      final relatedModel = m.group(2)!;
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.belongsTo,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: '${methodName}_id',
            localKey: 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }
  }

  static void _parseHasMany(
    String content,
    String sourceTable,
    String modelName,
    Set<String> tableNames,
    Map<String, String> modelToTableMap,
    List<RelationshipSchema> relationships,
  ) {
    final withParams = <String>{};
    for (final m in _hasManyWithParamsRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      final relatedModel = m.group(2)!;
      final foreignKey = m.group(3);
      final localKey = m.group(4);
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      withParams.add(methodName);
      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.hasMany,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: foreignKey ?? _inferHasForeignKey(modelName),
            localKey: localKey ?? 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }

    for (final m in _hasManyRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      if (withParams.contains(methodName)) continue;
      final relatedModel = m.group(2)!;
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.hasMany,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: _inferHasForeignKey(modelName),
            localKey: 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }
  }

  static void _parseHasOne(
    String content,
    String sourceTable,
    String modelName,
    Set<String> tableNames,
    Map<String, String> modelToTableMap,
    List<RelationshipSchema> relationships,
  ) {
    final withParams = <String>{};
    for (final m in _hasOneWithParamsRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      final relatedModel = m.group(2)!;
      final foreignKey = m.group(3);
      final localKey = m.group(4);
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      withParams.add(methodName);
      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.hasOne,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: foreignKey ?? _inferHasForeignKey(modelName),
            localKey: localKey ?? 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }

    for (final m in _hasOneRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      if (withParams.contains(methodName)) continue;
      final relatedModel = m.group(2)!;
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);

      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.hasOne,
            sourceTable: sourceTable,
            targetTable: targetTable,
            foreignKey: _inferHasForeignKey(modelName),
            localKey: 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }
  }

  static void _parseBelongsToMany(
    String content,
    String sourceTable,
    String modelName,
    Set<String> tableNames,
    Map<String, String> modelToTableMap,
    List<RelationshipSchema> relationships,
  ) {
    final withParams = <String>{};
    for (final m in _belongsToManyWithParamsRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      final relatedModel = m.group(2)!;
      final pivotTable = m.group(3);
      final foreignKey = m.group(4);
      final relatedKey = m.group(5);
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);
      final inferredPivot =
          pivotTable ?? _inferPivotTable(sourceTable, targetTable);

      withParams.add(methodName);
      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.belongsToMany,
            sourceTable: sourceTable,
            targetTable: targetTable,
            pivotTable: inferredPivot,
            foreignKey: foreignKey ?? _inferHasForeignKey(modelName),
            localKey: relatedKey ?? 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }

    for (final m in _belongsToManyRegex.allMatches(content)) {
      final methodName = m.group(1)!;
      if (withParams.contains(methodName)) continue;
      final relatedModel = m.group(2)!;
      final targetTable =
          modelToTableMap[relatedModel] ?? _modelToTableName(relatedModel);
      final inferredPivot = _inferPivotTable(sourceTable, targetTable);

      if (tableNames.contains(sourceTable) &&
          tableNames.contains(targetTable)) {
        relationships.add(
          RelationshipSchema(
            type: RelationshipType.belongsToMany,
            sourceTable: sourceTable,
            targetTable: targetTable,
            pivotTable: inferredPivot,
            foreignKey: _inferHasForeignKey(modelName),
            localKey: 'id',
            isInferred: true,
            methodName: methodName,
          ),
        );
      }
    }
  }

  static String _modelToTableName(String modelName) {
    final stripped = modelName.contains('\\')
        ? modelName.split('\\').last
        : modelName;
    final snake = _camelToSnake(stripped);
    return _pluralize(snake);
  }

  static String _camelToSnake(String input) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == char.toUpperCase() && char != char.toLowerCase()) {
        if (i > 0) buffer.write('_');
        buffer.write(char.toLowerCase());
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static String _pluralize(String word) {
    if (word.isEmpty) return word;
    if (word.endsWith('y') &&
        word.length > 1 &&
        !_isVowel(word[word.length - 2])) {
      return '${word.substring(0, word.length - 1)}ies';
    }
    if (word.endsWith('s') ||
        word.endsWith('sh') ||
        word.endsWith('ch') ||
        word.endsWith('x') ||
        word.endsWith('z')) {
      return '${word}es';
    }
    return '${word}s';
  }

  static bool _isVowel(String char) => 'aeiou'.contains(char.toLowerCase());

  static String _inferHasForeignKey(String modelName) {
    final stripped = modelName.contains('\\')
        ? modelName.split('\\').last
        : modelName;
    return '${_camelToSnake(stripped)}_id';
  }

  static String _inferPivotTable(String table1, String table2) {
    final sorted = [table1, table2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
