import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_erd_generator/app.dart';

void main() {
  testWidgets('ERD Viewer shows empty state when no schema', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LaravelErdApp()));

    // Navigate to ERD tab
    await tester.tap(find.text('ERD'));
    await tester.pumpAndSettle();

    expect(find.text('No ERD Available'), findsOneWidget);
    expect(
      find.text(
        'Parse a Laravel project first to view\nthe Entity Relationship Diagram.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Schema Viewer shows empty state when no schema', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LaravelErdApp()));

    // Navigate to Schema tab
    await tester.tap(find.text('Schema'));
    await tester.pumpAndSettle();

    expect(find.text('No Schema Loaded'), findsOneWidget);
  });

  testWidgets('Project Loader shows initial state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LaravelErdApp()));

    expect(find.text('Laravel ERD Generator'), findsAtLeastNWidgets(1));
    expect(find.text('Select Laravel Project'), findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LaravelErdApp()));

    // Start on Project tab - should have Select button
    expect(find.text('Select Laravel Project'), findsOneWidget);

    // Navigate to Schema tab
    await tester.tap(find.text('Schema'));
    await tester.pumpAndSettle();
    expect(find.text('No Schema Loaded'), findsOneWidget);

    // Navigate to ERD tab
    await tester.tap(find.text('ERD'));
    await tester.pumpAndSettle();
    expect(find.text('No ERD Available'), findsOneWidget);

    // Navigate back to Project tab
    await tester.tap(find.text('Project'));
    await tester.pumpAndSettle();
    expect(find.text('Select Laravel Project'), findsOneWidget);
  });
}
