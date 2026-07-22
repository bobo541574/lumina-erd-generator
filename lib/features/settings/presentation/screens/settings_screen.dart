import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/config_service.dart';

final configProvider = StateNotifierProvider<ConfigNotifier, AppConfig>(
  (ref) => ConfigNotifier(),
);

class ConfigNotifier extends StateNotifier<AppConfig> {
  ConfigNotifier() : super(AppConfig.defaults()) {
    _load();
  }

  Future<void> _load() async {
    state = await ConfigService.load();
  }

  Future<void> update(AppConfig config) async {
    state = config;
    await ConfigService.save(config);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Parsing',
            icon: Icons.analytics,
            children: [
              _buildSwitchTile(
                context,
                title: 'Model-based inference',
                subtitle:
                    'Infer relationships from model files when no explicit FKs found',
                value: config.enableModelParsing,
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(enableModelParsing: value));
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Strict mode',
                subtitle: 'Only show explicit foreign keys from migrations',
                value: config.strictMode,
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(strictMode: value));
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Include soft-deleted tables',
                subtitle: 'Show tables with deleted_at column',
                value: config.includeSoftDeletes,
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(includeSoftDeletes: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Display',
            icon: Icons.display_settings,
            children: [
              _buildDropdownTile(
                context,
                title: 'Default layout',
                value: config.defaultLayout,
                items: const [
                  DropdownMenuItem(value: 'grid', child: Text('Grid')),
                  DropdownMenuItem(
                    value: 'forceDirected',
                    child: Text('Force-directed'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(defaultLayout: value));
                  }
                },
              ),
              _buildDropdownTile(
                context,
                title: 'Color scheme',
                value: config.colorScheme,
                items: const [
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  DropdownMenuItem(value: 'system', child: Text('System')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(colorScheme: value));
                  }
                },
              ),
              _buildDropdownTile(
                context,
                title: 'Line style',
                value: config.lineStyle,
                items: const [
                  DropdownMenuItem(value: 'curved', child: Text('Curved')),
                  DropdownMenuItem(value: 'straight', child: Text('Straight')),
                  DropdownMenuItem(
                    value: 'orthogonal',
                    child: Text('Orthogonal'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(lineStyle: value));
                  }
                },
              ),
              _buildDropdownTile(
                context,
                title: 'Notation style',
                value: config.notationStyle,
                items: const [
                  DropdownMenuItem(
                    value: 'crowsFoot',
                    child: Text("Crow's Foot"),
                  ),
                  DropdownMenuItem(value: 'arrow', child: Text('Arrow')),
                  DropdownMenuItem(value: 'uml', child: Text('UML')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(notationStyle: value));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Export',
            icon: Icons.file_download,
            children: [
              _buildDropdownTile(
                context,
                title: 'Default format',
                value: config.defaultExportFormat,
                items: const [
                  DropdownMenuItem(value: 'mermaid', child: Text('Mermaid')),
                  DropdownMenuItem(value: 'dbml', child: Text('DBML')),
                  DropdownMenuItem(value: 'html', child: Text('HTML')),
                  DropdownMenuItem(value: 'markdown', child: Text('Markdown')),
                  DropdownMenuItem(value: 'plantuml', child: Text('PlantUML')),
                  DropdownMenuItem(value: 'graphviz', child: Text('Graphviz')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(defaultExportFormat: value));
                  }
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Auto-include data dictionary',
                subtitle: 'Include markdown summary with exports',
                value: config.autoIncludeDataDict,
                onChanged: (value) {
                  ref
                      .read(configProvider.notifier)
                      .update(config.copyWith(autoIncludeDataDict: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Data Management',
            icon: Icons.storage,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_sweep),
                title: const Text('Clear recent projects'),
                subtitle: const Text('Remove all recent project paths'),
                onTap: () async {
                  await ConfigService.saveRecentProjects([]);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recent projects cleared')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Reset to defaults'),
                subtitle: const Text('Restore all settings to defaults'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Settings'),
                      content: const Text(
                        'Are you sure you want to reset all settings to defaults?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            ref
                                .read(configProvider.notifier)
                                .update(AppConfig.defaults());
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Settings reset to defaults'),
                              ),
                            );
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'About',
            icon: Icons.info_outline,
            children: [
              ListTile(
                leading: const Icon(Icons.star_rate),
                title: const Text('Rate this app'),
                subtitle: const Text('Help us improve with your rating'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Report a bug'),
                subtitle: const Text('Found an issue? Let us know'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Send feedback'),
                subtitle: const Text('Suggest features or improvements'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Laravel ERD Studio v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile<T>(
    BuildContext context, {
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
