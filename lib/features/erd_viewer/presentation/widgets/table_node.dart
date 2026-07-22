import 'package:flutter/material.dart';
import '../../../schema_parser/domain/models/table_schema.dart';
import '../../../../core/constants/app_constants.dart';

class TableNode extends StatefulWidget {
  final TableSchema table;
  final bool isSelected;
  final bool isHighlighted;
  final bool compactMode;
  final VoidCallback onTap;
  final ValueChanged<Offset> onDrag;

  const TableNode({
    super.key,
    required this.table,
    this.isSelected = false,
    this.isHighlighted = false,
    this.compactMode = false,
    required this.onTap,
    required this.onDrag,
  });

  @override
  State<TableNode> createState() => _TableNodeState();
}

class _TableNodeState extends State<TableNode> {
  Offset _dragStart = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final columns = widget.compactMode
        ? widget.table.columns.take(5).toList()
        : widget.table.columns;
    final showMore = widget.compactMode && widget.table.columns.length > 5;

    final borderColor = widget.isSelected
        ? colorScheme.primary
        : widget.isHighlighted
            ? Colors.orange
            : colorScheme.outlineVariant;

    final bgColor = widget.isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
        : widget.isHighlighted
            ? Colors.orange.withValues(alpha: 0.05)
            : colorScheme.surface;

    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) {
        _dragStart = details.localPosition;
        _isDragging = false;
      },
      onPanUpdate: (details) {
        if (!_isDragging) {
          final distance = (details.localPosition - _dragStart).distance;
          if (distance > 5) {
            _isDragging = true;
          }
        }
        if (_isDragging) {
          widget.onDrag(details.delta);
        }
      },
      onPanEnd: (_) => _isDragging = false,
      child: Container(
        width: AppConstants.defaultNodeWidth,
        constraints: BoxConstraints(
          minHeight: widget.compactMode ? 80 : AppConstants.defaultNodeMinHeight,
          maxHeight: widget.compactMode ? 200 : AppConstants.defaultNodeMaxHeight,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: widget.isSelected ? 0.12 : 0.06),
              blurRadius: widget.isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, colorScheme),
            _buildColumnList(context, columns, showMore),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.table_chart,
            size: 14,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              widget.table.name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.table.isPivot)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'P',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          const SizedBox(width: 4),
          Text(
            '${widget.table.columns.length}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnList(
    BuildContext context,
    List columns,
    bool showMore,
  ) {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 280),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: columns.length + (showMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (showMore && index == columns.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  '+${widget.table.columns.length - 5} more...',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              );
            }

            final column = columns[index];
            return _buildColumnItem(context, column);
          },
        ),
      ),
    );
  }

  Widget _buildColumnItem(BuildContext context, dynamic column) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        children: [
          _buildColumnIcon(context, column),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              column.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: column.isPrimaryKey || column.isForeignKey
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: column.isPrimaryKey || column.isForeignKey
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _shortType(column.type),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnIcon(BuildContext context, dynamic column) {
    final colorScheme = Theme.of(context).colorScheme;
    if (column.isPrimaryKey) {
      return Icon(Icons.vpn_key, size: 12, color: Colors.blue.shade600);
    }
    if (column.isForeignKey) {
      return Icon(Icons.link, size: 12, color: Colors.orange.shade600);
    }
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: column.nullable ? colorScheme.outline : colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  String _shortType(String type) {
    const shortMap = {
      'bigIncrements': 'bigInc',
      'increments': 'inc',
      'bigInteger': 'bigInt',
      'smallInteger': 'smallInt',
      'tinyInteger': 'tinyInt',
      'string': 'str',
      'longText': 'longText',
      'mediumText': 'medText',
      'timestamp': 'ts',
      'datetime': 'dt',
      'boolean': 'bool',
      'decimal': 'dec',
      'foreignId': 'fkId',
    };
    return shortMap[type] ?? type;
  }
}
