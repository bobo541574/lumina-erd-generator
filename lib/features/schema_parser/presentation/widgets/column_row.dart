import 'package:flutter/material.dart';
import '../../domain/models/column_schema.dart';
import '../../../../core/theme/app_colors.dart';

class ColumnRow extends StatelessWidget {
  final ColumnSchema column;
  final bool isEven;

  const ColumnRow({super.key, required this.column, this.isEven = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isEven
          ? null
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
      child: Row(
        children: [
          _buildKeyIcon(context, colorScheme),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: _buildColumnName(context)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildTypeBadge(context)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildConstraints(context)),
        ],
      ),
    );
  }

  Widget _buildKeyIcon(BuildContext context, ColorScheme colorScheme) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (column.isPrimaryKey) {
      return Icon(Icons.vpn_key, size: 16, color: appColors.primaryKey);
    }
    if (column.isForeignKey) {
      return Icon(Icons.link, size: 16, color: appColors.foreignKey);
    }
    return Icon(
      column.nullable ? Icons.remove_circle_outline : Icons.circle,
      size: 8,
      color: column.nullable ? colorScheme.outline : colorScheme.primary,
    );
  }

  Widget _buildColumnName(BuildContext context) {
    return Text(
      column.name,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        fontWeight: column.isPrimaryKey || column.isForeignKey
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final color = _typeColor(column.columnType, appColors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        column.displayType,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: color, fontFamily: 'monospace'),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildConstraints(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final constraints = column.constraints;
    if (constraints.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 3,
      runSpacing: 2,
      children: constraints.map((c) {
        final color = _constraintColor(c, appColors, colorScheme);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            c,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _typeColor(ColumnType type, AppColors appColors) {
    switch (type) {
      case ColumnType.id:
      case ColumnType.bigIncrements:
      case ColumnType.increments:
        return appColors.primaryKey;
      case ColumnType.string:
      case ColumnType.char:
      case ColumnType.text:
      case ColumnType.longText:
      case ColumnType.mediumText:
        return appColors.typeString;
      case ColumnType.integer:
      case ColumnType.bigInteger:
      case ColumnType.smallInteger:
      case ColumnType.tinyInteger:
        return appColors.typeInteger;
      case ColumnType.boolean:
        return appColors.typeBoolean;
      case ColumnType.date:
      case ColumnType.datetime:
      case ColumnType.timestamp:
      case ColumnType.time:
      case ColumnType.year:
        return appColors.typeDate;
      case ColumnType.json:
        return appColors.typeJson;
      case ColumnType.enumType:
        return appColors.typeEnum;
      case ColumnType.float:
      case ColumnType.double:
      case ColumnType.decimal:
        return appColors.typeFloat;
      case ColumnType.binary:
        return appColors.typeBinary;
      case ColumnType.uuid:
        return appColors.typeUuid;
      case ColumnType.foreignId:
      case ColumnType.foreign:
        return appColors.foreignKey;
      case ColumnType.morphs:
      case ColumnType.nullableMorphs:
        return appColors.typeMorphs;
      default:
        return appColors.typeDefault;
    }
  }

  Color _constraintColor(
    String constraint,
    AppColors appColors,
    ColorScheme colorScheme,
  ) {
    switch (constraint) {
      case 'PK':
        return appColors.primaryKey;
      case 'UQ':
        return appColors.info;
      case 'NULL':
        return colorScheme.outline;
      case 'AI':
        return appColors.primaryKey;
      case 'FK':
        return appColors.foreignKey;
      case 'UNSIGNED':
        return appColors.typeJson;
      default:
        return colorScheme.outline;
    }
  }
}
