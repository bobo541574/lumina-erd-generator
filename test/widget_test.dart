import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_erd_generator/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LaravelErdApp(),
      ),
    );

    expect(find.text('Laravel ERD Generator'), findsAtLeastNWidgets(1));
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
