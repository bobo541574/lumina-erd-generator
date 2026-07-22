import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../schema_parser/domain/models/project_schema.dart';
import '../../../schema_parser/domain/models/table_schema.dart';
import '../../../project_loader/presentation/providers/project_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/config_provider.dart';
import '../widgets/erd_canvas.dart';

enum LayoutMode { grid, forceDirected }

final zoomProvider = StateProvider<double>((ref) => 1.0);
final offsetProvider = StateProvider<Offset>((ref) => Offset.zero);
final showRelationshipsProvider = StateProvider<bool>((ref) => true);
final compactModeProvider = StateProvider<bool>((ref) => false);
final selectedTableProvider = StateProvider<String?>((ref) => null);
final layoutModeProvider = StateProvider<LayoutMode>((ref) {
  final config = ref.read(configProvider);
  return config.defaultLayout == 'forceDirected'
      ? LayoutMode.forceDirected
      : LayoutMode.grid;
});

class ErdViewerScreen extends ConsumerStatefulWidget {
  const ErdViewerScreen({super.key});

  @override
  ConsumerState<ErdViewerScreen> createState() => _ErdViewerScreenState();
}

class _ErdViewerScreenState extends ConsumerState<ErdViewerScreen> {
  final TransformationController _transformationController =
      TransformationController();
  Map<String, Offset> _tablePositions = {};

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);

    if (!projectState.isParsed) {
      return _buildEmptyState(context);
    }

    final schema = ref.watch(filteredSchemaProvider);
    if (schema == null || schema.tables.isEmpty) {
      return _buildEmptyState(context);
    }

    final layoutMode = ref.watch(layoutModeProvider);

    if (_tablePositions.isEmpty || _needsLayoutUpdate(schema)) {
      _calculateLayout(schema, layoutMode);
    }

    return Stack(
      children: [
        _buildCanvas(context, schema),
        _buildControls(context, schema),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_tree,
            size: 80,
            color: colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 24),
          Text(
            'No ERD Available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Parse a Laravel project first to view\nthe Entity Relationship Diagram.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(BuildContext context, ProjectSchema schema) {
    final showRels = ref.watch(showRelationshipsProvider);
    final selectedTable = ref.watch(selectedTableProvider);
    final compact = ref.watch(compactModeProvider);
    final config = ref.watch(configProvider);

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.1,
      maxScale: 3.0,
      boundaryMargin: const EdgeInsets.all(500),
      child: GestureDetector(
        onDoubleTapDown: (details) => _handleDoubleTapDown(details),
        child: ErdCanvas(
          tables: schema.tables,
          relationships: showRels ? schema.relationships : [],
          positions: _tablePositions,
          selectedTableId: selectedTable,
          compactMode: compact,
          lineStyle: config.lineStyle,
          notationStyle: config.notationStyle,
          onTableTap: (tableId) {
            ref.read(selectedTableProvider.notifier).state =
                ref.read(selectedTableProvider) == tableId ? null : tableId;
          },
          onTableDrag: (tableId, delta) {
            setState(() {
              final current = _tablePositions[tableId] ?? Offset.zero;
              _tablePositions[tableId] = current + delta;
            });
          },
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ProjectSchema schema) {
    final colorScheme = Theme.of(context).colorScheme;
    final zoom = ref.watch(zoomProvider);
    final showRels = ref.watch(showRelationshipsProvider);
    final compact = ref.watch(compactModeProvider);

    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildControlCard(
            context,
            colorScheme,
            children: [
              _buildControlButton(
                context,
                icon: Icons.add,
                tooltip: 'Zoom in',
                onPressed: () => _changeZoom(0.2),
              ),
              const SizedBox(height: 4),
              Text(
                '${(zoom * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              _buildControlButton(
                context,
                icon: Icons.remove,
                tooltip: 'Zoom out',
                onPressed: () => _changeZoom(-0.2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildControlCard(
            context,
            colorScheme,
            children: [
              _buildControlButton(
                context,
                icon: Icons.grid_view,
                tooltip: 'Grid layout',
                isActive: ref.read(layoutModeProvider) == LayoutMode.grid,
                onPressed: () {
                  ref.read(layoutModeProvider.notifier).state = LayoutMode.grid;
                  _tablePositions = {};
                },
              ),
              const SizedBox(height: 4),
              _buildControlButton(
                context,
                icon: Icons.blur_on,
                tooltip: 'Force-directed layout',
                isActive:
                    ref.read(layoutModeProvider) == LayoutMode.forceDirected,
                onPressed: () {
                  ref.read(layoutModeProvider.notifier).state =
                      LayoutMode.forceDirected;
                  _tablePositions = {};
                },
              ),
              const Divider(height: 12),
              _buildControlButton(
                context,
                icon: Icons.link,
                tooltip: 'Toggle relationships',
                isActive: showRels,
                onPressed: () {
                  ref.read(showRelationshipsProvider.notifier).state =
                      !showRels;
                },
              ),
              const SizedBox(height: 4),
              _buildControlButton(
                context,
                icon: Icons.view_compact,
                tooltip: 'Toggle compact mode',
                isActive: compact,
                onPressed: () {
                  ref.read(compactModeProvider.notifier).state = !compact;
                },
              ),
              const Divider(height: 12),
              _buildControlButton(
                context,
                icon: Icons.fit_screen,
                tooltip: 'Fit to screen',
                onPressed: _fitToScreen,
              ),
              const SizedBox(height: 4),
              _buildControlButton(
                context,
                icon: Icons.refresh,
                tooltip: 'Reset view',
                onPressed: _resetView,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard(
    BuildContext context,
    ColorScheme colorScheme, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 20,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  void _changeZoom(double delta) {
    final currentZoom = ref.read(zoomProvider);
    final newZoom = (currentZoom + delta).clamp(0.1, 3.0);
    ref.read(zoomProvider.notifier).state = newZoom;

    // Simple approach: just scale from center
    final matrix = _transformationController.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    final scaleDelta = newZoom / currentScale;
    matrix.scale(scaleDelta);
    _transformationController.value = matrix;
  }

  void _fitToScreen() {
    if (_tablePositions.isEmpty) return;

    final minX = _tablePositions.values.map((p) => p.dx).reduce(min);
    final maxX = _tablePositions.values.map((p) => p.dx).reduce(max);
    final minY = _tablePositions.values.map((p) => p.dy).reduce(min);
    final maxY = _tablePositions.values.map((p) => p.dy).reduce(max);

    final contentWidth = maxX - minX + 250;
    final contentHeight = maxY - minY + 300;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        32;

    final scaleX = screenWidth / contentWidth;
    final scaleY = screenHeight / contentHeight;
    final scale = min(scaleX, scaleY).clamp(0.1, 3.0);

    ref.read(zoomProvider.notifier).state = scale;

    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    final offsetX = screenWidth / 2 - centerX * scale;
    final offsetY = screenHeight / 2 - centerY * scale;

    _transformationController.value = Matrix4.identity()
      ..translate(offsetX, offsetY)
      ..scale(scale);
  }

  void _resetView() {
    ref.read(zoomProvider.notifier).state = 1.0;
    ref.read(selectedTableProvider.notifier).state = null;
    _transformationController.value = Matrix4.identity();
    _tablePositions = {};
    setState(() {});
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _fitToScreen();
  }

  bool _needsLayoutUpdate(ProjectSchema schema) {
    if (_tablePositions.isEmpty && schema.tables.isNotEmpty) return true;
    for (final table in schema.tables) {
      if (!_tablePositions.containsKey(table.name)) return true;
    }
    return false;
  }

  void _calculateLayout(ProjectSchema schema, LayoutMode mode) {
    switch (mode) {
      case LayoutMode.grid:
        _calculateGridLayout(schema.tables);
      case LayoutMode.forceDirected:
        _calculateForceDirectedLayout(schema);
    }
  }

  void _calculateGridLayout(List<TableSchema> tables) {
    const nodeWidth = AppConstants.defaultNodeWidth;
    const nodeHeight = AppConstants.defaultNodeMinHeight;
    const gapX = 40.0;
    const gapY = 40.0;

    final columns = max(1, (sqrt(tables.length)).ceil());
    final positions = <String, Offset>{};

    for (var i = 0; i < tables.length; i++) {
      final col = i % columns;
      final row = i ~/ columns;
      positions[tables[i].name] = Offset(
        col * (nodeWidth + gapX),
        row * (nodeHeight + gapY),
      );
    }

    _tablePositions = positions;
  }

  void _calculateForceDirectedLayout(ProjectSchema schema) {
    const nodeWidth = AppConstants.defaultNodeWidth;
    const nodeHeight = AppConstants.defaultNodeMinHeight;
    const iterations = 50;
    const repulsion = 5000.0;
    const attraction = 0.01;
    const damping = 0.9;

    final positions = <String, Offset>{};
    final velocities = <String, Offset>{};
    final random = Random(42);

    for (final table in schema.tables) {
      positions[table.name] = Offset(
        random.nextDouble() * 800 - 400,
        random.nextDouble() * 600 - 300,
      );
      velocities[table.name] = Offset.zero;
    }

    for (var iter = 0; iter < iterations; iter++) {
      final forces = <String, Offset>{};
      for (final table in schema.tables) {
        forces[table.name] = Offset.zero;
      }

      for (var i = 0; i < schema.tables.length; i++) {
        for (var j = i + 1; j < schema.tables.length; j++) {
          final t1 = schema.tables[i];
          final t2 = schema.tables[j];
          final p1 = positions[t1.name]!;
          final p2 = positions[t2.name]!;

          final dx = p2.dx - p1.dx;
          final dy = p2.dy - p1.dy;
          final distance = max(sqrt(dx * dx + dy * dy), 1.0);

          final repulseX = (repulsion / (distance * distance)) * dx / distance;
          final repulseY = (repulsion / (distance * distance)) * dy / distance;

          forces[t1.name] = forces[t1.name]! - Offset(repulseX, repulseY);
          forces[t2.name] = forces[t2.name]! + Offset(repulseX, repulseY);
        }
      }

      for (final rel in schema.relationships) {
        final p1 = positions[rel.sourceTable];
        final p2 = positions[rel.targetTable];
        if (p1 == null || p2 == null) continue;

        final dx = p2.dx - p1.dx;
        final dy = p2.dy - p1.dy;
        final distance = sqrt(dx * dx + dy * dy);

        final attractX = attraction * dx;
        final attractY = attraction * dy;

        forces[rel.sourceTable] =
            forces[rel.sourceTable]! + Offset(attractX, attractY);
        forces[rel.targetTable] =
            forces[rel.targetTable]! - Offset(attractX, attractY);
      }

      for (final table in schema.tables) {
        final force = forces[table.name]!;
        final velocity = (velocities[table.name]! + force) * damping;
        velocities[table.name] = velocity;
        positions[table.name] = positions[table.name]! + velocity;
      }
    }

    if (positions.isNotEmpty) {
      final minX = positions.values.map((p) => p.dx).reduce(min);
      final minY = positions.values.map((p) => p.dy).reduce(min);
      final offset = Offset(-minX + 50, -minY + 50);

      for (final key in positions.keys) {
        positions[key] = positions[key]! + offset;
      }
    }

    _tablePositions = positions;
  }
}
