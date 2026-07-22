import 'dart:io';
import 'package:path/path.dart' as p;

class FileUtils {
  FileUtils._();

  static String fileNameWithoutExtension(String path) {
    return p.basenameWithoutExtension(path);
  }

  static String extension(String path) {
    return p.extension(path);
  }

  static String join(String part1, [String? part2, String? part3, String? part4]) {
    return p.join(part1, part2, part3, part4);
  }

  static List<File> findPhpFiles(Directory directory) {
    final files = <File>[];
    if (!directory.existsSync()) return files;

    for (final entity in directory.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.php')) {
        files.add(entity);
      }
    }

    return files;
  }

  static bool fileExists(String path) {
    return File(path).existsSync();
  }

  static bool directoryExists(String path) {
    return Directory(path).existsSync();
  }

  static String readFileAsString(String path) {
    return File(path).readAsStringSync();
  }
}
