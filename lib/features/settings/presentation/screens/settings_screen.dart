import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/config_service.dart';
import '../../../../core/providers/config_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _buildSection(
            context,
            title: 'Parsing',
            icon: Icons.analytics_outlined,
            sectionColor: Theme.of(context).extension<AppColors>()!.info,
            children: [
              _buildSwitchTile(
                context,
                icon: Icons.model_training,
                title: 'Model-based inference',
                subtitle:
                    'Infer relationships from model files when no explicit foreign keys are found in migrations',
                value: config.enableModelParsing,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(enableModelParsing: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSwitchTile(
                context,
                icon: Icons.rule,
                title: 'Strict mode',
                subtitle:
                    'Only show explicit foreign keys defined in migrations',
                value: config.strictMode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(strictMode: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSwitchTile(
                context,
                icon: Icons.delete_outline,
                title: 'Include soft-deleted tables',
                subtitle: 'Show tables that have a deleted_at column',
                value: config.includeSoftDeletes,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(includeSoftDeletes: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: 'Display',
            icon: Icons.display_settings,
            sectionColor: Theme.of(
              context,
            ).extension<AppColors>()!.explicitRelation,
            children: [
              _buildSelectorTile(
                context,
                icon: Icons.grid_view,
                title: 'Default layout',
                currentValue: config.defaultLayout,
                options: const [
                  _SelectorOption(
                    value: 'grid',
                    label: 'Grid',
                    description: 'Snap tables to an evenly spaced grid',
                  ),
                  _SelectorOption(
                    value: 'forceDirected',
                    label: 'Force-directed',
                    description: 'Physics-based auto-arrangement',
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(defaultLayout: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSelectorTile(
                context,
                icon: Icons.palette_outlined,
                title: 'Color scheme',
                currentValue: config.colorScheme,
                options: const [
                  _SelectorOption(
                    value: 'light',
                    label: 'Light',
                    description: 'Always use light theme',
                  ),
                  _SelectorOption(
                    value: 'dark',
                    label: 'Dark',
                    description: 'Always use dark theme',
                  ),
                  _SelectorOption(
                    value: 'system',
                    label: 'System',
                    description: 'Follow device setting',
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(colorScheme: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSelectorTile(
                context,
                icon: Icons.timeline,
                title: 'Line style',
                currentValue: config.lineStyle,
                options: const [
                  _SelectorOption(
                    value: 'orthogonal',
                    label: 'Orthogonal',
                    description: 'Right-angle lines like dbdiagram.io',
                  ),
                  _SelectorOption(
                    value: 'curved',
                    label: 'Curved',
                    description: 'Smooth bezier curves between tables',
                  ),
                  _SelectorOption(
                    value: 'straight',
                    label: 'Straight',
                    description: 'Direct diagonal lines',
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(lineStyle: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSelectorTile(
                context,
                icon: Icons.account_tree,
                title: 'Notation style',
                currentValue: config.notationStyle,
                options: const [
                  _SelectorOption(
                    value: 'crowsFoot',
                    label: "Crow's Foot",
                    description: 'Industry standard ERD notation',
                  ),
                  _SelectorOption(
                    value: 'arrow',
                    label: 'Arrow',
                    description: 'Simple arrow notation',
                  ),
                  _SelectorOption(
                    value: 'uml',
                    label: 'UML',
                    description: 'Unified Modeling Language style',
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(notationStyle: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: 'Export',
            icon: Icons.file_download_outlined,
            sectionColor: Theme.of(context).extension<AppColors>()!.success,
            children: [
              _buildSelectorTile(
                context,
                icon: Icons.description_outlined,
                title: 'Default format',
                currentValue: config.defaultExportFormat,
                options: const [
                  _SelectorOption(
                    value: 'mermaid',
                    label: 'Mermaid',
                    description: 'For GitHub, GitLab, docs',
                  ),
                  _SelectorOption(
                    value: 'dbml',
                    label: 'DBML',
                    description: 'For dbdiagram.io',
                  ),
                  _SelectorOption(
                    value: 'html',
                    label: 'HTML',
                    description: 'Interactive SVG diagram',
                  ),
                  _SelectorOption(
                    value: 'markdown',
                    label: 'Markdown',
                    description: 'Data dictionary format',
                  ),
                  _SelectorOption(
                    value: 'plantuml',
                    label: 'PlantUML',
                    description: 'For UML tools',
                  ),
                  _SelectorOption(
                    value: 'graphviz',
                    label: 'Graphviz',
                    description: 'Graph visualization (DOT)',
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(defaultExportFormat: value));
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildSwitchTile(
                context,
                icon: Icons.auto_stories,
                title: 'Auto-include data dictionary',
                subtitle: 'Attach a markdown summary to every export',
                value: config.autoIncludeDataDict,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(autoIncludeDataDict: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: 'Data Management',
            icon: Icons.storage_outlined,
            sectionColor: Theme.of(context).extension<AppColors>()!.warning,
            children: [
              ListTile(
                leading: Icon(
                  Icons.delete_sweep_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: const Text('Clear recent projects'),
                subtitle: const Text('Remove all recent project paths'),
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  await ConfigService.saveRecentProjects([]);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recent projects cleared'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(
                  Icons.restore,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Reset to defaults',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text(
                  'Restore all settings to factory defaults',
                ),
                onTap: () => _showResetDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.account_tree,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version ${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Analyze Laravel projects and generate interactive Entity Relationship Diagrams.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(indent: 24, endIndent: 24),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flutter_dash,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Built with Flutter',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          size: 40,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all settings to their factory defaults.\n\n'
          'Your projects and recent history will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              ref.read(configProvider.notifier).update(AppConfig.defaults());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color sectionColor,
    required List<Widget> children,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: sectionColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SwitchListTile(
      secondary: Icon(
        icon,
        size: 20,
        color: value ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: value ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSelectorTile<T>(
    BuildContext context, {
    required IconData icon,
    required String title,
    required T currentValue,
    required List<_SelectorOption<T>> options,
    required ValueChanged<T> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLabel = options
        .firstWhere((o) => o.value == currentValue, orElse: () => options.first)
        .label;

    return ListTile(
      leading: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              currentLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 20, color: colorScheme.outline),
        ],
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        _showSelectorBottomSheet<T>(
          context,
          title: title,
          currentValue: currentValue,
          options: options,
          onChanged: onChanged,
        );
      },
    );
  }

  void _showSelectorBottomSheet<T>(
    BuildContext context, {
    required String title,
    required T currentValue,
    required List<_SelectorOption<T>> options,
    required ValueChanged<T> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = option.value == currentValue;

                        return InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onChanged(option.value);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.outline,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option.label,
                                        style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        option.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectorOption<T> {
  final T value;
  final String label;
  final String description;

  const _SelectorOption({
    required this.value,
    required this.label,
    required this.description,
  });
}
