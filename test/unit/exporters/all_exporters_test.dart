import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_erd_generator/features/export/domain/services/export_service.dart';
import 'package:lumina_erd_generator/features/schema_parser/domain/models/project_schema.dart';
import 'package:lumina_erd_generator/features/schema_parser/domain/models/table_schema.dart';
import 'package:lumina_erd_generator/features/schema_parser/domain/models/column_schema.dart';
import 'package:lumina_erd_generator/features/schema_parser/domain/models/relationship_schema.dart';

void main() {
  late ProjectSchema testSchema;

  setUp(() {
    testSchema = const ProjectSchema(
      projectName: 'TestProject',
      tables: [
        TableSchema(
          id: '1',
          name: 'users',
          columns: [
            ColumnSchema(name: 'id', type: 'bigIncrements', primary: true),
            ColumnSchema(name: 'name', type: 'string'),
            ColumnSchema(name: 'email', type: 'string', unique: true),
          ],
        ),
        TableSchema(
          id: '2',
          name: 'posts',
          columns: [
            ColumnSchema(name: 'id', type: 'bigIncrements', primary: true),
            ColumnSchema(name: 'user_id', type: 'bigInteger'),
            ColumnSchema(name: 'title', type: 'string'),
            ColumnSchema(name: 'body', type: 'text'),
          ],
        ),
      ],
      relationships: [
        RelationshipSchema(
          type: RelationshipType.belongsTo,
          sourceTable: 'posts',
          targetTable: 'users',
          foreignKey: 'user_id',
          localKey: 'id',
        ),
      ],
    );
  });

  group('ExportService', () {
    test('exports to all formats', () {
      final results = ExportService.exportAll(testSchema);

      expect(results.length, ExportFormat.values.length);

      for (final format in ExportFormat.values) {
        expect(results[format], isNotNull);
        expect(results[format]!.isNotEmpty, true);
      }
    });

    test('exports Mermaid format', () {
      final result = ExportService.export(testSchema, ExportFormat.mermaid);

      expect(result, contains('erDiagram'));
      expect(result, contains('USERS'));
      expect(result, contains('POSTS'));
    });

    test('exports DBML format', () {
      final result = ExportService.export(testSchema, ExportFormat.dbml);

      expect(result, contains('Table users'));
      expect(result, contains('Table posts'));
      expect(result, contains('Ref:'));
    });

    test('exports HTML format', () {
      final result = ExportService.export(testSchema, ExportFormat.html);

      expect(result, contains('<!DOCTYPE html>'));
      expect(result, contains('TestProject'));
      expect(result, contains('canvas'));
    });

    test('exports Markdown format', () {
      final result = ExportService.export(testSchema, ExportFormat.markdown);

      expect(result, contains('# TestProject'));
      expect(result, contains('## Tables'));
      expect(result, contains('| users |'));
      expect(result, contains('| posts |'));
    });

    test('exports PlantUML format', () {
      final result = ExportService.export(testSchema, ExportFormat.plantuml);

      expect(result, contains('@startuml'));
      expect(result, contains('@enduml'));
      expect(result, contains('entity users'));
    });

    test('exports Graphviz format', () {
      final result = ExportService.export(testSchema, ExportFormat.graphviz);

      expect(result, contains('digraph ERD'));
      expect(result, contains('users ['));
      expect(result, contains('posts ['));
    });

    test('generates correct file names', () {
      expect(
        ExportService.getFileName('My Project', ExportFormat.mermaid),
        'my_project_erd.mmd',
      );
      expect(
        ExportService.getFileName('My Project', ExportFormat.dbml),
        'my_project_erd.dbml',
      );
      expect(
        ExportService.getFileName('My Project', ExportFormat.html),
        'my_project_erd.html',
      );
      expect(
        ExportService.getFileName('My Project', ExportFormat.markdown),
        'my_project_erd.md',
      );
      expect(
        ExportService.getFileName('My Project', ExportFormat.plantuml),
        'my_project_erd.puml',
      );
      expect(
        ExportService.getFileName('My Project', ExportFormat.graphviz),
        'my_project_erd.dot',
      );
    });
  });
}
