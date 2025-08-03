import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeverse/features/splash/presentation/view_model/splash_view_model.dart';

void main() {
  testWidgets('SplashViewModel navigates to /login after 4 seconds', (
    WidgetTester tester,
  ) async {
    final testWidget = Builder(
      builder: (context) {
        final splashViewModel = SplashViewModel(context);
        splashViewModel.initSplash();
        return const SizedBox();
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
        },
        home: testWidget,
      ),
    );

    // Verify login page not shown initially
    expect(find.text('Login Page'), findsNothing);

    // Pump 4 seconds + small delta to let timer fire and navigation animation run
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Now should find login page widget
    expect(find.text('Login Page'), findsOneWidget);
  });
}
