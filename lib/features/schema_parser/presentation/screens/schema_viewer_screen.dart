import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/table_schema.dart';
import '../../../project_loader/presentation/providers/project_provider.dart';
import '../widgets/table_card.dart';
import '../../../../core/utils/debouncer.dart';

enum SortMode { alphabetical, columnCount, relationshipCount }

final _debouncedQueryProvider = StateProvider<String>((ref) => '');
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortModeProvider = StateProvider<SortMode>(
  (ref) => SortMode.alphabetical,
);
final showInferredOnlyProvider = StateProvider<bool>((ref) => false);
final expandedTableProvider = StateProvider<String?>((ref) => null);

class SchemaViewerScreen extends ConsumerStatefulWidget {
  const SchemaViewerScreen({super.key});

  @override
  ConsumerState<SchemaViewerScreen> createState() => _SchemaViewerScreenState();
}

class _SchemaViewerScreenState extends ConsumerState<SchemaViewerScreen> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 250));

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);

    if (!projectState.isParsed) {
      return _buildEmptyState(context);
    }

    final schema = projectState.schema!;
    final query = ref.watch(_debouncedQueryProvider);
    final sortMode = ref.watch(sortModeProvider);

    var tables = schema.tables;

    if (query.isNotEmpty) {
      tables = tables
          .where((t) => t.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    tables = _sortTables(tables, schema, sortMode);

    return Column(
      children: [
        _buildToolbar(context, ref, schema, tables.length),
        Expanded(
          child: tables.isEmpty
              ? _buildNoResults(context, query)
              : _buildTableList(context, ref, tables, schema),
        ),
      ],
    );
  }

  List<TableSchema> _sortTables(
    List<TableSchema> tables,
    dynamic schema,
    SortMode mode,
  ) {
    final sorted = List<TableSchema>.from(tables);
    switch (mode) {
      case SortMode.alphabetical:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case SortMode.columnCount:
        sorted.sort((a, b) => b.columns.length.compareTo(a.columns.length));
      case SortMode.relationshipCount:
        sorted.sort((a, b) {
          final aCount = schema.relationships
              .where((r) => r.sourceTable == a.name || r.targetTable == a.name)
              .length;
          final bCount = schema.relationships
              .where((r) => r.sourceTable == b.name || r.targetTable == b.name)
              .length;
          return bCount.compareTo(aCount);
        });
    }
    return sorted;
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Semantics(
        label: 'No schema loaded',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text(
              'No Schema Loaded',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Load a Laravel project first to view\ntable schemas and relationships.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(
    BuildContext context,
    WidgetRef ref,
    dynamic schema,
    int tableCount,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final sortMode = ref.watch(sortModeProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: 'Search tables',
                  hint: 'Type to filter tables by name',
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tables...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _debouncer.run(() {
                        ref.read(_debouncedQueryProvider.notifier).state =
                            value;
                      });
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildSortButton(context, ref, sortMode),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatChip(
                context,
                Icons.table_chart,
                '$tableCount tables',
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                context,
                Icons.view_column,
                '${schema.totalColumns} columns',
                Colors.teal,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                context,
                Icons.link,
                '${schema.relationships.length} relations',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    SortMode currentMode,
  ) {
    return PopupMenuButton<SortMode>(
      icon: Icon(
        Icons.sort,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Sort tables',
      onSelected: (mode) {
        ref.read(sortModeProvider.notifier).state = mode;
      },
      itemBuilder: (context) => [
        _buildSortMenuItem(
          context,
          SortMode.alphabetical,
          'Alphabetical',
          Icons.sort_by_alpha,
          currentMode == SortMode.alphabetical,
        ),
        _buildSortMenuItem(
          context,
          SortMode.columnCount,
          'By Column Count',
          Icons.view_column,
          currentMode == SortMode.columnCount,
        ),
        _buildSortMenuItem(
          context,
          SortMode.relationshipCount,
          'By Relationship Count',
          Icons.link,
          currentMode == SortMode.relationshipCount,
        ),
      ],
    );
  }

  PopupMenuItem<SortMode> _buildSortMenuItem(
    BuildContext context,
    SortMode mode,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return PopupMenuItem(
      value: mode,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No tables matching "$query"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableList(
    BuildContext context,
    WidgetRef ref,
    List<TableSchema> tables,
    dynamic schema,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        final relationships = schema.relationships
            .where(
              (r) => r.sourceTable == table.name || r.targetTable == table.name,
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TableCard(table: table, relationships: relationships),
        );
      },
    );
  }
}
