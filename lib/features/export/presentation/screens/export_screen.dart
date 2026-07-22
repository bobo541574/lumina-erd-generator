import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/export_service.dart';
import '../../../project_loader/presentation/providers/project_provider.dart';
import '../widgets/format_selector.dart';
import '../widgets/preview_pane.dart';

final selectedExportFormatProvider = StateProvider<ExportFormat>(
  (ref) => ExportFormat.mermaid,
);

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final selectedFormat = ref.watch(selectedExportFormatProvider);

    if (!projectState.isParsed) {
      return _buildEmptyState(context);
    }

    final schema = projectState.schema!;
    final content = ExportService.export(schema, selectedFormat);

    return Column(
      children: [
        FormatSelector(
          selectedFormat: selectedFormat,
          onFormatSelected: (format) {
            ref.read(selectedExportFormatProvider.notifier).state = format;
          },
        ),
        Expanded(
          child: PreviewPane(
            content: content,
            format: selectedFormat,
            projectName: schema.projectName,
          ),
        ),
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
            Icons.file_download,
            size: 80,
            color: colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 24),
          Text(
            'No Schema to Export',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Parse a Laravel project first to export\nthe ERD in various formats.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
