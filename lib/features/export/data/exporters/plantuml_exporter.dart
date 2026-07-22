import '../../../schema_parser/domain/models/project_schema.dart';
import '../../../schema_parser/domain/models/relationship_schema.dart';

class PlantUmlExporter {
  PlantUmlExporter._();

  static String export(ProjectSchema schema) {
    final buffer = StringBuffer();
    buffer.writeln('@startuml');
    buffer.writeln();
    buffer.writeln('title ${schema.projectName} - Entity Relationship Diagram');
    buffer.writeln();
    buffer.writeln('skinparam linetype ortho');
    buffer.writeln('skinparam backgroundColor #FEFEFE');
    buffer.writeln('skinparam classBackgroundColor #E8EAF6');
    buffer.writeln('skinparam classBorderColor #3F51B5');
    buffer.writeln();

    for (final table in schema.tables) {
      buffer.writeln('entity ${table.name} {');

      for (final col in table.columns) {
        final markers = <String>[];
        if (col.isPrimaryKey) markers.add('PK');
        if (col.isForeignKey) markers.add('FK');
        if (col.unique) markers.add('UQ');

        final markerStr =
            markers.isNotEmpty ? ' <<${markers.join(', ')}>>' : '';
        buffer.writeln('  * ${col.name} : ${col.displayType}$markerStr');
      }

      buffer.writeln('}');
      buffer.writeln();
    }

    for (final rel in schema.relationships) {
      final notation = _plantUmlNotation(rel.type);
      buffer.writeln(
          '${rel.sourceTable} ${notation} ${rel.targetTable}');
    }

    if (schema.relationships.isNotEmpty) buffer.writeln();

    buffer.writeln('@enduml');

    return buffer.toString();
  }

  static String _plantUmlNotation(RelationshipType type) {
    switch (type) {
      case RelationshipType.belongsTo:
        return '}|--||';
      case RelationshipType.hasMany:
        return '||--{';
      case RelationshipType.hasOne:
        return '||--||';
      case RelationshipType.belongsToMany:
        return '}|--{';
    }
  }
}
