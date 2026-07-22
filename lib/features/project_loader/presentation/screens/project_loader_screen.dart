import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/services/project_parser.dart';
import '../providers/project_provider.dart';
import '../../../../main.dart';

class ProjectLoaderScreen extends ConsumerStatefulWidget {
  const ProjectLoaderScreen({super.key});

  @override
  ConsumerState<ProjectLoaderScreen> createState() =>
      _ProjectLoaderScreenState();
}

class _ProjectLoaderScreenState extends ConsumerState<ProjectLoaderScreen> {
  bool _shouldNavigateToSchema = false;

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);

    ref.listen<ProjectState>(projectProvider, (previous, next) {
      if (previous != null &&
          !previous.isParsed &&
          next.isParsed &&
          !_shouldNavigateToSchema) {
        _shouldNavigateToSchema = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(currentIndexProvider.notifier).state = 1;
            _shouldNavigateToSchema = false;
          }
        });
      }
    });

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: projectState.hasProject
                ? _buildProjectView(context, projectState)
                : _buildEmptyView(context),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      key: const ValueKey('empty'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_open,
          size: 80,
          color: colorScheme.primary.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 24),
        Text(
          'Lumina ERD Studio',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a Laravel project to generate\nan Entity Relationship Diagram.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 40),
        FilledButton.icon(
          onPressed: () => ref.read(projectProvider.notifier).pickDirectory(),
          icon: const Icon(Icons.create_new_folder),
          label: const Text('Select Laravel Project'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        const SizedBox(height: 48),
        _buildStepIndicator(context),
      ],
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final steps = [
      (Icons.folder_open, 'Select'),
      (Icons.verified, 'Validate'),
      (Icons.analytics, 'Parse'),
      (Icons.account_tree, 'View'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                steps[i].$1,
                size: 20,
                color: colorScheme.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Text(
                steps[i].$2,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (i < steps.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: colorScheme.outline,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildProjectView(BuildContext context, ProjectState projectState) {
    return Column(
      key: const ValueKey('project'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, projectState),
        const SizedBox(height: 24),
        if (projectState.isParsing) _buildLoadingState(context),
        if (projectState.hasError) _buildErrorState(context, projectState),
        if (projectState.isParsed) _buildParsedState(context, projectState),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ProjectState projectState) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectState.parserResult?.schema.projectName ??
                            'Project',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        projectState.directoryPath!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      ref.read(projectProvider.notifier).clearProject(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close project',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBreadcrumb(context, projectState),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context, ProjectState projectState) {
    final path = projectState.directoryPath!;
    final parts = path.split('/');
    final displayParts = parts.length > 3
        ? parts.sublist(parts.length - 3)
        : parts;

    return Wrap(
      spacing: 4,
      children: [
        for (var i = 0; i < displayParts.length; i++) ...[
          Text(
            displayParts[i],
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: i == displayParts.length - 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (i < displayParts.length - 1)
            Icon(
              Icons.chevron_right,
              size: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
        ],
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Analyzing Laravel project...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Scanning migrations and models',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ProjectState projectState) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Invalid Project',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              projectState.errorMessage ??
                  'The selected directory is not a valid Laravel project.',
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(projectProvider.notifier).pickDirectory(),
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Try Another Directory'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () =>
                      ref.read(projectProvider.notifier).clearProject(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParsedState(BuildContext context, ProjectState projectState) {
    final result = projectState.parserResult!;
    final schema = result.schema;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (projectState.validationWarnings.isNotEmpty)
          _buildWarningsCard(context, projectState.validationWarnings),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Project Analyzed Successfully',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildStatsGrid(context, result),
                const SizedBox(height: 20),
                if (result.usedModelInference) _buildInferenceNote(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildParseActions(context, projectState),
      ],
    );
  }

  Widget _buildWarningsCard(BuildContext context, List<String> warnings) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Warnings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final warning in warnings)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  warning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, ProjectParserResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    final stats = [
      (
        Icons.table_chart,
        'Tables',
        '${result.schema.tables.length}',
        colorScheme.primary,
      ),
      (
        Icons.file_copy,
        'Migrations',
        '${result.migrationCount}',
        appColors.success,
      ),
      (Icons.code, 'Models', '${result.modelCount}', appColors.warning),
      (
        Icons.link,
        'Relationships',
        '${result.schema.relationships.length}',
        appColors.info,
      ),
      (
        Icons.view_column,
        'Columns',
        '${result.schema.totalColumns}',
        appColors.primaryKey,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stats.map((stat) {
        return Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: stat.$4.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: stat.$4.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(stat.$1, color: stat.$4, size: 24),
              const SizedBox(height: 8),
              Text(
                stat.$3,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: stat.$4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.$2,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInferenceNote(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Relationships inferred from model files (no explicit foreign keys found in migrations).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParseActions(BuildContext context, ProjectState projectState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => ref.read(projectProvider.notifier).pickDirectory(),
          icon: const Icon(Icons.folder_open),
          label: const Text('Open Different Project'),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: projectState.isParsed
              ? () {
                  ref.read(currentIndexProvider.notifier).state = 1;
                }
              : null,
          icon: const Icon(Icons.table_chart),
          label: const Text('View Schema'),
        ),
      ],
    );
  }
}
