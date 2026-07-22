import '../../../schema_parser/domain/models/project_schema.dart';
import '../../../schema_parser/domain/models/relationship_schema.dart';

class MermaidExporter {
  MermaidExporter._();

  static String export(ProjectSchema schema) {
    final buffer = StringBuffer();
    buffer.writeln('erDiagram');

    for (final table in schema.tables) {
      buffer.writeln('    ${table.name.toUpperCase()} {');

      for (final col in table.columns) {
        final type = _mapType(col.type);
        final constraints = <String>[];
        if (col.isPrimaryKey) constraints.add('PK');
        if (col.isForeignKey) constraints.add('FK');
        if (col.unique) constraints.add('UQ');

        final constraintStr =
            constraints.isNotEmpty ? ' ${constraints.join(',')}' : '';
        buffer.writeln('        $type ${col.name}$constraintStr');
      }

      buffer.writeln('    }');
      buffer.writeln();
    }

    for (final rel in schema.relationships) {
      final notation = _relationshipNotation(rel.type);
      final label = rel.methodName ?? '';
      buffer.writeln(
          '    ${rel.sourceTable.toUpperCase()} $notation ${rel.targetTable.toUpperCase()} : $label');
    }

    return buffer.toString();
  }

  static String _mapType(String type) {
    const map = {
      'id': 'bigint',
      'bigIncrements': 'bigint',
      'increments': 'int',
      'string': 'varchar',
      'text': 'text',
      'longText': 'text',
      'mediumText': 'text',
      'integer': 'int',
      'bigInteger': 'bigint',
      'smallInteger': 'int',
      'tinyInteger': 'int',
      'boolean': 'boolean',
      'date': 'date',
      'datetime': 'datetime',
      'timestamp': 'timestamp',
      'json': 'json',
      'float': 'float',
      'double': 'double',
      'decimal': 'decimal',
      'binary': 'binary',
      'uuid': 'uuid',
      'char': 'char',
    };
    return map[type] ?? type;
  }

  static String _relationshipNotation(RelationshipType type) {
    switch (type) {
      case RelationshipType.hasMany:
        return '||--o{';
      case RelationshipType.hasOne:
        return '||--||';
      case RelationshipType.belongsTo:
        return '}o--||';
      case RelationshipType.belongsToMany:
        return '}o--o{';
    }
  }
}
