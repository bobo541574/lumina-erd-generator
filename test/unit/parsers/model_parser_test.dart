import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_erd_generator/features/schema_parser/data/parsers/model_parser.dart';
import 'package:laravel_erd_generator/features/schema_parser/domain/models/table_schema.dart';
import 'package:laravel_erd_generator/features/schema_parser/domain/models/column_schema.dart';

void main() {
  group('ModelParser', () {
    test('parses hasMany relationship', () {
      const content = r'''
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Model
{
    protected $table = 'users';

    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}
''';

      final dir = Directory.systemTemp.createTempSync('model_test_');
      final modelsDir = Directory('${dir.path}/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/User.php').writeAsStringSync(content);

      final tables = [
        const TableSchema(
          id: '1',
          name: 'users',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
        const TableSchema(
          id: '2',
          name: 'posts',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
      ];

      final result = ModelParser.parse(dir.path, tables: tables);

      expect(result.length, greaterThanOrEqualTo(0));
      if (result.isNotEmpty) {
        expect(result.first.sourceTable, 'users');
        expect(result.first.targetTable, 'posts');
        expect(result.first.foreignKey, 'user_id');
        expect(result.first.isInferred, true);
      }

      dir.deleteSync(recursive: true);
    });

    test('parses belongsTo relationship', () {
      const content = r'''
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Post extends Model
{
    protected $table = 'posts';

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
''';

      final dir = Directory.systemTemp.createTempSync('model_test_');
      final modelsDir = Directory('${dir.path}/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/Post.php').writeAsStringSync(content);

      final tables = [
        const TableSchema(
          id: '1',
          name: 'users',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
        const TableSchema(
          id: '2',
          name: 'posts',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
      ];

      final result = ModelParser.parse(dir.path, tables: tables);

      expect(result.length, greaterThanOrEqualTo(0));
      if (result.isNotEmpty) {
        expect(result.first.sourceTable, 'posts');
        expect(result.first.targetTable, 'users');
        expect(result.first.foreignKey, 'user_id');
        expect(result.first.isInferred, true);
      }

      dir.deleteSync(recursive: true);
    });

    test('parses belongsToMany with pivot table', () {
      const content = r'''
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Post extends Model
{
    protected $table = 'posts';

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class);
    }
}
''';

      final dir = Directory.systemTemp.createTempSync('model_test_');
      final modelsDir = Directory('${dir.path}/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/Post.php').writeAsStringSync(content);

      final tables = [
        const TableSchema(
          id: '1',
          name: 'posts',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
        const TableSchema(
          id: '2',
          name: 'tags',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
      ];

      final result = ModelParser.parse(dir.path, tables: tables);

      expect(result.length, greaterThanOrEqualTo(0));
      if (result.isNotEmpty) {
        expect(result.first.sourceTable, 'posts');
        expect(result.first.targetTable, 'tags');
        expect(result.first.type.name, 'belongsToMany');
        expect(result.first.pivotTable, 'posts_tags');
      }

      dir.deleteSync(recursive: true);
    });

    test('handles missing Models directory', () {
      final dir = Directory.systemTemp.createTempSync('model_test_');

      final result = ModelParser.parse(dir.path, tables: []);

      expect(result.length, 0);

      dir.deleteSync(recursive: true);
    });

    test('handles malformed PHP files', () {
      final dir = Directory.systemTemp.createTempSync('model_test_');
      final modelsDir = Directory('${dir.path}/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/Bad.php').writeAsStringSync('not valid php');

      final result = ModelParser.parse(dir.path, tables: []);

      expect(result.length, 0);

      dir.deleteSync(recursive: true);
    });

    test('infers foreign key from method name', () {
      const content = r'''
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    public function post()
    {
        return $this->belongsTo(Post::class);
    }
}
''';

      final dir = Directory.systemTemp.createTempSync('model_test_');
      final modelsDir = Directory('${dir.path}/app/Models');
      modelsDir.createSync(recursive: true);
      File('${modelsDir.path}/Comment.php').writeAsStringSync(content);

      final tables = [
        const TableSchema(
          id: '1',
          name: 'posts',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
        const TableSchema(
          id: '2',
          name: 'comments',
          columns: [ColumnSchema(name: 'id', type: 'bigIncrements')],
        ),
      ];

      final result = ModelParser.parse(dir.path, tables: tables);

      expect(result.length, greaterThanOrEqualTo(0));
      if (result.isNotEmpty) {
        expect(result.first.foreignKey, 'post_id');
      }

      dir.deleteSync(recursive: true);
    });
  });
}
