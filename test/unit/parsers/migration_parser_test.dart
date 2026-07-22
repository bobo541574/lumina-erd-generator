import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_erd_generator/features/schema_parser/data/parsers/migration_parser.dart';

void main() {
  group('MigrationParser', () {
    test('parses Schema::create with basic columns', () {
      const content = '''
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
''';

      // Write to temp file and parse
      final dir = Directory.systemTemp.createTempSync('migration_test_');
      final migrationsDir = Directory('${dir.path}/database/migrations');
      migrationsDir.createSync(recursive: true);
      File(
        '${migrationsDir.path}/0001_create_users_table.php',
      ).writeAsStringSync(content);

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.length, 1);
      expect(result.tables.first.name, 'users');
      expect(result.tables.first.columns.length, 5);
      expect(result.tables.first.columns[0].name, 'id');
      expect(result.tables.first.columns[0].primary, true);
      expect(result.tables.first.columns[1].name, 'name');
      expect(result.tables.first.columns[2].name, 'email');
      expect(result.tables.first.columns[2].unique, true);

      dir.deleteSync(recursive: true);
    });

    test('parses foreign key relationships', () {
      const content = '''
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
            \$table->foreignId('user_id')->constrained('users');
            \$table->string('title');
            \$table->timestamps();
        });
    }
};
''';

      final dir = Directory.systemTemp.createTempSync('migration_test_');
      final migrationsDir = Directory('${dir.path}/database/migrations');
      migrationsDir.createSync(recursive: true);
      File(
        '${migrationsDir.path}/0001_create_posts_table.php',
      ).writeAsStringSync(content);

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.length, 1);
      expect(result.tables.first.name, 'posts');
      expect(result.tables.first.columns.length, greaterThanOrEqualTo(3));

      dir.deleteSync(recursive: true);
    });

    test('handles empty migrations directory', () {
      final dir = Directory.systemTemp.createTempSync('migration_test_');
      final migrationsDir = Directory('${dir.path}/database/migrations');
      migrationsDir.createSync(recursive: true);

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.length, 0);
      expect(result.relationships.length, 0);

      dir.deleteSync(recursive: true);
    });

    test('handles missing migrations directory', () {
      final dir = Directory.systemTemp.createTempSync('migration_test_');

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.length, 0);

      dir.deleteSync(recursive: true);
    });

    test('parses timestamps and soft deletes', () {
      const content = '''
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
            \$table->string('title');
            \$table->timestamps();
            \$table->softDeletes();
        });
    }
};
''';

      final dir = Directory.systemTemp.createTempSync('migration_test_');
      final migrationsDir = Directory('${dir.path}/database/migrations');
      migrationsDir.createSync(recursive: true);
      File(
        '${migrationsDir.path}/0001_create_posts_table.php',
      ).writeAsStringSync(content);

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.isNotEmpty, true);
      expect(result.tables.first.hasTimestamps, true);
      expect(result.tables.first.hasSoftDeletes, true);

      dir.deleteSync(recursive: true);
    });

    test('parses nullable columns', () {
      const content = '''
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
            \$table->string('body')->nullable();
            \$table->timestamps();
        });
    }
};
''';

      final dir = Directory.systemTemp.createTempSync('migration_test_');
      final migrationsDir = Directory('${dir.path}/database/migrations');
      migrationsDir.createSync(recursive: true);
      File(
        '${migrationsDir.path}/0001_create_posts_table.php',
      ).writeAsStringSync(content);

      final result = MigrationParser.parse(dir.path, projectName: 'test');

      expect(result.tables.isNotEmpty, true);
      final bodyCol = result.tables.first.columns.firstWhere(
        (c) => c.name == 'body',
      );
      expect(bodyCol.nullable, true);

      dir.deleteSync(recursive: true);
    });

    test('extracts project name from path', () {
      final dir = Directory.systemTemp.createTempSync('my_laravel_project_');

      final result = MigrationParser.parse(dir.path);

      expect(result.projectName, isNotEmpty);

      dir.deleteSync(recursive: true);
    });
  });
}
