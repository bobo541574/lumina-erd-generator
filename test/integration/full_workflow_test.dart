import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_erd_generator/features/project_loader/domain/services/project_parser.dart';
import 'package:lumina_erd_generator/features/export/domain/services/export_service.dart';

void main() {
  group('Full Workflow Integration', () {
    late String projectPath;

    setUp(() {
      // Create a mock Laravel project structure
      final dir = Directory.systemTemp.createTempSync('laravel_project_');
      projectPath = dir.path;

      // Create artisan file
      File('$projectPath/artisan').writeAsStringSync('<?php');

      // Create migrations directory with a migration
      final migrationsDir = Directory('$projectPath/database/migrations');
      migrationsDir.createSync(recursive: true);
      File(
        '${migrationsDir.path}/0001_create_users_table.php',
      ).writeAsStringSync('''
<?php
use Illuminate\\Database\\Migrations\\Migration;
use Illuminate\\Database\\Schema\\Blueprint;
use Illuminate\\Support\\Facades\\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint \$table) {
            \$table->id();
            \$table->string('name');
            \$table->string('email')->unique();
            \$table->timestamps();
        });
    }
};
''');

      File(
        '${migrationsDir.path}/0002_create_posts_table.php',
      ).writeAsStringSync('''
<?php
use Illuminate\\Database\\Migrations\\Migration;
use Illuminate\\Database\\Schema\\Blueprint;
use Illuminate\\Support\\Facades\\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('posts', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained();
            \$table->string('title');
            \$table->text('body');
            \$table->timestamps();
        });
    }
};
''');

      // Create Models directory with a model
      final modelsDir = Directory('$projectPath/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/User.php').writeAsStringSync('''
<?php

namespace App\\Models;

use Illuminate\\Database\\Eloquent\\Model;

class User extends Model
{
    protected \$table = 'users';

    public function posts()
    {
        return \$this->hasMany(Post::class);
    }
}
''');
    });

    tearDown(() {
      Directory(projectPath).deleteSync(recursive: true);
    });

    test('validates Laravel project', () {
      expect(ProjectParser.isLaravelProject(projectPath), true);
    });

    test('counts migration and model files', () {
      expect(ProjectParser.countMigrationFiles(projectPath), 2);
      expect(ProjectParser.countModelFiles(projectPath), 1);
    });

    test('parses project and generates schema', () {
      final result = ProjectParser.parse(projectPath);

      expect(result.schema.projectName, isNotEmpty);
      expect(result.schema.tables.length, 2);
      expect(result.migrationCount, 2);
      expect(result.modelCount, 1);

      // Check users table
      final usersTable = result.schema.tables.firstWhere(
        (t) => t.name == 'users',
      );
      expect(
        usersTable.columns.length,
        greaterThanOrEqualTo(3),
      ); // id, name, email

      // Check posts table
      final postsTable = result.schema.tables.firstWhere(
        (t) => t.name == 'posts',
      );
      expect(
        postsTable.columns.length,
        greaterThanOrEqualTo(3),
      ); // id, user_id, title

      // Check relationship
      expect(result.schema.relationships.length, greaterThanOrEqualTo(1));
      final userRel = result.schema.relationships.firstWhere(
        (r) => r.sourceTable == 'posts' && r.targetTable == 'users',
      );
      expect(userRel.foreignKey, 'user_id');
    });

    test('exports to all formats', () {
      final result = ProjectParser.parse(projectPath);
      final exports = ExportService.exportAll(result.schema);

      expect(exports.length, 6);

      for (final export in exports.entries) {
        expect(
          export.value.isNotEmpty,
          true,
          reason: '${export.key.displayName} export should not be empty',
        );
      }
    });

    test('generates valid Mermaid output', () {
      final result = ProjectParser.parse(projectPath);
      final mermaid = ExportService.export(result.schema, ExportFormat.mermaid);

      expect(mermaid, contains('erDiagram'));
      expect(mermaid, contains('USERS'));
      expect(mermaid, contains('POSTS'));
    });

    test('generates valid HTML output', () {
      final result = ProjectParser.parse(projectPath);
      final html = ExportService.export(result.schema, ExportFormat.html);

      expect(html, contains('<!DOCTYPE html>'));
      expect(html, contains('<canvas'));
      expect(html, contains('function draw()'));
    });

    test('generates valid Markdown output', () {
      final result = ProjectParser.parse(projectPath);
      final markdown = ExportService.export(
        result.schema,
        ExportFormat.markdown,
      );

      expect(markdown, contains('#'));
      expect(markdown, contains('## Tables'));
      expect(markdown, contains('| users |'));
      expect(markdown, contains('| posts |'));
    });
  });

  group('Edge Cases', () {
    test('handles project with no migrations', () {
      final dir = Directory.systemTemp.createTempSync('empty_project_');
      File('${dir.path}/artisan').writeAsStringSync('<?php');

      final result = ProjectParser.parse(dir.path);

      expect(result.schema.tables.length, 0);
      expect(result.migrationCount, 0);

      dir.deleteSync(recursive: true);
    });

    test('handles project with no models', () {
      final dir = Directory.systemTemp.createTempSync('no_models_project_');
      File('${dir.path}/artisan').writeAsStringSync('<?php');
      Directory('${dir.path}/database/migrations').createSync(recursive: true);

      final result = ProjectParser.parse(dir.path);

      expect(result.modelCount, 0);

      dir.deleteSync(recursive: true);
    });

    test('handles invalid directory', () {
      // ProjectParser.parse doesn't throw - it returns empty schema
      final result = ProjectParser.parse('/nonexistent/path');
      expect(result.schema.tables.length, 0);
    });
  });
}
