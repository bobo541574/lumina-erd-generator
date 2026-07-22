import 'package:flutter/material.dart';
import '../../domain/services/export_service.dart';

class FormatSelector extends StatelessWidget {
  final ExportFormat selectedFormat;
  final ValueChanged<ExportFormat> onFormatSelected;

  const FormatSelector({
    super.key,
    required this.selectedFormat,
    required this.onFormatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ExportFormat.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final format = ExportFormat.values[index];
            final isSelected = format == selectedFormat;
            return _buildFormatCard(context, format, isSelected);
          },
        ),
      ),
    );
  }

  Widget _buildFormatCard(
    BuildContext context,
    ExportFormat format,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onFormatSelected(format),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  _formatIcon(format),
                  size: 18,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    format.extension,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              format.displayName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _shortDescription(format),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _formatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.mermaid:
        return Icons.schema;
      case ExportFormat.dbml:
        return Icons.storage;
      case ExportFormat.html:
        return Icons.html;
      case ExportFormat.markdown:
        return Icons.description;
      case ExportFormat.plantuml:
        return Icons.account_tree;
      case ExportFormat.graphviz:
        return Icons.graphic_eq;
    }
  }

  String _shortDescription(ExportFormat format) {
    switch (format) {
      case ExportFormat.mermaid:
        return 'GitHub, GitLab, docs';
      case ExportFormat.dbml:
        return 'dbdiagram.io';
      case ExportFormat.html:
        return 'Interactive SVG';
      case ExportFormat.markdown:
        return 'Data dictionary';
      case ExportFormat.plantuml:
        return 'UML tools';
      case ExportFormat.graphviz:
        return 'Graph visualization';
    }
  }
}
