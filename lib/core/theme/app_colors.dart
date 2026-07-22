import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primaryKey;
  final Color foreignKey;
  final Color pivotKey;
  final Color inferredRelation;
  final Color explicitRelation;
  final Color success;
  final Color warning;
  final Color info;

  final Color typeString;
  final Color typeText;
  final Color typeInteger;
  final Color typeBoolean;
  final Color typeDate;
  final Color typeJson;
  final Color typeFloat;
  final Color typeBinary;
  final Color typeUuid;
  final Color typeMorphs;
  final Color typeEnum;
  final Color typeDefault;

  const AppColors({
    required this.primaryKey,
    required this.foreignKey,
    required this.pivotKey,
    required this.inferredRelation,
    required this.explicitRelation,
    required this.success,
    required this.warning,
    required this.info,
    required this.typeString,
    required this.typeText,
    required this.typeInteger,
    required this.typeBoolean,
    required this.typeDate,
    required this.typeJson,
    required this.typeFloat,
    required this.typeBinary,
    required this.typeUuid,
    required this.typeMorphs,
    required this.typeEnum,
    required this.typeDefault,
  });

  static const light = AppColors(
    primaryKey: Color(0xFF1565C0),
    foreignKey: Color(0xFFE65100),
    pivotKey: Color(0xFFF9A825),
    inferredRelation: Color(0xFFEF6C00),
    explicitRelation: Color(0xFF303F9F),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFF57F17),
    info: Color(0xFF0277BD),
    typeString: Color(0xFF00897B),
    typeText: Color(0xFF00897B),
    typeInteger: Color(0xFF3949AB),
    typeBoolean: Color(0xFFE65100),
    typeDate: Color(0xFF7B1FA2),
    typeJson: Color(0xFF5D4037),
    typeFloat: Color(0xFF00838F),
    typeBinary: Color(0xFF546E7A),
    typeUuid: Color(0xFFC62828),
    typeMorphs: Color(0xFFF9A825),
    typeEnum: Color(0xFF4527A0),
    typeDefault: Color(0xFF757575),
  );

  static const dark = AppColors(
    primaryKey: Color(0xFF64B5F6),
    foreignKey: Color(0xFFFF8A65),
    pivotKey: Color(0xFFFFD54F),
    inferredRelation: Color(0xFFFFB74D),
    explicitRelation: Color(0xFF7986CB),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFCA28),
    info: Color(0xFF4FC3F7),
    typeString: Color(0xFF4DB6AC),
    typeText: Color(0xFF4DB6AC),
    typeInteger: Color(0xFF7986CB),
    typeBoolean: Color(0xFFFF8A65),
    typeDate: Color(0xFFBA68C8),
    typeJson: Color(0xFFA1887F),
    typeFloat: Color(0xFF4DD0E1),
    typeBinary: Color(0xFF90A4AE),
    typeUuid: Color(0xFFEF5350),
    typeMorphs: Color(0xFFFFD54F),
    typeEnum: Color(0xFF9575CD),
    typeDefault: Color(0xFF9E9E9E),
  );

  @override
  AppColors copyWith({
    Color? primaryKey,
    Color? foreignKey,
    Color? pivotKey,
    Color? inferredRelation,
    Color? explicitRelation,
    Color? success,
    Color? warning,
    Color? info,
    Color? typeString,
    Color? typeText,
    Color? typeInteger,
    Color? typeBoolean,
    Color? typeDate,
    Color? typeJson,
    Color? typeFloat,
    Color? typeBinary,
    Color? typeUuid,
    Color? typeMorphs,
    Color? typeEnum,
    Color? typeDefault,
  }) {
    return AppColors(
      primaryKey: primaryKey ?? this.primaryKey,
      foreignKey: foreignKey ?? this.foreignKey,
      pivotKey: pivotKey ?? this.pivotKey,
      inferredRelation: inferredRelation ?? this.inferredRelation,
      explicitRelation: explicitRelation ?? this.explicitRelation,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      typeString: typeString ?? this.typeString,
      typeText: typeText ?? this.typeText,
      typeInteger: typeInteger ?? this.typeInteger,
      typeBoolean: typeBoolean ?? this.typeBoolean,
      typeDate: typeDate ?? this.typeDate,
      typeJson: typeJson ?? this.typeJson,
      typeFloat: typeFloat ?? this.typeFloat,
      typeBinary: typeBinary ?? this.typeBinary,
      typeUuid: typeUuid ?? this.typeUuid,
      typeMorphs: typeMorphs ?? this.typeMorphs,
      typeEnum: typeEnum ?? this.typeEnum,
      typeDefault: typeDefault ?? this.typeDefault,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryKey: Color.lerp(primaryKey, other.primaryKey, t)!,
      foreignKey: Color.lerp(foreignKey, other.foreignKey, t)!,
      pivotKey: Color.lerp(pivotKey, other.pivotKey, t)!,
      inferredRelation: Color.lerp(
        inferredRelation,
        other.inferredRelation,
        t,
      )!,
      explicitRelation: Color.lerp(
        explicitRelation,
        other.explicitRelation,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      typeString: Color.lerp(typeString, other.typeString, t)!,
      typeText: Color.lerp(typeText, other.typeText, t)!,
      typeInteger: Color.lerp(typeInteger, other.typeInteger, t)!,
      typeBoolean: Color.lerp(typeBoolean, other.typeBoolean, t)!,
      typeDate: Color.lerp(typeDate, other.typeDate, t)!,
      typeJson: Color.lerp(typeJson, other.typeJson, t)!,
      typeFloat: Color.lerp(typeFloat, other.typeFloat, t)!,
      typeBinary: Color.lerp(typeBinary, other.typeBinary, t)!,
      typeUuid: Color.lerp(typeUuid, other.typeUuid, t)!,
      typeMorphs: Color.lerp(typeMorphs, other.typeMorphs, t)!,
      typeEnum: Color.lerp(typeEnum, other.typeEnum, t)!,
      typeDefault: Color.lerp(typeDefault, other.typeDefault, t)!,
    );
  }
}
