import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeverse/features/splash/presentation/view/splash_view.dart';

void main() {
  testWidgets('SplashView shows Lottie and navigates after 4 seconds', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
        },
        home: const SplashView(),
      ),
    );

    // Verify Lottie animation is shown
    expect(find.byType(Lottie), findsOneWidget);

    // Wait for 4 seconds + animation frames
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify navigation happened
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
