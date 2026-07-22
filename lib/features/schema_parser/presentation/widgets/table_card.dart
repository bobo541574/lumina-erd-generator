import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/table_schema.dart';
import '../../domain/models/relationship_schema.dart';
import '../../domain/models/column_schema.dart';
import '../screens/schema_viewer_screen.dart';
import 'column_row.dart';
import 'relationship_badge.dart';

class TableCard extends ConsumerWidget {
  final TableSchema table;
  final List<RelationshipSchema> relationships;

  const TableCard({
    super.key,
    required this.table,
    required this.relationships,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedId = ref.watch(expandedTableProvider);
    final isExpanded = expandedId == table.id;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isExpanded ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isExpanded
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, ref, isExpanded, colorScheme),
          if (isExpanded) _buildExpandedContent(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isExpanded,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () {
        final current = ref.read(expandedTableProvider);
        ref.read(expandedTableProvider.notifier).state =
            current == table.id ? null : table.id;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isExpanded
            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        child: Row(
          children: [
            _buildTableIcon(context, colorScheme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        table.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                      ),
                      if (table.isPivot) ...[
                        const SizedBox(width: 8),
                        _buildBadge(context, 'PIVOT', Colors.amber),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildConstraintChips(context),
                ],
              ),
            ),
            _buildCountBadges(context, colorScheme),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableIcon(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.table_chart,
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }

  Widget _buildConstraintChips(BuildContext context) {
    final constraints = table.tableConstraints;
    if (constraints.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: constraints.map((c) {
        final color = _constraintColor(c);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            c,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
          ),
        );
      }).toList(),
    );
  }

  Color _constraintColor(String constraint) {
    if (constraint.startsWith('PK')) return Colors.blue;
    if (constraint.startsWith('FK')) return Colors.orange;
    if (constraint == 'PIVOT') return Colors.amber;
    return Colors.grey;
  }

  Widget _buildCountBadges(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMiniBadge(
          context,
          '${table.columns.length}',
          Icons.view_column,
          colorScheme.primary,
        ),
        if (relationships.isNotEmpty) ...[
          const SizedBox(width: 4),
          _buildMiniBadge(
            context,
            '${relationships.length}',
            Icons.link,
            Colors.purple,
          ),
        ],
      ],
    );
  }

  Widget _buildMiniBadge(
    BuildContext context,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            count,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildColumnsSection(context, colorScheme),
          if (relationships.isNotEmpty) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _buildRelationshipsSection(context, colorScheme),
          ],
          if (table.indexes.isNotEmpty) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _buildIndexesSection(context, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildColumnsSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.view_column, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Columns (${table.columns.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                for (var i = 0; i < table.columns.length; i++) ...[
                  ColumnRow(
                    column: table.columns[i],
                    isEven: i.isEven,
                  ),
                  if (i < table.columns.length - 1)
                    Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipsSection(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, size: 16, color: Colors.purple),
              const SizedBox(width: 6),
              Text(
                'Relationships (${relationships.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: relationships.map((rel) {
              return RelationshipBadge(
                relationship: rel,
                tableName: table.name,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexesSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, size: 16, color: Colors.teal),
              const SizedBox(width: 6),
              Text(
                'Indexes (${table.indexes.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final index in table.indexes)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    index.unique ? Icons.fingerprint : Icons.tag,
                    size: 14,
                    color: index.unique ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    index.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${index.columns.join(', ')})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (index.unique) ...[
                    const SizedBox(width: 4),
                    _buildMiniBadge(context, 'UNIQUE', Icons.check, Colors.orange),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
