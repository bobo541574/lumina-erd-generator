import '../../../schema_parser/domain/models/project_schema.dart';

class GraphvizExporter {
  GraphvizExporter._();

  static String export(ProjectSchema schema) {
    final buffer = StringBuffer();
    buffer.writeln('digraph ERD {');
    buffer.writeln('  rankdir=LR;');
    buffer.writeln('  graph [fontname="Helvetica", fontsize=12];');
    buffer.writeln('  node [shape=record, fontname="Helvetica", fontsize=10];');
    buffer.writeln('  edge [fontname="Helvetica", fontsize=9];');
    buffer.writeln();

    for (final table in schema.tables) {
      final columnsDef = table.columns
          .map((col) {
            final markers = <String>[];
            if (col.isPrimaryKey) markers.add('PK');
            if (col.isForeignKey) markers.add('FK');
            if (col.unique) markers.add('UQ');

            final markerStr = markers.isNotEmpty
                ? ' [{${markers.join(', ')}}]'
                : '';
            return '${col.name} : ${col.displayType}$markerStr';
          })
          .join('\\l ');

      buffer.writeln(
        '  ${table.name} [label="{${table.name}\\l\\l${columnsDef}\\l}"];',
      );
    }

    buffer.writeln();

    for (final rel in schema.relationships) {
      final attrs = <String>[];

      switch (rel.type) {
        case 'belongsTo':
          attrs.add('arrowhead=normal');
          attrs.add('arrowtail=odiamond');
        case 'hasMany':
          attrs.add('arrowhead=normal');
          attrs.add('arrowtail=crow');
        case 'hasOne':
          attrs.add('arrowhead=normal');
          attrs.add('arrowtail=none');
        case 'belongsToMany':
          attrs.add('arrowhead=normal');
          attrs.add('arrowtail=crow');
          attrs.add('style=dashed');
        default:
          attrs.add('arrowhead=normal');
      }

      if (rel.isInferred) {
        attrs.add('color=orange');
        attrs.add('fontcolor=orange');
      } else {
        attrs.add('color=blue');
        attrs.add('fontcolor=blue');
      }

      final label = rel.methodName ?? rel.type.displayName;
      final attrStr = attrs.isNotEmpty ? ' [${attrs.join(', ')}]' : '';
      buffer.writeln(
        '  ${rel.sourceTable} -> ${rel.targetTable} [label="$label"]$attrStr;',
      );
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
