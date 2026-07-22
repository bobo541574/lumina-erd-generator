import 'package:flutter/material.dart';
import '../../domain/models/column_schema.dart';

class ColumnRow extends StatelessWidget {
  final ColumnSchema column;
  final bool isEven;

  const ColumnRow({
    super.key,
    required this.column,
    this.isEven = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isEven ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
      child: Row(
        children: [
          _buildKeyIcon(context, colorScheme),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _buildColumnName(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildTypeBadge(context, colorScheme),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildConstraints(context, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyIcon(BuildContext context, ColorScheme colorScheme) {
    if (column.isPrimaryKey) {
      return Icon(Icons.vpn_key, size: 16, color: Colors.blue.shade600);
    }
    if (column.isForeignKey) {
      return Icon(Icons.link, size: 16, color: Colors.orange.shade600);
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

  Widget _buildTypeBadge(BuildContext context, ColorScheme colorScheme) {
    final color = _typeColor(column.columnType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        column.displayType,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontFamily: 'monospace',
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildConstraints(BuildContext context, ColorScheme colorScheme) {
    final constraints = column.constraints;
    if (constraints.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 3,
      runSpacing: 2,
      children: constraints.map((c) {
        final color = _constraintColor(c);
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

  Color _typeColor(ColumnType type) {
    switch (type) {
      case ColumnType.id:
      case ColumnType.bigIncrements:
      case ColumnType.increments:
        return Colors.blue;
      case ColumnType.string:
      case ColumnType.char:
      case ColumnType.text:
      case ColumnType.longText:
      case ColumnType.mediumText:
        return Colors.teal;
      case ColumnType.integer:
      case ColumnType.bigInteger:
      case ColumnType.smallInteger:
      case ColumnType.tinyInteger:
        return Colors.indigo;
      case ColumnType.boolean:
        return Colors.orange;
      case ColumnType.date:
      case ColumnType.datetime:
      case ColumnType.timestamp:
      case ColumnType.time:
      case ColumnType.year:
        return Colors.purple;
      case ColumnType.json:
        return Colors.brown;
      case ColumnType.enumType:
        return Colors.deepPurple;
      case ColumnType.float:
      case ColumnType.double:
      case ColumnType.decimal:
        return Colors.cyan;
      case ColumnType.binary:
        return Colors.grey;
      case ColumnType.uuid:
        return Colors.pink;
      case ColumnType.foreignId:
      case ColumnType.foreign:
        return Colors.orange;
      case ColumnType.morphs:
      case ColumnType.nullableMorphs:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Color _constraintColor(String constraint) {
    switch (constraint) {
      case 'PK':
        return Colors.blue;
      case 'UQ':
        return Colors.teal;
      case 'NULL':
        return Colors.grey;
      case 'AI':
        return Colors.indigo;
      case 'FK':
        return Colors.orange;
      case 'UNSIGNED':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
