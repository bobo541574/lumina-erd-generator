import 'package:flutter/material.dart';
import '../../../schema_parser/domain/models/table_schema.dart';
import '../../../schema_parser/domain/models/relationship_schema.dart';
import '../../../../core/constants/app_constants.dart';
import 'table_node.dart';
import 'relationship_line.dart';

class ErdCanvas extends StatelessWidget {
  final List<TableSchema> tables;
  final List<RelationshipSchema> relationships;
  final Map<String, Offset> positions;
  final String? selectedTableId;
  final bool compactMode;
  final String lineStyle;
  final String notationStyle;
  final ValueChanged<String> onTableTap;
  final void Function(String tableId, Offset delta) onTableDrag;

  const ErdCanvas({
    super.key,
    required this.tables,
    required this.relationships,
    required this.positions,
    this.selectedTableId,
    this.compactMode = false,
    this.lineStyle = 'curved',
    this.notationStyle = 'crowsFoot',
    required this.onTableTap,
    required this.onTableDrag,
  });

  @override
  Widget build(BuildContext context) {
    final gridColor = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.06);

    return SizedBox(
      width: 3000,
      height: 3000,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(3000, 3000),
            painter: _GridPainter(gridColor: gridColor),
          ),
          ..._buildRelationshipLines(),
          ..._buildTableNodes(),
        ],
      ),
    );
  }

  List<Widget> _buildTableNodes() {
    return tables.map((table) {
      final position = positions[table.name] ?? Offset.zero;
      final isSelected = selectedTableId == table.name;
      final isRelated = selectedTableId != null && _isRelatedToSelected(table);

      return Positioned(
        left: position.dx,
        top: position.dy,
        child: TableNode(
          table: table,
          isSelected: isSelected,
          isHighlighted: isRelated,
          compactMode: compactMode,
          onTap: () => onTableTap(table.name),
          onDrag: (delta) => onTableDrag(table.name, delta),
        ),
      );
    }).toList();
  }

  List<Widget> _buildRelationshipLines() {
    return relationships.map((rel) {
      final sourcePos = positions[rel.sourceTable];
      final targetPos = positions[rel.targetTable];
      if (sourcePos == null || targetPos == null) {
        return const SizedBox.shrink();
      }

      final isHighlighted =
          selectedTableId != null &&
          (rel.sourceTable == selectedTableId ||
              rel.targetTable == selectedTableId);

      return Positioned(
        left: 0,
        top: 0,
        child: IgnorePointer(
          child: CustomPaint(
            size: const Size(3000, 3000),
            painter: RelationshipLine(
              sourcePosition: sourcePos,
              targetPosition: targetPos,
              relationship: rel,
              isHighlighted: isHighlighted,
              nodeWidth: AppConstants.defaultNodeWidth,
              nodeHeight: _estimateNodeHeight(rel.sourceTable),
              lineStyle: lineStyle,
              notationStyle: notationStyle,
              normalColor: _lineColor,
              highlightedColor: _highlightColor,
              inferredColor: _inferredColor,
            ),
          ),
        ),
      );
    }).toList();
  }

  Color get _lineColor => const Color(0x99303F9F);
  Color get _highlightColor => Colors.orange;
  Color get _inferredColor => const Color(0x99EF6C00);

  bool _isRelatedToSelected(TableSchema table) {
    if (selectedTableId == null) return false;
    return relationships.any(
      (r) =>
          (r.sourceTable == selectedTableId && r.targetTable == table.name) ||
          (r.targetTable == selectedTableId && r.sourceTable == table.name),
    );
  }

  double _estimateNodeHeight(String tableName) {
    final table = tables.firstWhere(
      (t) => t.name == tableName,
      orElse: () => tables.first,
    );
    final columnCount = table.columns.length;
    return (44 + columnCount * 24).toDouble().clamp(
      AppConstants.defaultNodeMinHeight,
      AppConstants.defaultNodeMaxHeight,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color gridColor;

  _GridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    const gridSize = 40.0;

    for (var x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (var y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
