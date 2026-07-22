import 'dart:collection';
import '../../../features/project_loader/domain/services/project_parser.dart';

class ParseCache {
  static final ParseCache _instance = ParseCache._();
  factory ParseCache() => _instance;
  ParseCache._();

  final _cache = LinkedHashMap<String, _CacheEntry>();
  static const _maxSize = 10;
  static const _maxAge = Duration(minutes: 30);

  ProjectParserResult? get(String path) {
    final entry = _cache[path];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.timestamp) > _maxAge) {
      _cache.remove(path);
      return null;
    }
    return entry.result;
  }

  void put(String path, ProjectParserResult result) {
    if (_cache.length >= _maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[path] = _CacheEntry(result: result, timestamp: DateTime.now());
  }

  void invalidate(String path) {
    _cache.remove(path);
  }

  void clear() {
    _cache.clear();
  }

  int get size => _cache.length;
}

class _CacheEntry {
  final ProjectParserResult result;
  final DateTime timestamp;

  _CacheEntry({required this.result, required this.timestamp});
}
