import 'package:freezed_annotation/freezed_annotation.dart';

part 'column_schema.freezed.dart';
part 'column_schema.g.dart';

enum ColumnType {
  id,
  bigIncrements,
  increments,
  string,
  text,
  longText,
  mediumText,
  integer,
  bigInteger,
  smallInteger,
  tinyInteger,
  boolean,
  date,
  datetime,
  timestamp,
  json,
  enumType,
  float,
  double,
  decimal,
  binary,
  uuid,
  char,
  ipAddress,
  macAddress,
  year,
  time,
  morphs,
  nullableMorphs,
  foreignId,
  foreign,
  custom;

  static ColumnType fromString(String type) {
    final normalized = type.toLowerCase().trim();
    return ColumnType.values.firstWhere(
      (e) => e.name == normalized || _aliases[normalized] == e,
      orElse: () => ColumnType.custom,
    );
  }

  static final _aliases = {
    'enum': ColumnType.enumType,
    'int': ColumnType.integer,
    'bigint': ColumnType.bigInteger,
    'boolean': ColumnType.boolean,
    'varchar': ColumnType.string,
  };
}

@freezed
class ColumnSchema with _$ColumnSchema {
  const ColumnSchema._();

  const factory ColumnSchema({
    required String name,
    required String type,
    @Default(false) bool nullable,
    @Default(false) bool unique,
    @Default(false) bool primary,
    String? defaultValue,
    int? length,
    @Default(false) bool unsigned,
    @Default(false) bool autoIncrement,
    String? comment,
    String? foreignTable,
    String? foreignColumn,
  }) = _ColumnSchema;

  factory ColumnSchema.fromJson(Map<String, dynamic> json) =>
      _$ColumnSchemaFromJson(json);

  bool get isForeignKey => foreignTable != null;

  bool get isPrimaryKey => primary;

  ColumnType get columnType => ColumnType.fromString(type);

  String get displayType {
    final base = type.toLowerCase();
    if (length != null && !_noLengthTypes.contains(columnType)) {
      return '$base($length)';
    }
    return base;
  }

  static const _noLengthTypes = {
    ColumnType.id,
    ColumnType.bigIncrements,
    ColumnType.increments,
    ColumnType.boolean,
    ColumnType.date,
    ColumnType.datetime,
    ColumnType.timestamp,
    ColumnType.json,
    ColumnType.text,
    ColumnType.longText,
    ColumnType.mediumText,
    ColumnType.binary,
    ColumnType.morphs,
    ColumnType.nullableMorphs,
  };

  List<String> get constraints {
    final c = <String>[];
    if (primary) c.add('PK');
    if (unique) c.add('UQ');
    if (nullable) c.add('NULL');
    if (autoIncrement) c.add('AI');
    if (isForeignKey) c.add('FK');
    if (unsigned) c.add('UNSIGNED');
    return c;
  }
}
