import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter/app/router/app_router.dart';
import 'package:base_flutter/main.dart';

void main() {
  testWidgets('SplashScreen renders branding elements and Skip button',
      (WidgetTester tester) async {
    final router = AppRouter.createRouter();
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(router: router),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify SplashScreen elements
    expect(find.text('BaseFlutter'), findsOneWidget);
    expect(find.text('Modern • Modular • Scalable'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
  });

  testWidgets('Tapping Skip navigates from SplashScreen to HomeScreen',
      (WidgetTester tester) async {
    final router = AppRouter.createRouter();
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(router: router),
      ),
    );

    await tester.pump();

    // Tap Skip button
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify HomeScreen elements
    expect(find.text('Hello, Developer 👋'), findsOneWidget);
    expect(find.text('BaseFlutter Home'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('HomeScreen category chips selection and quick actions work',
      (WidgetTester tester) async {
    final router = AppRouter.createRouter();
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(router: router),
      ),
    );

    await tester.pump();

    // Skip to HomeScreen
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Tap 'Overview' chip
    final overviewChip = find.widgetWithText(ChoiceChip, 'Overview');
    expect(overviewChip, findsOneWidget);
    await tester.tap(overviewChip);
    await tester.pumpAndSettle();

    // Scroll until quick action is visible
    final goRouterAction = find.text('GoRouter');
    await tester.scrollUntilVisible(
      goRouterAction,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Tap 'GoRouter' quick action
    await tester.tap(goRouterAction);
    await tester.pump();

    // Verify snackbar feedback
    expect(find.text('GoRouter selected'), findsOneWidget);
  });
}
