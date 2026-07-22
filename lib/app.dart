import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/project_loader/presentation/screens/project_loader_screen.dart';
import 'features/schema_parser/presentation/screens/schema_viewer_screen.dart';
import 'features/erd_viewer/presentation/screens/erd_viewer_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class LaravelErdApp extends ConsumerWidget {
  const LaravelErdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Laravel ERD Generator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    ProjectLoaderScreen(),
    SchemaViewerScreen(),
    ErdViewerScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laravel ERD Generator'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            onSelected: (value) {
              // TODO: Handle export
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'mermaid', child: Text('Mermaid')),
              const PopupMenuItem(value: 'dbml', child: Text('DBML')),
              const PopupMenuItem(value: 'html', child: Text('HTML')),
              const PopupMenuItem(value: 'markdown', child: Text('Markdown')),
              const PopupMenuItem(value: 'plantuml', child: Text('PlantUML')),
              const PopupMenuItem(value: 'graphviz', child: Text('Graphviz')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: _screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(currentIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open),
            label: 'Project',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            label: 'Schema',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree),
            label: 'ERD',
          ),
        ],
      ),
    );
  }
}
