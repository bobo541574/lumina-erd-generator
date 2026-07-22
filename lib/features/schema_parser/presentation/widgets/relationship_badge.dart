import 'package:flutter/material.dart';
import '../../domain/models/relationship_schema.dart';

class RelationshipBadge extends StatelessWidget {
  final RelationshipSchema relationship;
  final String tableName;

  const RelationshipBadge({
    super.key,
    required this.relationship,
    required this.tableName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncoming = relationship.targetTable == tableName;
    final otherTable =
        isIncoming ? relationship.sourceTable : relationship.targetTable;
    final color = relationship.isInferred ? Colors.orange : Colors.blue;

    return Tooltip(
      message: _buildTooltip(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDirectionIcon(isIncoming, color),
            const SizedBox(width: 6),
            _buildTypeLabel(color),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 12, color: color.withValues(alpha: 0.6)),
            const SizedBox(width: 4),
            Text(
              otherTable,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            if (relationship.hasPivot) ...[
              const SizedBox(width: 6),
              _buildPivotChip(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionIcon(bool isIncoming, Color color) {
    if (isIncoming) {
      return Icon(Icons.arrow_circle_down, size: 14, color: color);
    }
    return Icon(Icons.arrow_circle_up, size: 14, color: color);
  }

  Widget _buildTypeLabel(Color color) {
    final label = _shortTypeLabel();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _shortTypeLabel() {
    switch (relationship.type) {
      case RelationshipType.belongsTo:
        return 'BT';
      case RelationshipType.hasMany:
        return 'HM';
      case RelationshipType.hasOne:
        return 'HO';
      case RelationshipType.belongsToMany:
        return 'BTM';
    }
  }

  Widget _buildPivotChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'via ${relationship.pivotTable}',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: Colors.amber.shade700,
        ),
      ),
    );
  }

  String _buildTooltip() {
    final direction = relationship.targetTable == tableName
        ? 'Incoming'
        : 'Outgoing';
    final source = relationship.sourceForeignKey;
    final target = relationship.targetLocalKey;

    return '$direction ${relationship.type.displayName}\n'
        'FK: $source → $target\n'
        '${relationship.isInferred ? "Inferred from models" : "From migration"}'
        '${relationship.hasPivot ? "\nPivot: ${relationship.pivotTable}" : ""}';
  }
}
