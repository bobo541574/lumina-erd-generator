import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../schema_parser/domain/models/project_schema.dart';
import '../exporters/mermaid_exporter.dart';
import '../exporters/dbml_exporter.dart';
import '../exporters/html_exporter.dart';
import '../exporters/markdown_exporter.dart';
import '../exporters/plantuml_exporter.dart';
import '../exporters/graphviz_exporter.dart';

enum ExportFormat {
  mermaid,
  dbml,
  html,
  markdown,
  plantuml,
  graphviz;

  String get displayName {
    switch (this) {
      case ExportFormat.mermaid:
        return 'Mermaid';
      case ExportFormat.dbml:
        return 'DBML';
      case ExportFormat.html:
        return 'HTML';
      case ExportFormat.markdown:
        return 'Markdown';
      case ExportFormat.plantuml:
        return 'PlantUML';
      case ExportFormat.graphviz:
        return 'Graphviz';
    }
  }

  String get extension {
    switch (this) {
      case ExportFormat.mermaid:
        return '.mmd';
      case ExportFormat.dbml:
        return '.dbml';
      case ExportFormat.html:
        return '.html';
      case ExportFormat.markdown:
        return '.md';
      case ExportFormat.plantuml:
        return '.puml';
      case ExportFormat.graphviz:
        return '.dot';
    }
  }

  String get description {
    switch (this) {
      case ExportFormat.mermaid:
        return 'Mermaid diagram syntax for GitHub, GitLab, and documentation';
      case ExportFormat.dbml:
        return 'Database Markup Language for dbdiagram.io';
      case ExportFormat.html:
        return 'Interactive HTML with SVG rendering and zoom/pan';
      case ExportFormat.markdown:
        return 'Structured data dictionary in Markdown format';
      case ExportFormat.plantuml:
        return 'PlantUML diagram syntax for UML tools';
      case ExportFormat.graphviz:
        return 'Graphviz DOT syntax for graph visualization';
    }
  }

  String get mimeType {
    switch (this) {
      case ExportFormat.html:
        return 'text/html';
      case ExportFormat.markdown:
        return 'text/markdown';
      default:
        return 'text/plain';
    }
  }
}

class ExportService {
  ExportService._();

  static String export(ProjectSchema schema, ExportFormat format) {
    switch (format) {
      case ExportFormat.mermaid:
        return MermaidExporter.export(schema);
      case ExportFormat.dbml:
        return DbmlExporter.export(schema);
      case ExportFormat.html:
        return HtmlExporter.export(schema);
      case ExportFormat.markdown:
        return MarkdownExporter.export(schema);
      case ExportFormat.plantuml:
        return PlantUmlExporter.export(schema);
      case ExportFormat.graphviz:
        return GraphvizExporter.export(schema);
    }
  }

  static Map<ExportFormat, String> exportAll(ProjectSchema schema) {
    return {
      for (final format in ExportFormat.values)
        format: export(schema, format),
    };
  }

  static String getFileName(String projectName, ExportFormat format) {
    final sanitized = projectName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return '${sanitized}_erd${format.extension}';
  }
}
