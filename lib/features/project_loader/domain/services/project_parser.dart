import 'dart:io';
import '../../../schema_parser/data/parsers/migration_parser.dart';
import '../../../schema_parser/data/parsers/model_parser.dart';
import '../../../schema_parser/domain/models/project_schema.dart';
import '../../../../core/errors/app_exceptions.dart';

class ProjectParserResult {
  final ProjectSchema schema;
  final int migrationCount;
  final int modelCount;
  final bool usedModelInference;

  const ProjectParserResult({
    required this.schema,
    required this.migrationCount,
    required this.modelCount,
    required this.usedModelInference,
  });
}

class ProjectParser {
  ProjectParser._();

  static bool isLaravelProject(String path) {
    final artisan = File('$path/artisan');
    if (!artisan.existsSync()) return false;

    final hasMigrations = Directory('$path/database/migrations').existsSync();
    final hasModels = Directory('$path/app/Models').existsSync();
    final hasApp = Directory('$path/app').existsSync();

    return hasApp && (hasMigrations || hasModels);
  }

  static List<String> validateLaravelProject(String path) {
    final warnings = <String>[];

    if (!File('$path/artisan').existsSync()) {
      throw const InvalidLaravelProjectException(
        suggestion:
            'Ensure the selected directory is the root of a Laravel project (artisan file missing).',
      );
    }

    if (!Directory('$path/database/migrations').existsSync()) {
      warnings.add(
        'No database/migrations directory found. Only model-based relationships will be available.',
      );
    }

    if (!Directory('$path/app/Models').existsSync()) {
      warnings.add(
        'No app/Models directory found. Model-based relationship inference will be unavailable.',
      );
    }

    if (!Directory('$path/vendor').existsSync()) {
      warnings.add(
        'vendor/ directory not found. The project may not have dependencies installed.',
      );
    }

    return warnings;
  }

  static int countMigrationFiles(String projectPath) {
    final dir = Directory('$projectPath/database/migrations');
    if (!dir.existsSync()) return 0;
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.php'))
        .length;
  }

  static int countModelFiles(String projectPath) {
    final dir = Directory('$projectPath/app/Models');
    if (!dir.existsSync()) return 0;
    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.php'))
        .length;
  }

  static ProjectParserResult parse(
    String projectPath, {
    bool enableModelParsing = true,
  }) {
    final projectName = _extractProjectName(projectPath);

    final migrationProject = MigrationParser.parse(
      projectPath,
      projectName: projectName,
    );

    var relationships = List.of(migrationProject.relationships);
    var usedModelInference = false;

    if (enableModelParsing && migrationProject.needsModelParsing) {
      final modelRelationships = ModelParser.parse(
        projectPath,
        tables: migrationProject.tables,
      );
      if (modelRelationships.isNotEmpty) {
        relationships = [...relationships, ...modelRelationships];
        usedModelInference = true;
      }
    }

    final schema = ProjectSchema(
      projectName: projectName,
      tables: migrationProject.tables,
      relationships: relationships,
    );

    return ProjectParserResult(
      schema: schema,
      migrationCount: countMigrationFiles(projectPath),
      modelCount: countModelFiles(projectPath),
      usedModelInference: usedModelInference,
    );
  }

  static String _extractProjectName(String path) {
    final segments = path.split(Platform.pathSeparator);
    if (segments.isEmpty) return 'Unknown Project';
    final last = segments.last;
    return last.isNotEmpty ? last : segments[segments.length - 2];
  }
}
