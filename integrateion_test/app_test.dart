import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    testWidgets('Complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify weather data is displayed
      expect(find.text('Current Weather'), findsOneWidget);
      expect(find.text('Hourly Forecast'), findsOneWidget);
      expect(find.text('Daily Forecast'), findsOneWidget);
    });
  });
}