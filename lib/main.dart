import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/project_loader/presentation/screens/project_loader_screen.dart';
import 'features/schema_parser/presentation/screens/schema_viewer_screen.dart';
import 'features/erd_viewer/presentation/screens/erd_viewer_screen.dart';
import 'features/export/presentation/screens/export_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'shared/widgets/page_transitions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: LaravelErdApp(),
    ),
  );
}

final currentIndexProvider = StateProvider<int>((ref) => 0);

class LaravelErdApp extends ConsumerStatefulWidget {
  const LaravelErdApp({super.key});

  @override
  ConsumerState<LaravelErdApp> createState() => _LaravelErdAppState();
}

class _LaravelErdAppState extends ConsumerState<LaravelErdApp> {
  bool? _showOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final show = await OnboardingScreen.shouldShow();
    if (mounted) setState(() => _showOnboarding = show);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_tree,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }

    if (_showOnboarding!) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(
          onComplete: () {
            setState(() => _showOnboarding = false);
          },
        ),
      );
    }

    return MaterialApp(
      title: 'Laravel ERD Studio',
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
        title: const Text('Laravel ERD Studio'),
        actions: [
          Semantics(
            label: 'Export diagram',
            child: IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Export ERD',
              onPressed: currentIndex > 0
                  ? () {
                      Navigator.of(context).push(
                        SlideUpPageRoute(
                          page: const ExportScreen(),
                        ),
                      );
                    }
                  : null,
            ),
          ),
          Semantics(
            label: 'Settings',
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).push(
                  AppPageRoute(
                    page: const SettingsScreen(),
                  ),
                );
              },
            ),
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
            selectedIcon: Icon(Icons.folder),
            label: 'Project',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            selectedIcon: Icon(Icons.table_chart),
            label: 'Schema',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree),
            selectedIcon: Icon(Icons.account_tree),
            label: 'ERD',
          ),
        ],
      ),
    );
  }
}
